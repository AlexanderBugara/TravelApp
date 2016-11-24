//
//  TATabBarItem.h
//  TravelApp
//
//  Created by Alexander on 11/23/16.
//  Copyright © 2016 Home. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface TATabBarItem : NSObject
@property (nonatomic, strong, readonly) UIImage *image;
- (instancetype)initWithIconName:(NSString *)iconName;
@end
