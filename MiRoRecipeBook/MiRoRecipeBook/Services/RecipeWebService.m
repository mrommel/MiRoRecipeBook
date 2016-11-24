//
//  RecipeWebService.m
//  MiRoRecipeBook
//
//  Created by Michael Rommel on 24.11.16.
//  Copyright © 2016 Mobility Media. All rights reserved.
//

#import "RecipeWebService.h"

@implementation RecipeWebService

- (void)fetchAllRecipes:(void (^)(NSArray *recipes))callback
{
    NSString *urlString = @"http://localhost:8000/recipes/";
    NSURL *url = [NSURL URLWithString:urlString];
    
    NSURLSession *session = [NSURLSession sharedSession];
    [session.configuration.HTTPAdditionalHeaders setValue:@"application/json; indent=4" forKey:@"Accept"];
    
    [[session dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
          if (error) {
              callback(nil);
          } else {
              id result = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
              if ([result isKindOfClass:[NSArray class]]) {
                callback(result);
            }
          }
    }] resume];
}

@end
