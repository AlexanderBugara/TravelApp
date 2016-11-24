//
//  TATabBarView.m
//  TravelApp
//
//  Created by Alexander on 11/16/16.
//  Copyright © 2016 Home. All rights reserved.
//

#import "TATabBarView.h"
#import "TAConstants.h"

@implementation TATabBarViewConfiguration

- (UIEdgeInsets)tabBarViewEdgeInsets {
  return kTabBarViewHDefaultEdgeInsets;
}

- (UIColor *)backgroundColor {
  return [UIColor blueColor];
}

@end

@interface TATabBarView ()
@property (nonatomic, weak) UIView *mainView;
@property (assign) CGRect expandedFrame;
@property (nonatomic, strong) TATabBarViewConfiguration *configuration;

@end

@implementation TATabBarView

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
  [self setupMainView];
  [self setupCenterButton];
}

- (void)setupMainView {
  UIView *mainView = [[UIView alloc] initWithFrame:UIEdgeInsetsInsetRect(self.bounds, self.configuration.tabBarViewEdgeInsets)];
  
  self.expandedFrame = self.mainView.frame;
  self.mainView.layer.cornerRadius = CGRectGetHeight(self.mainView.bounds) / 2.f;
  self.mainView.layer.masksToBounds = YES;
  self.mainView.backgroundColor = self.configuration.backgroundColor;
  [self addSubview:mainView];
  
  self.mainView = mainView;
}


- (void)layoutSubviews {
  [super layoutSubviews];
  
  [self setup];
}


- (void)setupCenterButton {
//  self.centerButton = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMidX(self.mainView.frame) - CGRectGetHeight(self.mainView.frame) / 2.0f,
//                                                                 CGRectGetMidY(self.mainView.frame) - CGRectGetHeight(self.mainView.frame) / 2.f,
//                                                                 CGRectGetHeight(self.mainView.frame),
//                                                                 CGRectGetHeight(self.mainView.frame))];
//  
//  self.centerButton.layer.cornerRadius = CGRectGetHeight(self.mainView.bounds) / 2.f;
//  
//  if ([self.dataSource respondsToSelector:@selector(centerImageInTabBarView:)]) {
//    [self.centerButton setImage:[self.dataSource centerImageInTabBarView:self] forState:UIControlStateNormal];
//  }
//  
//  [self.centerButton addTarget:self action:@selector(centerButtonPressed) forControlEvents:UIControlEventTouchUpInside];
//  self.centerButton.adjustsImageWhenHighlighted = NO;
//  
//  [self addSubview:self.centerButton];
}


- (void)setupAdditionalTabBarItems {
  NSArray *leftTabBarItems = [self.dataSource leftItems:self];
  NSArray *rightTabBarItems = [self.dataSource rightItems:self];
  
  
  
  NSUInteger numberOfLeftTabBarButtonItems = [leftTabBarItems count];
  NSUInteger numberOfRightTabBarButtonItems = [rightTabBarItems count];
  
  //calculate available space for left and right side
  CGFloat availableSpaceForAdditionalBarButtonItemLeft = CGRectGetWidth(self.mainView.frame) / 2.f - CGRectGetWidth(self.centerButton.frame) / 2.f - self.tabBarItemsEdgeInsets.left;
  
  CGFloat availableSpaceForAdditionalBarButtonItemRight = CGRectGetWidth(self.mainView.frame) / 2.f - CGRectGetWidth(self.centerButton.frame) / 2.f - self.tabBarItemsEdgeInsets.right;
  
  CGFloat maxWidthForLeftBarButonItem = availableSpaceForAdditionalBarButtonItemLeft / numberOfLeftTabBarButtonItems;
  CGFloat maxWidthForRightBarButonItem = availableSpaceForAdditionalBarButtonItemRight / numberOfRightTabBarButtonItems;
  
  NSMutableArray * reverseArrayLeft = [NSMutableArray arrayWithCapacity:[self.leftButtonsArray count]];
  
  for (id element in [leftTabBarItems reverseObjectEnumerator]) {
    [reverseArrayLeft addObject:element];
  }
  
  NSMutableArray *mutableArray = [NSMutableArray array];
  NSMutableArray *mutableDotsArray = [NSMutableArray array];
  
  CGFloat deltaLeft = 0.f;
  if (maxWidthForLeftBarButonItem > CGRectGetWidth(self.centerButton.frame)) {
    deltaLeft = maxWidthForLeftBarButonItem - CGRectGetWidth(self.centerButton.frame);
  }
  
  CGFloat startPositionLeft = CGRectGetWidth(self.mainView.bounds) / 2.f - CGRectGetWidth(self.centerButton.frame) / 2.f - self.tabBarItemsEdgeInsets.left - deltaLeft / 2.f;
  
  for (int i = 0; i < numberOfLeftTabBarButtonItems; i++) {
    CGFloat buttonOriginX = startPositionLeft - maxWidthForLeftBarButonItem * (i+1);
    CGFloat buttonOriginY = 0.f;
    
    CGFloat buttonWidth = maxWidthForLeftBarButonItem;
    CGFloat buttonHeight = CGRectGetHeight(self.mainView.frame);
    
    startPositionLeft -= self.tabBarItemsEdgeInsets.right;
    
    YALTabBarItem *item = reverseArrayLeft[i];
    UIImage *image = item.itemImage;
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(buttonOriginX, buttonOriginY, buttonWidth, buttonHeight)];
    
    if (numberOfLeftTabBarButtonItems == 1) {
      CGRect rect = button.frame;
      rect.size.width = CGRectGetHeight(self.mainView.frame);
      button.bounds = rect;
    }
    
    [button setImage:image forState:UIControlStateNormal];
    [button addTarget:self action:@selector(didTapBarItem:) forControlEvents:UIControlEventTouchUpInside];
    
    if (self.state == YALTabBarStateCollapsed) {
      button.hidden = YES;
    }
    
    
    [mutableArray addObject:button];
    button.adjustsImageWhenHighlighted = NO;
    
    [self.mainView addSubview:button];
  }
  
  NSMutableArray * reverseArrayLeftDotViews = [NSMutableArray arrayWithCapacity:[mutableDotsArray count]];
  
  for (id element in [mutableDotsArray reverseObjectEnumerator]) {
    [reverseArrayLeft addObject:element];
  }
  mutableDotsArray = reverseArrayLeftDotViews;
  
  self.leftButtonsArray = [mutableArray copy];
  
  [mutableArray removeAllObjects];
  
  CGFloat rightDelta = 0.f;
  if (maxWidthForRightBarButonItem > CGRectGetWidth(self.centerButton.frame)) {
    rightDelta = maxWidthForRightBarButonItem - CGRectGetWidth(self.centerButton.frame);
  }
  
  CGFloat rightOffset = self.tabBarItemsEdgeInsets.right;
  CGFloat startPositionRight = CGRectGetWidth(self.mainView.bounds) / 2.f + CGRectGetWidth(self.centerButton.frame) / 2.f + self.tabBarItemsEdgeInsets.right
  + rightDelta / 2.f;
  
  for (int i = 0; i < numberOfRightTabBarButtonItems; i++) {
    CGFloat buttonOriginX = startPositionRight;
    CGFloat buttonOriginY = 0.f;
    CGFloat buttonWidth = maxWidthForRightBarButonItem;
    CGFloat buttonHeight = CGRectGetHeight(self.mainView.frame);
    
    startPositionRight = buttonOriginX + maxWidthForRightBarButonItem + rightOffset;
    
    YALTabBarItem *item = rightTabBarItems [i];
    UIImage *image = item.itemImage;
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(buttonOriginX, buttonOriginY, buttonWidth, buttonHeight)];
    
    if (numberOfLeftTabBarButtonItems == 1) {
      CGRect rect = button.frame;
      rect.size.width = CGRectGetHeight(self.mainView.frame);
      button.bounds = rect;
    }
    
    [button setImage:image forState:UIControlStateNormal];
    [button addTarget:self action:@selector(didTapBarItem:) forControlEvents:UIControlEventTouchUpInside];
    
    if (self.state == YALTabBarStateCollapsed) {
      button.hidden = YES;
    }
    [mutableArray addObject:button];
    button.adjustsImageWhenHighlighted = NO;
    [self.mainView addSubview:button];
  }
  
  self.rightButtonsArray = [mutableArray copy];
}

@end
