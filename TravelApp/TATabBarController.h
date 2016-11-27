//
//  TATabBarController.h
//  TravelApp
//
//  Created by Alexander on 11/16/16.
//  Copyright © 2016 Home. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TATabBarView.h"

@interface TATabBarController : UITabBarController<TATabBarDelegate>
@property (nonatomic, strong) TATabBarView *tabBarView;
- (NSArray *)titles;
@end
