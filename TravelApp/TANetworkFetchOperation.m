//
//  TANetworkFetchOperation.m
//  TravelApp
//
//  Created by Alexander on 11/25/16.
//  Copyright © 2016 Home. All rights reserved.
//

#import "TANetworkFetchOperation.h"

@interface TANetworkFetchOperation ()
@property (nonatomic, readwrite, weak) TANetworkContext * networkContext;
@property (nonatomic, readwrite, strong) NSURLSession * urlSession;
@end

@implementation TANetworkFetchOperation
- (instancetype)initWith:(TANetworkContext *)networkContext {
  
  if (self = [super init]) {
    executing = NO;
    finished = NO;
    _networkContext = networkContext;
  }
  return self;
}

- (BOOL)isConcurrent {
  return YES;
}

- (BOOL)isExecuting {
  return executing;
}

- (BOOL)isFinished {
  return finished;
}

- (BOOL)isCancelled {
  BOOL result = [super isCancelled];
  if (result) {
    [self willChangeValueForKey:@"isFinished"];
    finished = YES;
    [self didChangeValueForKey:@"isFinished"];
  }
  return result;
}

- (void)start {
  if (![self isCancelled]) {
    [self willChangeValueForKey:@"isExecuting"];
    [NSThread detachNewThreadSelector:@selector(main) toTarget:self withObject:nil];
    executing = YES;
    [self didChangeValueForKey:@"isExecuting"];
  }
}

- (void)main {
  
  @try {
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:self.networkContext.url
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:60.0];
    
    [request setHTTPMethod:@"GET"];
    
    __weak __typeof (self) weakSelf = self;
    
    NSURLSessionTask *task = [self.urlSession dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
      
      weakSelf.networkError = error;
      weakSelf.networkData = data;
      [weakSelf finish];
      
    }];
    
    [task resume];
  } @catch (NSException *exception) {
    
  } @finally {
    
  }
}

- (NSURLSession *)urlSession {
  if (!_urlSession) {
    _urlSession = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
  }
  return _urlSession;
}

- (void)finish {
  [self willChangeValueForKey:@"isExecuting"];
  executing = NO;
  [self didChangeValueForKey:@"isExecuting"];
  
  [self willChangeValueForKey:@"isFinished"];
  finished = YES;
  [self didChangeValueForKey:@"isFinished"];
}

@end
