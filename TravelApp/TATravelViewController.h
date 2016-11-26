//
//  TATravelTableViewController.h
//  TravelApp
//
//  Created by Alexander on 11/16/16.
//  Copyright © 2016 Home. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TANetworkContext, TATravelItem;

typedef enum {
  ByArrival,
  ByDeparture,
  ByDuration
} SortType;

@interface TATravelDataSource : NSObject
@property (nonatomic, strong, readonly) NSArray *trips;
- (NSInteger)count;
- (TATravelItem *)travelItemAtIndex:(NSInteger)index;
- (void)switchToSortType:(SortType)sortType;
- (void)updateInternalStorage:(NSArray *)trips;
@end

@interface TATravelViewController : UIViewController
- (instancetype)initWithNetworkContext:(TANetworkContext *)context;
- (void)setTrips:(NSArray *)trips;

@property (nonatomic, strong, readonly) TANetworkContext *networkContext;
@property (nonatomic, strong) NSError *error;
@property (nonatomic, strong) TATravelDataSource *travelDataSource;
@property (nonatomic, weak) UITableView *tableView;
@end
