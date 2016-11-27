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
#import "Masonry.h"
#import "TAOfferViewContoller.h"
#import "TATransitionDelegate.h"

@interface TATravelViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong, readwrite) TANetworkContext *networkContext;
@property (nonatomic, strong, readwrite) NSOperationQueue *operationQueue;
@property (nonatomic, weak) UIView *sortView;
@end

@implementation TATravelViewController


- (void)viewDidLoad {
  [super viewDidLoad];
  
  UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
  [self.view addSubview:tableView];
  [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.edges.equalTo(self.view);
  }];
  
  
  self.tableView = tableView;
  self.tableView.dataSource = self;
  self.tableView.delegate = self;
  
  self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"sort"] style:UIBarButtonItemStylePlain target:self action:@selector(sortViewPresentingAction:)];
  
  self.travelDataSource = [TATravelDataSource new];
  
  self.tableView.rowHeight = UITableViewAutomaticDimension;
  self.tableView.estimatedRowHeight = 44.0;
  
  [self.tableView registerClass:[TATripTableViewCell class] forCellReuseIdentifier:@"tripCell"];
  [self.travelDataSource addObserver:self forKeyPath:@"trips" options:NSKeyValueObservingOptionNew context:nil];
  
  TAContentOPerationCreator *creator = [[TAContentOPerationCreator alloc] initWithTravelTableViewController:self];
  [creator create];
  [self.operationQueue addOperations:[creator operations] waitUntilFinished:NO];
}


- (void) addBlurEffect:(UIView *)view {
  CGRect bounds = view.bounds;
  UIVisualEffectView *visualEffectView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]];
  visualEffectView.frame = bounds;
  visualEffectView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
  [view addSubview:visualEffectView];
  view.backgroundColor = [UIColor clearColor];
  [view sendSubviewToBack:visualEffectView];
}

- (UISegmentedControl *)createSegmentedControl {
  UISegmentedControl *segmntedControl = [[UISegmentedControl alloc] initWithItems:[self.travelDataSource segmentedControlItems]];
  [self.travelDataSource synchronizeSegmentedControl:segmntedControl];
  
  [segmntedControl addTarget:self.travelDataSource action:@selector(sortSegmntedControlAction:) forControlEvents:UIControlEventValueChanged];
  return segmntedControl;
}

- (void)presentSortView:(id)sender {
  
  UISegmentedControl *segmntedControl = [self createSegmentedControl];
  UIView *sortBackgroundView = [[UIView alloc] initWithFrame:CGRectZero];
  [self addBlurEffect:sortBackgroundView];
  
  [sortBackgroundView addSubview:segmntedControl];
  [sortBackgroundView setBackgroundColor:[UIColor whiteColor]];
  sortBackgroundView.backgroundColor = [UIColor colorWithRed:(247/255.0) green:(247/255.0) blue:(247/255.0) alpha:0.8];
  
  
  [segmntedControl mas_makeConstraints:^(MASConstraintMaker *make) {
    make.center.equalTo(sortBackgroundView);
    make.top.equalTo(sortBackgroundView);
    make.bottom.equalTo(sortBackgroundView);
  }];
  
  [self.navigationController.view addSubview:sortBackgroundView];
  
  [sortBackgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.top.equalTo(self.navigationController.navigationBar.mas_bottom);
    make.centerX.equalTo(self.navigationController.navigationBar);
    make.left.equalTo(self.navigationController.navigationBar.mas_left);
    make.right.equalTo(self.navigationController.navigationBar.mas_right);
  }];
  
  self.sortView = sortBackgroundView;
  
  [self.tableView setContentInset:UIEdgeInsetsMake(self.tableView.contentInset.top + segmntedControl.height_,0,0,0)];
  
  [self.tableView setContentOffset:CGPointMake(0, self.tableView.contentOffset.y - segmntedControl.height_)];
  
}

- (void)dismissSortView:(id)sender {
  
  [self.tableView setContentInset:UIEdgeInsetsMake(self.tableView.contentInset.top - self.sortView.height_,0,0,0)];
  
  [self.tableView setContentOffset:CGPointMake(0, self.tableView.contentOffset.y + self.sortView.height_)];
  
  [self.sortView removeFromSuperview];
}

- (void)sortViewPresentingAction:(id)sender {
  (self.sortView)?[self dismissSortView:nil]:[self presentSortView:nil];
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
  TAOfferViewContoller *offerViewController = [[TAOfferViewContoller alloc] init];
  [self presentViewController:offerViewController animated:YES completion:nil];
  [tableView deselectRowAtIndexPath:indexPath animated:YES];
}



@end




