//
//  TATabBarController.m
//  TravelApp
//
//  Created by Alexander on 11/16/16.
//  Copyright © 2016 Home. All rights reserved.
//

#import "TATabBarController.h"
#import "TATabBarView.h"
#import "UIView+Geometry.h"
#import "TATabBarItem.h"


@implementation TATabBarConfiguration

- (instancetype)init {
  if (self = [super init]) {
    _items = [self itemsFromFileNames:@[@"plain",@"train",@"plus",@"bus",@"sort"]];
  }
  return self;
}

- (NSArray *)itemsFromFileNames:(NSArray *)fileNames {
  NSMutableArray *temp = [NSMutableArray array];
  for (NSString *fileName in fileNames) {
    [temp addObject:[[TATabBarItem alloc] initWithIconName:fileName]];
  }
  return [temp copy];
}

@end


@interface TATabBarController ()
@property (nonatomic, strong) TATabBarConfiguration *configuration;
@end

@implementation TATabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

#pragma mark - Initialization
- (instancetype)init {
  self = [super init];
  if (self) {
    [self setupTabBarView];
  }
  return self;
}

- (instancetype)initWithConfig:(TATabBarConfiguration *)configuration {
  if (self = [super init]) {
    _configuration = configuration;
    [self setupTabBarView];
  }
  return self;
}

#pragma mark - View & LifeCycle
- (void)viewDidLayoutSubviews {
  [super viewDidLayoutSubviews];
  
  self.tabBarView.frame = self.tabBar.bounds;
  
  for (UIView *view in self.tabBar.subviews) {
    [view removeFromSuperview];
  }
 
  [self.tabBar addSubview:self.tabBarView];
  
 // [self.tabBar setOrigin:CGPointMake(0, [self.topLayoutGuide length])];
  
}


- (void)setupTabBarView {
  self.tabBarView = [[TATabBarView alloc] initWithController:self
                                               configuration:[TATabBarViewConfiguration new]];
}

- (NSArray *)items:(TATabBarView *)tabBarView {
  return self.configuration.items;
}

- (void)tabBarView:(TATabBarView *)tabBarView
     didTapAtIndex:(NSInteger)index {
  self.selectedIndex = index;
}

@end
