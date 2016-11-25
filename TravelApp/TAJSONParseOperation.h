//
//  TAJSONParseOperation.h
//  TravelApp
//
//  Created by Alexander on 11/25/16.
//  Copyright © 2016 Home. All rights reserved.
//

#import "TAParseOperation.h"

@interface TAJSONParseOperation : TAParseOperation
@property (nonatomic, strong) NSArray *trips;
@property (nonatomic, strong) NSError *error;
@end
