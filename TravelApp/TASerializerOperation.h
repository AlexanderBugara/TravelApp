//
//  TASerializerOperation.h
//  TravelApp
//
//  Created by Alexander on 11/25/16.
//  Copyright © 2016 Home. All rights reserved.
//

#import "TAStoreOperation.h"

@interface TASerializerOperation : TAStoreOperation
@property (nonatomic, strong) NSArray *trips;
@property (nonatomic, strong) NSError *error;
- (instancetype)initWithKey:(NSString *)key;
@end
