//
//  TATabBarCenterItem.m
//  TravelApp
//
//  Created by Alexander on 11/24/16.
//  Copyright © 2016 Home. All rights reserved.
//

#import "TATabBarCenterItem.h"

@implementation TATabBarCenterItem

- (void)accept:(UIButton *)button sender:(TATabBarView *)sender {
  [sender setupCenterButton:button];
}

@end
