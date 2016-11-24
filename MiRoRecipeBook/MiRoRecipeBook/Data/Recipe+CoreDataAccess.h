//
//  Recipe (CoreDataAccess).h
//  MiRoRecipeBook
//
//  Created by Michael Rommel on 24.11.16.
//  Copyright © 2016 Mobility Media. All rights reserved.
//

#import "Recipe.h"

@interface Recipe (CoreDataAccess)

- (void)loadFromDictionary:(NSDictionary *)dict;

+ (Recipe *)findOrCreateRecipeWithIdentifier:(NSString *)identifier inContext:(NSManagedObjectContext*)context;

@end
