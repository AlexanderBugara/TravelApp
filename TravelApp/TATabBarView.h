//
//  TATabBarView.h
//  TravelApp
//
//  Created by Alexander on 11/16/16.
//  Copyright © 2016 Home. All rights reserved.
//

#import <UIKit/UIKit.h>


@class TATabBarController, TATabBarView, TATabBarItem, TATabBarViewState, TAAnimationManager;

@protocol TATabBarDelegate <NSObject>
- (void)tabBarView:(TATabBarView *)tabBarView didTapAtIndex:(NSInteger)index;
@end

@protocol TATabBarDataSource <NSObject>
- (NSArray *)tabBarViewIconNames:(TATabBarView *)tabBarView;
@end


@interface TATabBarView : UIView
@property (nonatomic, weak) id <TATabBarDelegate> delegate;
@property (nonatomic, weak) id <TATabBarDataSource> dataSource;
- (instancetype)initWithController:(TATabBarController *)controller;

@end

@interface TATabBarViewState : NSObject
- (id)initWithTabBarView:(TATabBarView *)tabBarView;
- (void)change;
- (TATabBarView *)tabBarView;
- (void)updateMaskLayer;

- (CGRect)expandedRect;
- (CGRect)collapsedRect;
@end
@interface TACollapsedState : TATabBarViewState

@end
@interface TATExpandedState : TATabBarViewState

@end


@interface TAAnimationTabBarState : TATabBarViewState
- (instancetype)initWithTabBarView:(TATabBarView *)tabBarView
                  animationManager:(TAAnimationManager *)animationManager;
@end

@interface TACollapseAnimationState : TAAnimationTabBarState
@end

@interface TAExpandAnimationState : TAAnimationTabBarState
@end
