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
  
  UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
  UIView *contentView = cell.contentView;
  
  CGAffineTransform translate = CGAffineTransformMakeTranslation(contentView.x_,contentView.y_ - contentView.height_ * 0.25);
  
  CGAffineTransform scale = CGAffineTransformMakeScale(0.6, 0.6);
  CGAffineTransform transform =  CGAffineTransformConcat(translate, scale);
  transform = CGAffineTransformRotate(transform, DEGREES_TO_RADIANS(-10));
  
  UIView *screenShotView = [contentView snapshotViewAfterScreenUpdates:YES];
  [self.view addSubview:screenShotView];
/*
 UIViewAnimationOptionCurveEaseInOut            = 0 << 16, // default
 UIViewAnimationOptionCurveEaseIn               = 1 << 16,
 UIViewAnimationOptionCurveEaseOut              = 2 << 16,
 UIViewAnimationOptionCurveLinear
 */
  [UIView animateWithDuration:2.0
                        delay:0.0
                      options:UIViewAnimationOptionCurveEaseOut
                   animations:^{
                     screenShotView.transform = transform;
                   }completion:^(BOOL finished){
                     // do something if needed
                   }];
}

@end


@interface TATravelDataSource ()
@property (nonatomic, strong) NSArray *sortedByDeparture;
@property (nonatomic, strong) NSArray *sortedByArrival;
@property (nonatomic, strong) NSArray *sortedByDuration;
@property (assign, nonatomic) SortType sortType;
@end
@implementation TATravelDataSource

- (instancetype)init {
  if (self = [super init]) {
    _sortType = ByDeparture;
  }
  return self;
}


- (NSArray *)sortTripsWithDescriptor:(NSSortDescriptor *)sortDescriptor trips:(NSArray *)trips {
  return [trips sortedArrayUsingDescriptors:@[sortDescriptor]];
}

- (NSSortDescriptor *)descriptorWithKey:(NSString *)sortDescriptorKey {
  return [NSSortDescriptor sortDescriptorWithKey:sortDescriptorKey ascending:YES];
}

- (void)updateInternalStorage:(NSArray *)trips {
  self.sortedByArrival = [self sortTripsWithDescriptor:[self descriptorWithKey:@"arrivalDate"] trips:trips];
  self.sortedByDuration = [self sortTripsWithDescriptor:[self descriptorWithKey:@"duration"] trips:trips];
  self.sortedByDeparture = [self sortTripsWithDescriptor:[self descriptorWithKey:@"departureDate"] trips:trips];
  [self willChangeValueForKey:@"trips"];
  _trips = [self switchedTrips];
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

- (NSArray *)switchedTrips {
  NSArray *result;
  switch (self.sortType) {
    case ByArrival:
      result = self.sortedByArrival;
      break;
    case ByDeparture:
      result = self.sortedByDeparture;
      break;
    case ByDuration:
      result = self.sortedByDuration;
      break;
    default:
      break;
  }
  return result;
}

- (void)switchToSortType:(SortType)sortType {
  self.sortType = sortType;
  [self updateInternalStorage:[self switchedTrips]];
}

@end
