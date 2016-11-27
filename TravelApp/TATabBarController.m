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
#import "TANetworkContext.h"
#import "TATravelViewController.h"


@implementation TATabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

#pragma mark - Initialization
- (instancetype)init {
  self = [super init];
  if (self) {
    [self setupViewControllers];
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
}


- (TATabBarView *)tabBarView {
  if (!_tabBarView) {
    _tabBarView = [[TATabBarView alloc] initWithController:self];
    _tabBarView.delegate = self;
  }
  return _tabBarView;
}

- (void)tabBarView:(TATabBarView *)tabBarView
     didTapAtIndex:(NSInteger)index {
  self.selectedIndex = index;
}

- (NSArray *)titles {
  return @[@"Flights", @"Trains", @"Buses"];
}

- (void)setupViewControllers {
  
  NSArray *networkContexts = @[[TANetworkContext flights],[TANetworkContext trains],[TANetworkContext buses]];
  NSMutableArray *tabBarControllerContent = [NSMutableArray array];
  
  for (int i = 0; i < [[self titles] count]; i++) {
    
    TANetworkContext *context = nil;
    if (i < [networkContexts count])
      context = networkContexts[i];
    
    UINavigationController *navigationController = [self tabBarControllerWithContext:context index:i];
    [tabBarControllerContent addObject:navigationController];
  }
  
  [self setViewControllers:tabBarControllerContent animated:YES];
}

- (UINavigationController *)tabBarControllerWithContext:(TANetworkContext *)context
                                                  index:(NSInteger)index {
  
  UINavigationController *navigationController = [UINavigationController new];
  TATravelViewController *first = [[TATravelViewController alloc] initWithNetworkContext:context];
  first.navigationItem.title = [[self titles] objectAtIndex:index];
  navigationController.viewControllers = @[first];
  return navigationController;
  
}
@end
