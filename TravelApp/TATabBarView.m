//
//  TATabBarView.m
//  TravelApp
//
//  Created by Alexander on 11/16/16.
//  Copyright © 2016 Home. All rights reserved.
//

#import "TATabBarView.h"
#import "TAConstants.h"
#import "TATabBarItem.h"
#import "Masonry.h"
#import "CATransaction+Extend.h"
#import "TAAnimationManager.h"
#import "UIView+Geometry.h"

@implementation TATabBarViewConfiguration

- (UIEdgeInsets)tabBarViewEdgeInsets {
  return kTabBarViewHDefaultEdgeInsets;
}

- (UIColor *)backgroundColor {
  return [UIColor purpleColor];
}

@end

@interface TATabBarView ()
@property (nonatomic, strong) UIView *mainView;
@property (nonatomic, strong) TATabBarViewConfiguration *configuration;
@property (nonatomic, strong) NSMutableArray *buttons;
@property (nonatomic, strong) TATabBarViewState *state;
@property (nonatomic, strong) TAAnimationManager *animationManager;
@end

@implementation TATabBarView

- (void)setCollapsedFrame:(CGRect)collapsedFrame {
  
  _collapsedFrame = collapsedFrame;
  
  self.collapsedBounds = ({
    CGRect collapsedBounds = collapsedFrame;
    collapsedBounds.origin = CGPointZero;
    collapsedBounds.origin.x = CGRectGetWidth(self.expandedFrame) / 2 - CGRectGetWidth(collapsedBounds) / 2;
    collapsedBounds;
  });
  [self.state updateMaskLayer];
}

- (void)setExpandedFrame:(CGRect)expandedFrame {
  
  _expandedFrame = expandedFrame;
  
  self.expandedBounds = ({
    CGRect expandedBounds = expandedFrame;
    expandedBounds.origin = CGPointZero;
    expandedBounds;
  });
  [self.state updateMaskLayer];
}



- (instancetype)initWithController:(TATabBarController *)controller
                     configuration:(TATabBarViewConfiguration *)configuration {
  
  if (self = [super init]) {
    _delegate = (id <TATabBarDelegate>)controller;
    _dataSource = (id <TATabBarDataSource>)controller;
    _configuration = configuration;
  }
  return self;
}


- (void)setup {
  self.collapsedFrame = CGRectMake(self.centerX_ - self.height_ / 2  , 0, self.height_, self.height_);
  [self setupMainView];
  [self setupButtons];
  [self.state updateMaskLayer];

}

- (void)setupMainView {
  self.mainView = [[UIView alloc] initWithFrame:UIEdgeInsetsInsetRect(self.bounds, self.configuration.tabBarViewEdgeInsets)];
  self.expandedFrame = self.mainView.frame;
  
  self.mainView.layer.cornerRadius = CGRectGetHeight(self.mainView.bounds) / 2.f;
  self.mainView.layer.masksToBounds = YES;
  
  
  [self addSubview:self.mainView];
  
  
  self.mainView.backgroundColor = self.configuration.backgroundColor;
  [self setBackgroundColor:[UIColor greenColor]];
}



- (void)layoutSubviews {
  [super layoutSubviews];
  
  [self setup];
  
}

- (void)addButtonWithItem:(TATabBarItem *)item atIndex:(NSInteger)index {
  UIButton *button = [[UIButton alloc] init];
  [button setImage:item.image forState:UIControlStateNormal];
  [item accept:button sender:self];
}

- (void)setupCenterButton:(UIButton *)button {
  
  
  
  [button addTarget:self action:@selector(centerButtonDidTup:) forControlEvents:UIControlEventTouchUpInside];
  [self addSubview:button];
  self.centerButton = button;
  [self.centerButton setBackgroundColor:[UIColor purpleColor]];
  self.centerButton.layer.cornerRadius = CGRectGetHeight(self.mainView.bounds) / 2.f;
  self.centerButton.adjustsImageWhenHighlighted = NO;
  
  [button mas_makeConstraints:^(MASConstraintMaker *make) {
    make.center.equalTo(self);
    make.height.equalTo(self);
    make.width.equalTo(self.mas_height);
  }];
  
  [self.buttons addObject:button];
  
  
  //self.centerButton.frame;
  
}

- (void)setupButton:(UIButton *)button {
  
  
  [button addTarget:self action:@selector(buttonDidTup:) forControlEvents:UIControlEventTouchUpInside];
  [self.mainView addSubview:button];
  [self.buttons addObject:button];
  
  UIButton *previousButton = [self buttonBefore:button];
  
  [button mas_makeConstraints:^(MASConstraintMaker *make) {
    
    if (previousButton)
      make.left.equalTo(previousButton.mas_right).offset(10);
    else
      make.left.equalTo(@10);
    
    make.centerY.equalTo(self.mainView);
    make.height.equalTo(self.mainView);
    make.width.equalTo(@60);
  }];
}

- (UIButton *)buttonBefore:(UIButton *)button {
  NSInteger index = [self.buttons indexOfObject:button];
  if (index > 0) {
    return self.buttons[index - 1];
  }
  return nil;
}

- (void)setupButtons {
  NSArray *items = [self.dataSource items:self];
  
  NSInteger index = 0;
  for (TATabBarItem *item in items) {
    [self addButtonWithItem:item atIndex:index];
    ++index;
  }
}

- (NSMutableArray *)buttons {
  if (!_buttons) {
    _buttons = [NSMutableArray array];
  }
  return _buttons;
}

- (void)buttonDidTup:(id)sender {
  [self.delegate tabBarView:self didTapAtIndex:[self.buttons indexOfObject:sender]];
}

- (void)centerButtonDidTup:(id)sender {
  [self.state change];
}

- (void)setState:(TATabBarViewState *)state 
          sender:(TATabBarViewState *)sender {
  if ([sender isKindOfClass:[TATabBarViewState class]] && state != sender) {
    self.state = state;
  }
}

- (TATabBarViewState *)state {
  if (!_state) {
    _state = [self collapsedState];
  }
  return _state;
}

- (TACollapsedState *)collapsedState {
  return [[TACollapsedState alloc] initWithTabBarView:self];
}

- (TATExpandedState *)expandedState {
  return [[TATExpandedState alloc] initWithTabBarView:self];
}

- (TACollapseAnimationState *)collapseAnimation {
  
  return [[TACollapseAnimationState alloc] initWithTabBarView:self animationManager:self.animationManager];
}

- (TAExpandAnimationState *)expandedAnimation {
  
  return [[TAExpandAnimationState alloc] initWithTabBarView:self animationManager:self.animationManager];
}




- (TAAnimationManager *)animationManager {
  if (!_animationManager) {
    _animationManager = [TAAnimationManager new];
  }
  return _animationManager;
}


@end


@interface TATabBarViewState ()
@property (nonatomic, weak) TATabBarView *tabBarView;
@end

@implementation TATabBarViewState
- (id)initWithTabBarView:(TATabBarView *)tabBarView {
  if (self = [super init]) {
    _tabBarView = tabBarView;
  }
  return self;
}

- (void)change {
  //override in child
}

- (TATabBarView *)tabBarView {
  return _tabBarView;
}

- (CGRect)rect {
  return CGRectZero;
}

- (void)updateMaskLayer {
  self.tabBarView.mainView.layer.mask = ({
    CAShapeLayer *layer = [CAShapeLayer new];
    CGRect rect = [self rect];
    
    layer.path = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:rect.size.height / 2].CGPath;
    
    layer;
  });
}


- (CGRect)expandedRect {
  return [self.tabBarView expandedFrame];
}

- (CGRect)collapsedRect {
  return [self.tabBarView collapsedFrame];
}



@end

@implementation TATExpandedState
- (void)change {
  [self.tabBarView setState:[self.tabBarView collapseAnimation]];
}

- (CGRect)rect {
  return [self expandedRect];
}
@end

@implementation TACollapsedState
- (void)change {
  [self.tabBarView setState:[self.tabBarView expandedAnimation]];
}

- (CGRect)rect {
  return [self collapsedRect];
}
@end



@interface TAAnimationTabBarState ()
@property (nonatomic, weak) TAAnimationManager *animationManager;
@end

@implementation TAAnimationTabBarState
- (instancetype)initWithTabBarView:(TATabBarView *)tabBarView
                  animationManager:(TAAnimationManager *)animationManager {
  
  if (self = [super initWithTabBarView:tabBarView]) {
    _animationManager = animationManager;
    [self runAnimation];
  }
  return self;
  
}

- (void)runAnimation {
  //need override
}

- (void)animateCenterButton {
  
}

@end



@implementation TACollapseAnimationState

- (void)runAnimation {
  [CATransaction transactionAnimations:^{
    [self animateTabBarViewCollapse];
    [self animateCenterButton];
    
    //    [self showExtraLeftTabBarItem];
    //    [self showExtraRightTabBarItem];
    //[self animateCenterButtonCollapse];
    //    [self hideSelectedDotView];
    //    [self animateAdditionalButtons];
  } completion:^{
    [self.tabBarView setState:[self.tabBarView collapsedState]];
    
  }];
}


/*
- (void)animateTabBarViewCollapse {
//  CAAnimation *animation = [CAAnimation animationForTabBarCollapseFromRect:[self currentRect] toRect:[self rect]];
//  animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
//  [self.tabBarView.mainView.layer.mask addAnimation:animation forKey:nil];
}

*/

- (void)animateTabBarViewCollapse {
  
  TAAnimationConfiguration *configuration = [[TAAnimationConfiguration alloc] initWithDuration:0.6
                                                                                       damping:1
                                                                                      velocity:0.2
                                                                                      fromRect:[self expandedRect]
                                                                                        toRect:[self collapsedRect]
                                                                                  functionName:kCAMediaTimingFunctionEaseOut];
  
  CAAnimation *animation = [self.animationManager keyFrameWithConfiguration:configuration];
  [self.tabBarView.mainView.layer.mask addAnimation:animation forKey:nil];
  
}



- (CGRect)rect {
  return self.tabBarView.collapsedFrame;
}

- (void)animateCenterButtonCollapse {
//  CAAnimation *animation = [CAAnimation animationForCenterButtonCollapse];
//  [self.centerButton.layer addAnimation:animation forKey:nil];
}


//
//- (void)hideExtraLeftTabBarItem {
//  [UIView animateWithDuration:kYALHideExtraTabBarItemViewAnimationParameters.duration
//                   animations:^{
//                     self.extraLeftButton.center = CGPointMake( - CGRectGetWidth(self.extraLeftButton.frame) / 2.f, self.extraLeftButton.center.y);
//                   }];
//}
//
//- (void)hideExtraRightTabBarItem {
//  [UIView animateWithDuration:kYALHideExtraTabBarItemViewAnimationParameters.duration
//                   animations:^{
//                     self.extraRightButton.center = CGPointMake(self.extraRightButton.center.x + CGRectGetWidth(self.extraRightButton.frame) + self.offsetForExtraTabBarItems, self.extraRightButton.center.y);
//                   }];
//}

- (void)animateCenterButton {
  CAAnimation *animation = [self.animationManager animationForCenterButton];
  [self.tabBarView.centerButton.layer addAnimation:animation forKey:nil];
}

@end

@implementation TAExpandAnimationState

- (void)runAnimation {
  
  [CATransaction transactionAnimations:^{
     [self animateTabBarViewExpand];
  } completion:^{
    [self.tabBarView setState:[self.tabBarView expandedState]];
  }];
  
}

- (void)animateTabBarViewExpand {
  TAAnimationConfiguration *configuration = [[TAAnimationConfiguration alloc] initWithDuration:1/2.0
                                                                                       damping:0.5
                                                                                      velocity:0.6
                                                                                      fromRect:[self collapsedRect]
                                                                                        toRect:[self expandedRect]
                                                                                  functionName:kCAMediaTimingFunctionEaseInEaseOut];
  CAAnimation *animation = [self.animationManager keyFrameWithConfiguration:configuration];
  [self.tabBarView.mainView.layer.mask addAnimation:animation forKey:nil];
}



- (CGRect)rect {
  return self.tabBarView.expandedFrame;
}
@end
