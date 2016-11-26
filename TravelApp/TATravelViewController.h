//
//  TATravelTableViewController.h
//  TravelApp
//
//  Created by Alexander on 11/16/16.
//  Copyright © 2016 Home. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TANetworkContext, TATravelItem;

@interface TASortType: NSObject
@property (nonatomic, strong, readonly) NSArray *sortedTrips;
- (void)setTrips:(NSArray *)trips;
- (void)setIndexForSortTypeControl:(UISegmentedControl *)segmntedControl;
- (NSInteger)index;
@end

@interface TAByArrival: TASortType
@end

@interface TAByDeparture: TASortType
@end

@interface TAByDuration: TASortType
@end




@interface TATravelDataSource : NSObject
@property (nonatomic, strong, readonly) NSArray *trips;
- (NSInteger)count;
- (TATravelItem *)travelItemAtIndex:(NSInteger)index;
- (void)switchToSortType:(TASortType *)sortType;
- (void)updateInternalStorage:(NSArray *)trips;
- (TASortType *)sortType;
- (void)sortSegmntedControlAction:(id)sender;
@end

@interface TATravelViewController : UIViewController
- (instancetype)initWithNetworkContext:(TANetworkContext *)context;
- (void)setTrips:(NSArray *)trips;


@property (nonatomic, strong, readonly) TANetworkContext *networkContext;
@property (nonatomic, strong) NSError *error;
@property (nonatomic, strong) TATravelDataSource *travelDataSource;
@property (nonatomic, weak) UITableView *tableView;
@end
