//
//  TANetworkContext.h
//  TravelApp
//
//  Created by Alexander on 11/25/16.
//  Copyright © 2016 Home. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TANetworkContext : NSObject
@property (nonatomic, strong, readonly) NSURL *url;
- (instancetype)initWithStringURL:(NSString *)stringURL;

+ (TANetworkContext *)flights;
+ (TANetworkContext *)trains;
+ (TANetworkContext *)buses;
@end
