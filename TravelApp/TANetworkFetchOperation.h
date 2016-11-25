//
//  TANetworkFetchOperation.h
//  TravelApp
//
//  Created by Alexander on 11/25/16.
//  Copyright © 2016 Home. All rights reserved.
//

#import "TAOperation.h"

@interface TANetworkFetchOperation : TAOperation {
  BOOL        executing;
  BOOL        finished;
}
@property (nonatomic, readonly, weak) TANetworkContext * networkContext;
@property (nonatomic, strong) NSData *networkData;
@property (nonatomic, strong) NSError *networkError;

- (instancetype)initWith:(TANetworkContext *)networkContext;
@end
