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
@property (nonatomic, strong) NSMutableArray *buttons;

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
  [self setupButtons];
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



- (void)addButtonWithItem:(TATabBarItem *)item atIndex:(NSInteger)index {
  UIButton *button = [[UIButton alloc] init];
  [button setImage:item.image forState:UIControlStateNormal];
  [button addTarget:self action:@selector(buttonDidTup:) forControlEvents:UIControlEventTouchUpInside];
  [self.buttons insertObject:button atIndex:index];
  [self addSubview:button];
  
  UIButton *previousButton = [self buttonBefore:button];
  
  [button mas_makeConstraints:^(MASConstraintMaker *make) {
    
    if (previousButton)
      make.left.equalTo(previousButton.mas_right).offset(10);
    else 
      make.left.equalTo(@10);
    
    make.centerY.equalTo(self);
    make.height.equalTo(self);
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

@end
