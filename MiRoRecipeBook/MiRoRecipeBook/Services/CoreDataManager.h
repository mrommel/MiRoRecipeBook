//
//  SmartReceipt
//  CoreDataManager.h
//
//  Created by Liliana Bulgaru on 2/27/13.
//  Copyright (c) 2013 MobilityMedia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

typedef void (^FetchResponseBlock)(NSArray *result, NSError *error);
typedef void (^SaveCompleteBlock)();

@interface CoreDataManager : NSObject

@property (strong, readonly) NSManagedObjectContext *mainContext;            // main thread MOC
@property (strong, readonly) NSManagedObjectContext *privateWriterContext;   // PSC writer background thread MOC

+ (CoreDataManager *)sharedInstance;

/// This creates a shared instance that uses in memory CoreData. You have to call this method first, then you can use sharedInstance
- (instancetype)initWithInMemoryStorage;

// Creation methods
- (NSManagedObjectContext *)createWorkerContext;

- (NSManagedObject *)createNSManagedObjectForClass:(Class)entityClass;

- (NSManagedObject *)createNSManagedObjectForClassName:(NSString *)entityClassName;

- (NSManagedObject *)createNSManagedObjectForClassName:(NSString *)entityClassName inContext:(NSManagedObjectContext *)context;

// Save methods
- (void)saveContext;

/**
 Saves in this order: the temporary context, main context, then writes to disk
 */
- (void)saveContext:(NSManagedObjectContext *)context;

- (void)saveObject:(NSManagedObject *)object;

// Delete methods
- (void)deleteObject:(NSManagedObject *)object;

- (void)deleteObjects:(NSArray *)objects;

- (NSUInteger)countWithClassName:(NSString *)className andPredicate:(NSPredicate *)predicate;

// Fetch data methods
- (NSManagedObject *)fetchWithClassName:(NSString *)className andPredicate:(NSPredicate *)predicate;

- (NSManagedObject *)fetchWithClassName:(NSString *)className andPredicate:(NSPredicate *)predicate context:(NSManagedObjectContext *)context;

- (NSArray<NSManagedObject *> *)dataWithFetchRequest:(NSFetchRequest *)request error:(NSError **)error;

- (void)dataWithFetchRequest:(NSFetchRequest *)request completionBlock:(FetchResponseBlock)block;

// Reset data
- (void)rollback;

// Convert the given object to the given context
- (NSManagedObject *)managedObject:(NSManagedObject *)object inContext:(NSManagedObjectContext *)context;

- (NSArray<NSManagedObjectID *> *)idsOfObjects:(NSArray<NSManagedObject *> *)objects;

- (NSArray<NSManagedObject *> *)objectsOfIds:(NSArray<NSManagedObjectID *> *)ids;

@end
