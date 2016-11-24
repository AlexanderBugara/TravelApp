//
//  TATabBarController.h
//  TravelApp
//
//  Created by Alexander on 11/16/16.
//  Copyright © 2016 Home. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TATabBarView.h"

@interface TATabBarConfiguration : NSObject
@property (nonatomic, strong, readonly) NSArray *leftItems;
@property (nonatomic, strong, readonly) NSArray *rightItems;
@end


@interface TATabBarController : UITabBarController<TATabBarDelegate, TATabBarDataSource>
@property (nonatomic, strong) TATabBarView *tabBarView;
- (instancetype)initWithConfig:(TATabBarConfiguration *)configuration;
@end
