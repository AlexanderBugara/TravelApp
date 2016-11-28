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
@property (nonatomic, weak) UIStackView *stackView;
@end

@implementation TATabBarView

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
  [self clearSubviews];
  
  [self setupMainView];
  [self createPlusButton];
  [self createTabBattons];
 
  [self collapse];
}

- (void)clearSubviews {
  [self.mainView removeFromSuperview];
  for (UIButton *button in self.buttons) {
    [button removeFromSuperview];
  }
  [self.plusButton removeFromSuperview];
}

- (void)setupMainView {
  UIView *mainView = [[UIView alloc] initWithFrame:UIEdgeInsetsInsetRect(self.bounds, kTabBarViewHDefaultEdgeInsets)];
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
  self.stackView = stackView;
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
    [button setHidden:YES];
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
    [self.buttons addObject:button];
  }
}

- (void)barButtonDidTab:(id)sender {
  [self.delegate tabBarView:self didTapAtIndex:[(UIButton *)sender tag]];
}

- (void)collapse {
  [self updateMaskLayer:self.collapsedRect];
  [self.animationManager animateMainView:self.mainView frameCollapse:[self.plusButton frame]];
  CAAnimation *animation = [self.animationManager collapseAnnimationForPlusButton];
  [self.plusButton.layer addAnimation:animation forKey:nil];
  [self hideButtons];
}

- (void)expand {
  [self updateMaskLayer:self.expandedRect];
  
  
  [self.animationManager animateMainView:self.mainView frameExpand:self.frame];
  
  CAAnimation *animation = [self.animationManager expandAnimationForplusButton];
  [self.plusButton.layer addAnimation:animation forKey:nil];
  [self showButtons];
}

- (void)plusButtonAction:(id)sender {
  
  
  TAPlusButton *plusButton = (TAPlusButton *)sender;
  [plusButton setSelected:!plusButton.isSelected];
  
  
   void (^blockAnimations)(void) = ^(){
     
    (plusButton.isSelected)?[self updateMaskLayer:self.expandedRect]:[self updateMaskLayer:self.collapsedRect];
     
     (plusButton.isSelected)?
     [self.animationManager animateMainView:self.mainView frameExpand:self.frame]:
     [self.animationManager animateMainView:self.mainView frameCollapse:[(UIButton *)sender frame]];
     
     CAAnimation *animation = (plusButton.isSelected)?[self.animationManager expandAnimationForplusButton]:[self.animationManager collapseAnnimationForPlusButton];
     [plusButton.layer addAnimation:animation forKey:nil];
     
     (plusButton.isSelected)?[self showButtons]:[self hideButtons];
   };
  
  [CATransaction begin];
  [CATransaction setCompletionBlock:nil];
  if (blockAnimations) {
    blockAnimations();
  }
  [CATransaction commit];
  
}

- (void)layoutSubviews {
  [super layoutSubviews];
  
  [self setup];
  
}

- (UIButton *)buttonBefore:(UIButton *)button {
  NSInteger index = [self.buttons indexOfObject:button];
  if (index > 0) {
    return self.buttons[index - 1];
  }
  return nil;
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

- (TAAnimationManager *)animationManager {
  if (!_animationManager) {
    _animationManager = [TAAnimationManager new];
  }
  return _animationManager;
}

- (void)hideButtons {
  [self.animationManager buttonsHideWithAnimation:self.buttons plusButton:self.plusButton];
 }

- (void)showButtons {
  for (UIButton *button in self.buttons) {
    button.hidden = NO;
  }
  [self.stackView setNeedsLayout];
}

@end
