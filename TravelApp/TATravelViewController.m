//
//  TATravelTableViewController.m
//  TravelApp
//
//  Created by Alexander on 11/16/16.
//  Copyright © 2016 Home. All rights reserved.
//

#import "TATravelViewController.h"
#import "TAContentOperation.h"
#import "TAContentOPerationCreator.h"
#import "TATravelItem.h"
#import "TATripTableViewCell.h"
#import "UIView+Geometry.h"

#define DEGREES_TO_RADIANS(angle) ((angle) / 180.0 * M_PI)

@interface TATravelViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong, readwrite) TANetworkContext *networkContext;
@property (nonatomic, strong, readwrite) NSOperationQueue *operationQueue;
@end

@implementation TATravelViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
  [self.view addSubview:tableView];
  self.tableView = tableView;
  self.tableView.dataSource = self;
  self.tableView.delegate = self;
  
  self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"sort"] style:UIBarButtonItemStylePlain target:self action:@selector(presentSortView:)];
  
  self.travelDataSource = [TATravelDataSource new];
  
  self.tableView.rowHeight = UITableViewAutomaticDimension;
  self.tableView.estimatedRowHeight = 44.0;
  
  [self.tableView registerClass:[TATripTableViewCell class] forCellReuseIdentifier:@"tripCell"];
  [self.travelDataSource addObserver:self forKeyPath:@"trips" options:NSKeyValueObservingOptionNew context:nil];
  
  if (self.networkContext) {
    TAContentOPerationCreator *creator = [[TAContentOPerationCreator alloc] initWithTravelTableViewController:self];
    [creator create];
    [self.operationQueue addOperations:[creator operations] waitUntilFinished:NO];
  }
  
  
}

- (void)presentSortView:(id)sender {
  UISegmentedControl *segmntedControl = [[UISegmentedControl alloc] initWithItems:@[@"Sort: departure",@"Sort: arrival",@"Sort: duration"]];
  [self.travelDataSource.sortType setIndexForSortTypeControl:segmntedControl];
  [self.navigationController.navigationBar addSubview:segmntedControl];
  [segmntedControl addTarget:self.travelDataSource action:@selector(sortSegmntedControlAction:) forControlEvents:UIControlEventValueChanged];
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object 
                        change:(NSDictionary<NSKeyValueChangeKey,id> *)change
                       context:(void *)context {
  
  __weak __typeof (self) weakSelf = self;
  
  if ([keyPath isEqualToString:@"trips"]) {
    dispatch_async(dispatch_get_main_queue(), ^{
      [weakSelf.tableView reloadData];
    });
  }
}

- (NSOperationQueue *)operationQueue {
  if (!_operationQueue) {
      _operationQueue = [NSOperationQueue new];
      _operationQueue.maxConcurrentOperationCount = 8;
  }
  return _operationQueue;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    self.trips = nil;
}

- (void)setTrips:(NSArray *)trips {
  [self.travelDataSource updateInternalStorage:trips];
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.travelDataSource count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  
  static NSString *CellIdentifier = @"tripCell";
  
  TATripTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
  if (!cell) {
    cell = [[TATripTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
  }
  
  TATravelItem *travelItem = [self.travelDataSource travelItemAtIndex:indexPath.row];
  
  [cell configureWith:travelItem];
  [cell setNeedsUpdateConstraints];
  [cell updateConstraintsIfNeeded];
  
  return cell;
}

- (instancetype)initWithNetworkContext:(TANetworkContext *)context {
  if (self = [super init]) {
    _networkContext = context;
  }
  return self;
}

- (void)dealloc {
  [self removeObserver:self forKeyPath:@"trips"];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
}

@end


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

@end


@implementation TASortType: NSObject

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

- (void)setIndexForSortTypeControl:(UISegmentedControl *)segmntedControl {
  [segmntedControl setSelectedSegmentIndex:[self index]];
}

- (NSInteger)index {
  //should be overriden
  return 0;
}

@end


@implementation TAByArrival: TASortType
- (NSString *)sortKey {
  return @"arrivalDate";
}

- (NSInteger)index {
  return 1;
}
@end

@implementation TAByDeparture: TASortType
- (NSString *)sortKey {
  return @"departureDate";
}

- (NSInteger)index {
  return 0;
}
@end

@implementation TAByDuration: TASortType
- (NSString *)sortKey {
  return @"duration";
}
- (NSInteger)index {
  return 2;
}
@end

