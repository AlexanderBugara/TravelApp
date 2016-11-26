//
//  TATravelDataSource.m
//  TravelApp
//
//  Created by Alexander on 11/26/16.
//  Copyright © 2016 Home. All rights reserved.
//

#import "TATravelDataSource.h"
#import "TASortType.h"

@interface TATravelDataSource ()
@property (strong, nonatomic) TASortType *sortType;
@property (strong, nonatomic) TAByDeparture *departureType;
@property (strong, nonatomic) TAByArrival *arrivalType;
@property (strong, nonatomic) TAByDuration *durationType;
@end
@implementation TATravelDataSource


- (TAByDeparture *)departureType {
  if (!_departureType) {
    _departureType = [TAByDeparture new];
  }
  return _departureType;
}

- (TAByArrival *)arrivalType {
  if (!_arrivalType) {
    _arrivalType = [TAByArrival new];
  }
  return _arrivalType;
}

- (TAByDuration *)durationType {
  if (!_durationType) {
    _durationType = [TAByDuration new];
  }
  return _durationType;
}



- (instancetype)init {
  if (self = [super init]) {
    _sortType = [self departureType];
    
  }
  return self;
}



- (void)updateInternalStorage:(NSArray *)trips {
  [self.departureType setTrips:trips];
  [self.arrivalType setTrips:trips];
  [self.durationType setTrips:trips];
  
  [self willChangeValueForKey:@"trips"];
  [self didChangeValueForKey:@"trips"];
}


- (NSInteger)count {
  return [self.trips count];
}

- (TATravelItem *)travelItemAtIndex:(NSInteger)index {
  if (index < [self.trips count])
    return self.trips[index];
  return nil;
}



- (void)switchToSortType:(TASortType *)sortType {
  [self willChangeValueForKey:@"trips"];
  self.sortType = sortType;
  [self didChangeValueForKey:@"trips"];
}

- (NSArray *)trips {
  return self.sortType.sortedTrips;
}

- (TASortType *)sortType {
  return _sortType;
}

- (void)sortSegmntedControlAction:(id)sender {
  if ([sender isKindOfClass:[UISegmentedControl class]]) {
    for (TASortType *sortType in [self allTypesObjects]) {
      if ([sortType index] == [(UISegmentedControl *)sender selectedSegmentIndex]) {
        [self switchToSortType:sortType];
        break;
      }
    }
    
  }
}

- (NSArray *)allTypesObjects {
  return @[self.departureType, self.arrivalType, self.durationType];
}

- (void)synchronizeSegmentedControl:(UISegmentedControl *)segmntedControl {
  [segmntedControl setSelectedSegmentIndex:[self.sortType index]];
}
@end
