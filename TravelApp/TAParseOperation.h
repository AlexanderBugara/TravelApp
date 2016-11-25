//
//  TAParseOperation.h
//  TravelApp
//
//  Created by Alexander on 11/25/16.
//  Copyright © 2016 Home. All rights reserved.
//

#import "TAOperation.h"

@interface TAParseOperation : TAOperation
@property (nonatomic, strong) NSData *networkData;
@property (nonatomic, strong) NSError *networkError;
@end
