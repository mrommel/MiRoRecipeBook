//
//  RecipeWebService.h
//  MiRoRecipeBook
//
//  Created by Michael Rommel on 24.11.16.
//  Copyright © 2016 Mobility Media. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RecipeWebService : NSObject

- (void)fetchAllRecipes:(void (^)(NSArray *recipes))callback;

@end
