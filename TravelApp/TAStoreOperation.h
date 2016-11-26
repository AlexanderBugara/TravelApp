//
//  TAStoreOperation.h
//  TravelApp
//
//  Created by Alexander on 11/25/16.
//  Copyright © 2016 Home. All rights reserved.
//

#import "TAOperation.h"

@interface TAStoreOperation : TAOperation

@property (nonatomic, strong, readonly) NSString *key;
@property (nonatomic, strong) NSArray *trips;
@property (nonatomic, strong) NSError *error;


- (instancetype)initWithKey:(NSString *)key;
@end
