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
#import "TASortType.h"
#import "TATravelDataSource.h"

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
  UISegmentedControl *segmntedControl = [[UISegmentedControl alloc] initWithItems:[self.travelDataSource segmentedControlItems]];
  [self.travelDataSource synchronizeSegmentedControl:segmntedControl];
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




