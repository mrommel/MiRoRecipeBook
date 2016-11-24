//
//  CoreDataManager.m
//  eBike
//
//  Created by Liliana Bulgaru on 2/27/13.
//  Copyright (c) 2013 MobilityMedia. All rights reserved.
//

#import "CoreDataManager.h"

@interface CoreDataManager ()

@property (strong, readwrite) NSManagedObjectContext *privateWriterContext;     // background writer MOC tied to the persistent store coordinator
@property (strong, readwrite) NSManagedObjectContext *mainContext;              // main thread MOC having privateWriterContext MOC as parent
@property (nonatomic, strong) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, strong) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (nonatomic, strong) NSURL *databaseURL;
@property (nonatomic, strong) NSString *modelName;
@property (nonatomic, strong) NSString *coreDataStoreType;

- (NSURL *)applicationDocumentsDirectory;

@end

@implementation CoreDataManager

static CoreDataManager *shared = nil;
static CoreDataManager *sharedTests = nil;
static dispatch_once_t onceToken;

#pragma mark - Singleton

+ (CoreDataManager *)sharedInstance
{
    if (sharedTests) {
        return sharedTests;
    }
    dispatch_once(&onceToken, ^{
        shared = [[self alloc] init];
        [shared createManagedObjectContexts];
    });
    
    return shared;
}

- (instancetype)initWithInMemoryStorage
{
    if (sharedTests) {
        return sharedTests;
    }
    if (self = [super init]) {
        [self createInMemoryManagedObjectContexts];
        sharedTests = self;
    }
    
    return self;
}

#pragma mark - Public methods

- (NSManagedObjectContext *)createWorkerContext
{
    NSManagedObjectContext *workerContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    [workerContext setParentContext:self.mainContext];
    return workerContext;
}

- (NSManagedObject *)createNSManagedObjectForClass:(Class)entityClass
{
    NSString *className = [[NSStringFromClass([entityClass class]) componentsSeparatedByString:@"."] lastObject];
    return [self createNSManagedObjectForClassName:className inContext:self.mainContext];
}

- (NSManagedObject *)createNSManagedObjectForClassName:(NSString *)entityClassName
{
    return [self createNSManagedObjectForClassName:entityClassName inContext:self.mainContext];
}

- (NSManagedObject *)createNSManagedObjectForClassName:(NSString *)entityClassName inContext:(NSManagedObjectContext *)context
{
    return [NSEntityDescription insertNewObjectForEntityForName:entityClassName inManagedObjectContext:context];
}

- (void)saveContext
{
    [self saveMainContext];
}

- (void)saveObject:(NSManagedObject *)object
{
    if ([object hasChanges]) {
        [self saveContext:object.managedObjectContext];
    }
}

- (void)deleteObject:(id)object
{
    NSManagedObjectContext *context = ((NSManagedObject *) object).managedObjectContext;
    [context performBlockAndWait:^{
        [context deleteObject:object];
        [self saveContext:context];
    }];
}

- (void)deleteObjects:(NSArray *)objects
{
    if ([objects count] == 0) {
        return;
    }
    NSManagedObjectContext *context = ((NSManagedObject *) objects[0]).managedObjectContext;
    [context performBlockAndWait:^{
        for (NSManagedObject *obj in objects) {
            [context deleteObject:obj];
        }
        [self saveContext:context];
    }];
}

- (NSUInteger)countWithClassName:(NSString *)className andPredicate:(NSPredicate *)predicate
{
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:className];
    fetchRequest.predicate = predicate;
    return [self.mainContext countForFetchRequest:fetchRequest error:nil];
}

- (NSManagedObject *)fetchWithClassName:(NSString *)className andPredicate:(NSPredicate *)predicate
{
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:className];
    fetchRequest.predicate = predicate;
    NSArray *objects = [self dataWithFetchRequest:fetchRequest error:NULL];
    
    return [objects firstObject];
}

- (NSManagedObject *)fetchWithClassName:(NSString *)className andPredicate:(NSPredicate *)predicate context:(NSManagedObjectContext *)context
{
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:className];
    fetchRequest.predicate = predicate;
    NSArray *objects = [context executeFetchRequest:fetchRequest error:nil];
    
    return [objects firstObject];
}

- (NSArray<NSManagedObject *> *)dataWithFetchRequest:(NSFetchRequest *)request error:(NSError **)error
{
    __block NSArray *results = nil;
    [self.mainContext performBlockAndWait:^{
        results = [self.mainContext executeFetchRequest:request error:error];
    }];
    
    return results;
}

- (void)dataWithFetchRequest:(NSFetchRequest *)request completionBlock:(FetchResponseBlock)block
{
    __block NSArray *results = nil;
    __block NSError *errorObj = nil;
    [self.mainContext performBlock:^{
        results = [self.mainContext executeFetchRequest:request error:&errorObj];
        block(results, errorObj);
    }];
}

- (void)rollback
{
    [self.mainContext performBlock:^{
        [self.mainContext rollback];
    }];
}

- (NSManagedObject *)managedObject:(NSManagedObject *)object inContext:(NSManagedObjectContext *)context
{
    __block NSManagedObject *managedObject = nil;
    [context performBlockAndWait:^{
        managedObject = [context objectWithID:[object objectID]];
    }];
    return managedObject;
}

#pragma mark - Core Data stack

/*
 * Returns the managed object model for the application.
 * If the model doesn't already exist, it is created from the application's model.
 */
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"MiRoRecipeBook" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

/*
 * Returns the persistent store coordinator for the application.
 * If the coordinator doesn't already exist, it is created and the application's store added to it.
 */
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator) {
        return _persistentStoreCoordinator;
    }
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"eBikeCDStore.sqlite"];

    // Set up the store (pre-populated default store)
    NSFileManager *fileManager = [NSFileManager defaultManager];
    // If the expected store doesn't exist, copy the default store, if any.
    if (![fileManager fileExistsAtPath:[storeURL path]]) {
        NSURL *defaultStoreURL = [[NSBundle mainBundle] URLForResource:@"eBikeCDStore" withExtension:@"sqlite"];
        if (defaultStoreURL) {
            [fileManager copyItemAtURL:defaultStoreURL toURL:storeURL error:NULL];
        }
    }

    NSDictionary *options = @{NSMigratePersistentStoresAutomaticallyOption : @YES, NSInferMappingModelAutomaticallyOption : @YES};
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];

    NSError *error;
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:options error:&error]) {
        // TODO: Handle the error appropriately
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        //abort();
    }

    return _persistentStoreCoordinator;
}

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:YES error:NULL];
}

#pragma mark - Private methods

- (void)createManagedObjectContexts
{
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    [self setCoordinator:coordinator];
}

- (void)createInMemoryManagedObjectContexts
{
    NSManagedObjectModel *mom = [NSManagedObjectModel mergedModelFromBundles:@[[NSBundle mainBundle]]];
    NSPersistentStoreCoordinator *coordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:mom];
    [coordinator addPersistentStoreWithType:NSInMemoryStoreType configuration:nil URL:nil options:nil error:nil];
    [self setCoordinator:coordinator];
}

- (void)setCoordinator:(NSPersistentStoreCoordinator *)coordinator
{
    // Create the background writer NSManagedObjectContext with concurrency type NSPrivateQueueConcurrenyType
    self.privateWriterContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    self.privateWriterContext.persistentStoreCoordinator = coordinator;
    // Create the main thread NSManagedObjectContext with the concurrency type to NSMainQueueConcurrencyType
    self.mainContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    self.mainContext.parentContext = self.privateWriterContext;
}

- (void)saveMainContext
{
    [self saveContext:self.mainContext];
}

- (void)saveContext:(NSManagedObjectContext *)context
{
    [context performBlockAndWait:^{
        if ([context hasChanges]) {
            if ([context save:NULL]) {
                if (context == self.mainContext) {
                    [self saveToDisk];
                } else {
                    [self saveMainContext];
                }
            }
        }
    }];
}

- (void)saveToDisk
{
    [self.privateWriterContext performBlock:^{
        [self.privateWriterContext save:NULL];
    }];
}

- (NSArray<NSManagedObjectID *> *)idsOfObjects:(NSArray<NSManagedObject *> *)objects
{
    NSMutableArray<NSManagedObjectID *> *ids = [@[] mutableCopy];
    for (NSManagedObject *object in objects) {
        [ids addObject:object.objectID];
    }
    
    return ids;
}

- (NSArray<NSManagedObject *> *)objectsOfIds:(NSArray<NSManagedObjectID *> *)ids
{
    NSMutableArray<NSManagedObject *> *objects = [@[] mutableCopy];
    for (NSManagedObjectID *objectId in ids) {
        NSManagedObject *object = [self.mainContext objectWithID:objectId];
        [objects addObject:object];
    }
    
    return objects;
}

@end
