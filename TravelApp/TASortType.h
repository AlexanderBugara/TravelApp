//
//  TASortType.h
//  TravelApp
//
//  Created by Alexander on 11/26/16.
//  Copyright © 2016 Home. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface TASortType: NSObject
@property (nonatomic, strong, readonly) NSArray *sortedTrips;
- (void)setTrips:(NSArray *)trips;
- (NSInteger)index;
- (NSString *)title;
@end

@interface TAByArrival: TASortType
@end

@interface TAByDeparture: TASortType
@end

@interface TAByDuration: TASortType
@end

