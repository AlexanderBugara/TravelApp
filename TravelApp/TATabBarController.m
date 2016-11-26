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
#import "TATabBarCenterItem.h"
#import "TANetworkContext.h"
#import "TATravelViewController.h"

@interface TATabBarConfiguration ()
@property (nonatomic, strong, readwrite) NSArray *items;
@end

@implementation TATabBarConfiguration

- (instancetype)init {
  if (self = [super init]) {
    _items = [self itemsFromFileNames:@[@"plain",@"train",@"bus",@"sort"]];
    [self setupCenterItem];
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

- (TATabBarItem *)centerItem {
  if ([self.items count] == 0) return nil;
  
  NSInteger index = [self.items count]/2;
  return self.items[index];
}


- (void)setupCenterItem {
  if ([self.items count] > 0) {
    NSInteger index = [self.items count]/2;
    NSMutableArray *mutItems = [_items mutableCopy];
    [mutItems insertObject:[[TATabBarCenterItem alloc] initWithIconName:@"plus"] 
                   atIndex:index];
    self.items = [mutItems copy];
  }
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
    [self setup];
  }
  return self;
}

- (instancetype)initWithConfig:(TATabBarConfiguration *)configuration {
  if (self = [super init]) {
    _configuration = configuration;
    [self setupTabBarView];
    [self setup];
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

- (void)setup {
  
  NSArray *tittles = @[@"Flights", @"Trains", @"Buses"];
  
  NSArray *networkContexts = @[[TANetworkContext flights],[TANetworkContext trains],[TANetworkContext buses]];
  NSMutableArray *tabBarControllerContent = [NSMutableArray array];
  
  for (int i = 0; i < [tittles count]; i++) {
    
    TANetworkContext *context = nil;
    if (i < [networkContexts count])
      context = networkContexts[i];
    
    UINavigationController *navigationController = [self tabBarControllerWithContext:context title:tittles[i]];
    [tabBarControllerContent addObject:navigationController];
  }
  
  [self setViewControllers:tabBarControllerContent animated:YES];
}

- (UINavigationController *)tabBarControllerWithContext:(TANetworkContext *)context
                                                  title:(NSString *)title {
  
  UINavigationController *navigationController = [UINavigationController new];
  TATravelViewController *first = [[TATravelViewController alloc] initWithNetworkContext:context];
  first.navigationItem.title = title;
  navigationController.viewControllers = @[first];
  return navigationController;
  
}



@end
