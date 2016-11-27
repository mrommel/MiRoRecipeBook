//
//  RecipeManager.m
//  MiRoRecipeBook
//
//  Created by Michael Rommel on 24.11.16.
//  Copyright © 2016 Mobility Media. All rights reserved.
//

#import "RecipeManager.h"

#import "RecipeWebService.h"
#import <CoreData/CoreData.h>
#import "Recipe.h"
#import "Recipe+CoreDataAccess.h"

@interface RecipeManager()

@property (assign) RecipeWebService* webservice;
@property (assign) NSManagedObjectContext *context;

@end

@implementation RecipeManager

- (id)initWithContext:(NSManagedObjectContext *)context
           webservice:(RecipeWebService *)webservice
{
    self = [super init];

    if (self) {
        self.context = context;
        self.webservice = webservice;
    }
    
    return self;
}

- (void)import
{
    [self.webservice fetchAllRecipes:^(NSArray *recipes) {
        
        if (recipes && [recipes count] > 0) {
            
            // delete all 
            //for (Recipe *recipe in [self allRecipes]) {
                //[self.context deleteObject:recipe];
            //}
            
            [self.context performBlock:^{
                for(NSDictionary *recipeSpec in recipes) {
                    NSString *identifier = [recipeSpec[@"id"] stringValue];
                    Recipe *recipe = [Recipe findOrCreateRecipeWithIdentifier:identifier inContext:self.context];
                    [recipe loadFromDictionary:recipeSpec];
                }
            }];
        }
    }];
}

- (NSArray *)allRecipes
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Recipe"];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"1==1"];
    [request setPredicate:predicate];
    
    NSSortDescriptor *nameSort = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    request.sortDescriptors = [NSArray arrayWithObjects:nameSort, nil];
    
    return [self.context executeFetchRequest:request error:NULL];
}

@end
