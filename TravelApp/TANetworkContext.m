//
//  TANetworkContext.m
//  TravelApp
//
//  Created by Alexander on 11/25/16.
//  Copyright © 2016 Home. All rights reserved.
//

#import "TANetworkContext.h"

@implementation TANetworkContext

+ (TANetworkContext *)flights {
  
  return [[TANetworkContext alloc] initWithStringURL:@"https://api.myjson.com/bins/w60i"];
}

+ (TANetworkContext *)trains {
  return [[TANetworkContext alloc] initWithStringURL:@"https://api.myjson.com/bins/3zmcy"];
}

+ (TANetworkContext *)buses {
  return [[TANetworkContext alloc] initWithStringURL:@"https://api.myjson.com/bins/37yzm"];
}

- (instancetype)initWithStringURL:(NSString *)stringURL {
  if (self = [super init]) {
    _url = [NSURL URLWithString:stringURL];
  }
  return self;
}

@end
