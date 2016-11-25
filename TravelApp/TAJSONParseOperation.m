//
//  TAJSONParseOperation.m
//  TravelApp
//
//  Created by Alexander on 11/25/16.
//  Copyright © 2016 Home. All rights reserved.
//

#import "TAJSONParseOperation.h"
#import "TATravelItem.h"


@implementation TAJSONParseOperation

- (void)main {
  @try {
    NSError* error;
    id json = [NSJSONSerialization JSONObjectWithData:self.networkData
                                                         options:kNilOptions
                                                           error:&error];
    if (!error && [json isKindOfClass:[NSArray class]]) {
      [self createListOfItems:json];
    } else if (error) {
      self.error = error;
    }
  } @catch (NSException *exception) {
    NSLog(@"TAJSONParseOperation : %@",[exception description]);
  } @finally {
    
  }
}

- (void)createListOfItems:(NSArray *)jsonList {
  
  NSMutableArray *array = [NSMutableArray array];
  for (NSDictionary *itemJSON in jsonList) {
    [array addObject:[[TATravelItem alloc] initWithJSON:itemJSON]];
  }
  self.trips = [array copy];
  
}


@end
