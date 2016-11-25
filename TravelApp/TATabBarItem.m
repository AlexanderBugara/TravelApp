//
//  TATabBarItem.m
//  TravelApp
//
//  Created by Alexander on 11/23/16.
//  Copyright © 2016 Home. All rights reserved.
//

#import "TATabBarItem.h"

@implementation TATabBarItem
- (instancetype)initWithIconName:(NSString *)iconName {
  
  if (self = [super init]) {
    _image = [UIImage imageNamed:iconName];
  }
  return self;
  
}

- (void)accept:(UIButton *)button sender:(TATabBarView *)sender {
  [sender setupButton:button];
}

@end
