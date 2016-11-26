//
//  TATravelDataSource.h
//  TravelApp
//
//  Created by Alexander on 11/26/16.
//  Copyright © 2016 Home. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TATravelItem, TASortType, UISegmentedControl;

@interface TATravelDataSource : NSObject
@property (nonatomic, strong, readonly) NSArray *trips;
- (NSInteger)count;
- (TATravelItem *)travelItemAtIndex:(NSInteger)index;
- (void)switchToSortType:(TASortType *)sortType;
- (void)updateInternalStorage:(NSArray *)trips;
- (TASortType *)sortType;
- (void)sortSegmntedControlAction:(id)sender;
- (void)synchronizeSegmentedControl:(UISegmentedControl *)segmntedControl;
@end
