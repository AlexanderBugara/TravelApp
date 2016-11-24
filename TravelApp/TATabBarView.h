//
//  TATabBarView.h
//  TravelApp
//
//  Created by Alexander on 11/16/16.
//  Copyright © 2016 Home. All rights reserved.
//

#import <UIKit/UIKit.h>


@class TATabBarController, TATabBarView, TATabBarItem;

@protocol TATabBarDelegate <NSObject>
- (void)tabBarView:(TATabBarView *)tabBarView didTapAtIndex:(NSInteger)index;
@end

@protocol TATabBarDataSource <NSObject>
- (NSArray *)items:(TATabBarView *)tabBarView;
@end


@interface TATabBarViewConfiguration : NSObject
@property (assign, readonly) UIEdgeInsets tabBarViewEdgeInsets;
@property (assign, readonly) UIColor *backgroundColor;
@end

@interface TATabBarView : UIView 

@property (nonatomic, weak) id <TATabBarDelegate> delegate;
@property (nonatomic, weak) id <TATabBarDataSource> dataSource;

- (instancetype)initWithController:(TATabBarController *)controller
                     configuration:(TATabBarViewConfiguration *)configuration;

@end
