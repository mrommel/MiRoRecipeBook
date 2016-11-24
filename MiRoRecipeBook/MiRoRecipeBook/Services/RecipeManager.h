//
//  RecipeManager.h
//  MiRoRecipeBook
//
//  Created by Michael Rommel on 24.11.16.
//  Copyright © 2016 Mobility Media. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RecipeWebService;
@class NSManagedObjectContext;

@interface RecipeManager : NSObject

- (id)initWithContext:(NSManagedObjectContext *)context
           webservice:(RecipeWebService *)webservice;

- (void)import;

- (NSArray *)allRecipes;

@end
