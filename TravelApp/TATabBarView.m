//
//  TATabBarView.m
//  TravelApp
//
//  Created by Alexander on 11/16/16.
//  Copyright © 2016 Home. All rights reserved.
//

#import "TATabBarView.h"
#import "TAConstants.h"
#import "Masonry.h"
#import "CATransaction+Extend.h"
#import "TAAnimationManager.h"
#import "UIView+Geometry.h"
#import "TAPlusButton.h"

@interface TATabBarView ()
@property (nonatomic, weak) UIView *mainView;
@property (nonatomic, strong) NSMutableArray *buttons;
@property (nonatomic, strong) TATabBarViewState *state;
@property (nonatomic, strong) TAAnimationManager *animationManager;
@property (assign) CGRect expandedRect;
@property (assign) CGRect collapsedRect;
@property (nonatomic, weak) TAPlusButton *plusButton;
@end

@implementation TATabBarView

//- (void)setCollapsedFrame:(CGRect)collapsedFrame {
//  
//  _collapsedFrame = collapsedFrame;
//  
//  self.collapsedBounds = ({
//    CGRect collapsedBounds = collapsedFrame;
//    collapsedBounds.origin = CGPointZero;
//    collapsedBounds.origin.x = CGRectGetWidth(self.expandedFrame) / 2 - CGRectGetWidth(collapsedBounds) / 2;
//    collapsedBounds;
//  });
//  [self.state updateMaskLayer];
//}
//
//- (void)setExpandedFrame:(CGRect)expandedFrame {
//  
//  _expandedFrame = expandedFrame;
//  
//  self.expandedBounds = ({
//    CGRect expandedBounds = expandedFrame;
//    expandedBounds.origin = CGPointZero;
//    expandedBounds;
//  });
//  [self.state updateMaskLayer];
//}

- (void)updateMaskLayer:(CGRect)rect {
  
  self.mainView.layer.mask = ({
    CAShapeLayer *layer = [CAShapeLayer new];
    
    layer.path = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:rect.size.height / 2].CGPath;
    
    layer;
  });
}

- (instancetype)initWithController:(TATabBarController *)controller {
  if (self = [super init]) {
    _delegate = (id <TATabBarDelegate>)controller;
  }
  return self;
}


- (void)setup {
//  self.collapsedFrame = CGRectMake(self.centerX_ - self.height_ / 2  , 0, self.height_, self.height_);
  [self setupMainView];
  [self createPlusButton];
  [self createTabBattons];
}



- (void)setupMainView {
  UIView *mainView = [[UIView alloc] initWithFrame:UIEdgeInsetsInsetRect(self.bounds, kTabBarViewHDefaultEdgeInsets)];
  
  //self.expandedFrame = self.mainView.frame;
  
  self.mainView.layer.cornerRadius = CGRectGetHeight(self.mainView.bounds) / 2.f;
  self.mainView.layer.masksToBounds = YES;
  
  [self addSubview:mainView];
  self.mainView = mainView;
  
  self.mainView.backgroundColor = [UIColor purpleColor];
  
  self.expandedRect = self.mainView.frame;
}

- (void)createPlusButton {
  TAPlusButton *plusButton = [[TAPlusButton alloc] init];

  [plusButton setImage:[UIImage imageNamed:@"plus"] forState:UIControlStateNormal];
  
  plusButton.clipsToBounds = YES;
  plusButton.layer.cornerRadius = self.height_/2.0f;
  plusButton.layer.borderColor = [UIColor whiteColor].CGColor;
  plusButton.layer.borderWidth = 1.0f;
  
  [self addSubview:plusButton];
  [plusButton addTarget:self action:@selector(plusButtonAction:) forControlEvents:UIControlEventTouchUpInside];
  
  [plusButton setBackgroundColor:[UIColor brownColor]];
  [plusButton mas_makeConstraints:^(MASConstraintMaker *make) {
    make.right.equalTo(self).offset(-10);
    make.centerY.equalTo(self);
    make.height.equalTo(self);
    make.width.equalTo(@(self.height_));
  }];
  
  __weak __typeof (self) weakSelf = self;
  plusButton.layoutChangeBlock = ^(CGRect frame){
    self.expandedRect = self.mainView.frame;
    self.collapsedRect = CGRectMake(frame.origin.x, weakSelf.mainView.frame.origin.y, frame.size.width, weakSelf.mainView.frame.size.height);
  };
  self.plusButton = plusButton;
}

- (void)createTabBattons {
  NSArray *iconsNames = [self.dataSource tabBarViewIconNames:self];
  UIStackView *stackView = [[UIStackView alloc] init];
  [self addSubview:stackView];
  [stackView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.right.equalTo(self.plusButton.mas_left);
    make.top.equalTo(self);
    make.bottom.equalTo(self);
    make.left.equalTo(self.mainView.mas_left);
  }];
  
  stackView.axis = UILayoutConstraintAxisHorizontal;
  stackView.distribution = UIStackViewDistributionEqualSpacing;
  stackView.alignment = UIStackViewAlignmentCenter;
  stackView.spacing = 30;
  
  NSInteger tag = 0;
  for (NSString *iconName in iconsNames) {
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.height_, self.height_)];
    button.tag = tag; ++tag;
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
      make.height.equalTo(@(self.height_));
      make.width.equalTo(@(self.height_));
    }];
    
    [button addTarget:self action:@selector(barButtonDidTab:) forControlEvents:UIControlEventTouchUpInside];
    [button setImage:[UIImage imageNamed:iconName] forState:UIControlStateNormal];
    button.clipsToBounds = YES;
    button.layer.cornerRadius = self.height_/2.0f;
    button.layer.borderColor = [UIColor whiteColor].CGColor;
    button.layer.borderWidth = 1.0f;
    [stackView addArrangedSubview:button];
    [button setBackgroundColor:[UIColor brownColor]];
  }
}

- (void)barButtonDidTab:(id)sender {
  [self.delegate tabBarView:self didTapAtIndex:[(UIButton *)sender tag]];
}

- (void)plusButtonAction:(id)sender {
  
  
  TAPlusButton *plusButton = (TAPlusButton *)sender;
  [plusButton setSelected:!plusButton.isSelected];
  
  (plusButton.isSelected)?[self updateMaskLayer:self.expandedRect]:[self updateMaskLayer:self.collapsedRect];
  
  
  
  //CAAnimation *animation = (plusButton.isSelected)?[self.animationManager expandAnimationForplusButton]:[self.animationManager collapseAnnimationForPlusButton];
  
  (plusButton.isSelected)?
  [self.animationManager animateMainView:self.mainView frameExpand:self.frame]:
  [self.animationManager animateMainView:self.mainView frameCollapse:[(UIButton *)sender frame]];
  
  
//  - (void)animateMainView:(UIView *)mainView frameExpand:(CGRect)rect
//  - (void)animateMainView:(UIView *)mainView frameCollapse:(CGRect)rect
  
  
  //[[(UIButton *)sender layer] addAnimation:animation forKey:nil];
}

- (void)layoutSubviews {
  [super layoutSubviews];
  
  [self setup];
  
}

//- (void)addButtonWithItem:(TATabBarItem *)item atIndex:(NSInteger)index {
//  UIButton *button = [[UIButton alloc] init];
//  [button setImage:item.image forState:UIControlStateNormal];
//  [item accept:button sender:self];
//}

//- (void)setupCenterButton:(UIButton *)button {
  /*
  [button addTarget:self action:@selector(centerButtonDidTup:) forControlEvents:UIControlEventTouchUpInside];
  [self addSubview:button];
  self.centerButton = button;
  [self.centerButton setBackgroundColor:[UIColor purpleColor]];
  self.centerButton.layer.cornerRadius = CGRectGetHeight(self.mainView.bounds) / 2.f;
  self.centerButton.adjustsImageWhenHighlighted = NO;
  
  [button mas_makeConstraints:^(MASConstraintMaker *make) {
    make.centerY.equalTo(self);
    make.right.equalTo(self);
    make.height.equalTo(self);
    make.width.equalTo(self.mas_height);
  }];
  */
  //self.centerButton.frame;
  
//}

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

//- (void)setupButtons {
//  NSArray *items = [self.dataSource items:self];
//  
//  NSInteger index = 0;
//  for (TATabBarItem *item in items) {
//    [self addButtonWithItem:item atIndex:index];
//    ++index;
//  }
//}

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




- (CGRect)expandedRect {
  return CGRectZero;//[self.tabBarView expandedFrame];
}

- (CGRect)collapsedRect {
  return CGRectZero; //[self.tabBarView collapsedFrame];
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
  
//  TAAnimationConfiguration *configuration = [[TAAnimationConfiguration alloc] initWithDuration:0.6
//                                                                                       damping:1
//                                                                                      velocity:0.2
//                                                                                      fromRect:[self expandedRect]
//                                                                                        toRect:[self collapsedRect]
//                                                                                  functionName:kCAMediaTimingFunctionEaseOut];
//  
//  CAAnimation *animation = [self.animationManager keyFrameWithConfiguration:configuration];
//  [self.tabBarView.mainView.layer.mask addAnimation:animation forKey:nil];
  
}



- (CGRect)rect {
  return CGRectZero;// self.tabBarView.collapsedFrame;
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
 // CAAnimation *animation = [self.animationManager animationForCenterButton];
 // [self.tabBarView.centerButton.layer addAnimation:animation forKey:nil];
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
//  TAAnimationConfiguration *configuration = [[TAAnimationConfiguration alloc] initWithDuration:1/2.0
//                                                                                       damping:0.5
//                                                                                      velocity:0.6
//                                                                                      fromRect:[self collapsedRect]
//                                                                                        toRect:[self expandedRect]
//                                                                                  functionName:kCAMediaTimingFunctionEaseInEaseOut];
//  CAAnimation *animation = [self.animationManager keyFrameWithConfiguration:configuration];
//  [self.tabBarView.mainView.layer.mask addAnimation:animation forKey:nil];
}



- (CGRect)rect {
  return CGRectZero;// self.tabBarView.expandedFrame;
}
@end
