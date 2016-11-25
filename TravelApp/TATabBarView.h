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
- (NSArray *)items:(TATabBarView *)tabBarView;
@end


@interface TATabBarViewConfiguration : NSObject
@property (assign, readonly) UIEdgeInsets tabBarViewEdgeInsets;
@property (assign, readonly) UIColor *backgroundColor;
@end

@interface TATabBarView : UIView 

@property (nonatomic, weak) id <TATabBarDelegate> delegate;
@property (nonatomic, weak) id <TATabBarDataSource> dataSource;
@property (nonatomic, strong) UIButton *centerButton;



@property (nonatomic, assign) CGRect collapsedBounds;
@property (nonatomic, assign) CGRect expandedBounds;
@property (nonatomic, assign) CGRect collapsedFrame;
@property (nonatomic, assign) CGRect expandedFrame;


- (instancetype)initWithController:(TATabBarController *)controller
                     configuration:(TATabBarViewConfiguration *)configuration;
- (void)setState:(TATabBarViewState *)state sender:(TATabBarViewState *)sender;
- (void)buttonDidTup:(id)sender;
- (void)centerButtonDidTup:(id)sender;
- (void)setupCenterButton:(UIButton *)button;
- (void)setupButton:(UIButton *)button;
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
