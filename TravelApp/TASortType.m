//
//  TASortType.m
//  TravelApp
//
//  Created by Alexander on 11/26/16.
//  Copyright © 2016 Home. All rights reserved.
//

#import "TASortType.h"


@implementation TASortType
- (void)setTrips:(NSArray *)trips {
  if (_sortedTrips != trips) {
    _sortedTrips = [self sortTripsWithDescriptor:[self descriptorWithKey:[self sortKey]] trips:trips];
  }
}

- (NSArray *)sortTripsWithDescriptor:(NSSortDescriptor *)sortDescriptor trips:(NSArray *)trips {
  return [trips sortedArrayUsingDescriptors:@[sortDescriptor]];
}

- (NSSortDescriptor *)descriptorWithKey:(NSString *)sortDescriptorKey {
  return [NSSortDescriptor sortDescriptorWithKey:sortDescriptorKey ascending:YES];
}

- (NSString *)sortKey {
  //should be overriden
  return @"";
}

- (NSInteger)index {
  //should be overriden
  return 0;
}

- (NSString *)title {
  //should be overriden
  return @"";
}
@end


@implementation TAByArrival: TASortType
- (NSString *)sortKey {
  return @"arrivalDate";
}

- (NSInteger)index {
  return 1;
}

- (NSString *)title {
  return @"Sort: arrival";
}
@end

@implementation TAByDeparture: TASortType
- (NSString *)sortKey {
  return @"departureDate";
}

- (NSInteger)index {
  return 0;
}

- (NSString *)title {
  return @"Sort: departure";
}
@end

@implementation TAByDuration: TASortType
- (NSString *)sortKey {
  return @"duration";
}
- (NSInteger)index {
  return 2;
}

- (NSString *)title {
  return @"Sort: duration";
}
@end


