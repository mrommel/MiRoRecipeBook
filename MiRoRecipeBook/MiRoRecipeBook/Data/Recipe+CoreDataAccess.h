//
//  Recipe (CoreDataAccess).h
//  MiRoRecipeBook
//
//  Created by Michael Rommel on 24.11.16.
//  Copyright © 2016 Mobility Media. All rights reserved.
//

#import "Recipe.h"

@interface Recipe (CoreDataAccess)

+ (Recipe *)findOrCreateRecipeWithIdentifier:(NSString *)identifier inContext:(NSManagedObjectContext*)context;

- (void)loadFromDictionary:(NSDictionary *)dict;
- (NSString *)description;

@end
