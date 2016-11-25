//
//  TAContentOPerationCreator.m
//  TravelApp
//
//  Created by Alexander on 11/25/16.
//  Copyright © 2016 Home. All rights reserved.
//

#import "TAContentOPerationCreator.h"
#import "TATravelTableViewController.h"
#import "TANetworkFetchOperation.h"
#import "TAJSONParseOperation.h"
#import "TASerializerOperation.h"

@interface TAContentOPerationCreator ()
@property (nonatomic, weak) TATravelTableViewController *travelViewController;
@property (nonatomic, strong, readwrite) NSArray *operations;
@end

@implementation TAContentOPerationCreator
- (instancetype)initWithTravelTableViewController:(TATravelTableViewController *)travelViewController {
  if (self = [super init]) {
    _travelViewController = travelViewController;
  }
  return self;
}

- (void)create {
  TANetworkFetchOperation *networkFetchOperation = [[TANetworkFetchOperation alloc]
                                                    initWith:self.travelViewController.networkContext];
  
  TAJSONParseOperation *parserOperation = [[TAJSONParseOperation alloc] init];
  
  
  
  NSBlockOperation *adapterOperation = [NSBlockOperation blockOperationWithBlock:^{
    parserOperation.networkData = networkFetchOperation.networkData;
    parserOperation.networkError = networkFetchOperation.networkError;
  }];
  
  NSMutableArray *operations = [NSMutableArray array];
  
  [adapterOperation addDependency:networkFetchOperation];
  [parserOperation addDependency:adapterOperation];
  
  
  [operations addObject:networkFetchOperation];
  [operations addObject:adapterOperation];
  [operations addObject:parserOperation];
  
  
  TASerializerOperation *serilizerOperation = [[TASerializerOperation alloc] initWithKey:[self.travelViewController.networkContext.url absoluteString]];
  
  [serilizerOperation addDependency:parserOperation];
  NSBlockOperation *secondAdapterOPeration = [NSBlockOperation blockOperationWithBlock:^{
    serilizerOperation.trips = parserOperation.trips;
    serilizerOperation.error = parserOperation.error;
  }];
  
  [secondAdapterOPeration addDependency:parserOperation];
  [serilizerOperation addDependency:secondAdapterOPeration];
  
  [operations addObject:secondAdapterOPeration];
  [operations addObject:serilizerOperation];
  
  
  NSBlockOperation *resultAdapterOPeration = [NSBlockOperation blockOperationWithBlock:^{
    _travelViewController.trips = parserOperation.trips;
    _travelViewController.error = parserOperation.error;
  }];
  
  [resultAdapterOPeration addDependency:parserOperation];
  [operations addObject:resultAdapterOPeration];
  
  self.operations = [operations copy];
}

- (NSArray *)operations {
  return _operations;
}

@end
