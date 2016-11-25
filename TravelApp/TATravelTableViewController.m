//
//  TATravelTableViewController.m
//  TravelApp
//
//  Created by Alexander on 11/16/16.
//  Copyright © 2016 Home. All rights reserved.
//

#import "TATravelTableViewController.h"
#import "TAContentOperation.h"
#import "TAContentOPerationCreator.h"
#import "TATravelItem.h"
#import "TATripTableViewCell.h"

@interface TATravelTableViewController ()
@property (nonatomic, strong, readwrite) TANetworkContext *networkContext;
@property (nonatomic, strong, readwrite) NSOperationQueue *operationQueue;
@end

@implementation TATravelTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  
  self.tableView.rowHeight = UITableViewAutomaticDimension;
  self.tableView.estimatedRowHeight = 44.0;
  
  [self.tableView registerClass:[TATripTableViewCell class] forCellReuseIdentifier:@"tripCell"];
  [self addObserver:self forKeyPath:@"trips" options:NSKeyValueObservingOptionNew context:nil];
  
  if (self.networkContext) {
    TAContentOPerationCreator *creator = [[TAContentOPerationCreator alloc] initWithTravelTableViewController:self];
    [creator create];
    [self.operationQueue addOperations:[creator operations] waitUntilFinished:NO];
  }
  
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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.trips count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  
  static NSString *CellIdentifier = @"tripCell";
  
  TATripTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
  if (!cell) {
    cell = [[TATripTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
  }
  
  TATravelItem *travelItem = self.trips[indexPath.row];
  
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
