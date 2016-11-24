//
//  Recipe (CoreDataAccess).m
//  MiRoRecipeBook
//
//  Created by Michael Rommel on 24.11.16.
//  Copyright © 2016 Mobility Media. All rights reserved.
//

#import "Recipe+CoreDataAccess.h"

@implementation Recipe (CoreDataAccess)

- (void)loadFromDictionary:(NSDictionary *)dict
{
    self.name = [dict objectForKey:@"name"];
    self.teaser = [dict objectForKey:@"teaser"];
    self.desc = [dict objectForKey:@"description"];
}

+ (Recipe *)findOrCreateRecipeWithIdentifier:(NSString *)identifier inContext:(NSManagedObjectContext*)context
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Recipe"];
    request.predicate = [NSPredicate predicateWithFormat:@"identifier == %@", identifier];
    NSArray *results = [context executeFetchRequest:request error:NULL];
    
    if (results && [results count] > 0) {
        return [results firstObject];
    } else {
        Recipe *recipe = (Recipe*)[NSEntityDescription insertNewObjectForEntityForName:@"Recipe" inManagedObjectContext:context];
        recipe.identifier = identifier;
        
        NSError *error;
        if (![context save:&error]) {
            NSLog(@"error description is : %@",error.localizedDescription);
        } else {
            NSLog(@"Saved");
        }
        
        return recipe;
    }
}

@end
