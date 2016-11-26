//
//  TAContentOPerationCreator.h
//  TravelApp
//
//  Created by Alexander on 11/25/16.
//  Copyright © 2016 Home. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TATravelViewController;

@interface TAContentOPerationCreator : NSObject
@property (nonatomic, strong, readonly) NSArray *operations;

- (instancetype)initWithTravelTableViewController:(TATravelViewController *)travelViewController;
- (void)create;
@end
