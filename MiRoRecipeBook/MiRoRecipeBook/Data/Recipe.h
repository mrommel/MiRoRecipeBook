//
//  Recipe.h
//  MiRoRecipeBook
//
//  Created by Michael Rommel on 24.11.16.
//  Copyright © 2016 Mobility Media. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface Recipe : NSManagedObject

@property (nonatomic, retain) NSString *identifier;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *teaser;
@property (nonatomic, retain) NSString *desc;

@end
