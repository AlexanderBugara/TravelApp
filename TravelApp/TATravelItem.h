//
//  TATravelItem.h
//  TravelApp
//
//  Created by Alexander on 11/25/16.
//  Copyright © 2016 Home. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TATravelItem : NSObject<NSCoding>

@property (nonatomic, strong, readonly) NSString *arrival_time;
@property (nonatomic, strong, readonly) NSString *departure_time;
@property (nonatomic, strong, readonly) NSNumber *id_;
@property (nonatomic, strong, readonly) NSNumber *number_of_stops;
@property (nonatomic, strong, readonly) NSString *price_in_euros;
@property (nonatomic, strong, readonly) NSString *provider_logo;
@property (nonatomic, strong, readonly) NSNumber *duration;
@property (nonatomic, strong, readonly) NSDate *departureDate;
@property (nonatomic, strong, readonly) NSDate *arrivalDate;


- (instancetype)initWithJSON:(NSDictionary *)json;
- (NSString *)durationString;
@end
