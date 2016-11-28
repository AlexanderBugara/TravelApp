//
//  TAAnimationManager.h
//  TravelApp
//
//  Created by Alexander on 11/24/16.
//  Copyright © 2016 Home. All rights reserved.
//

#include <UIKit/UIKit.h>

@class TAAnimationConfiguration;

@interface TAAnimationManager : NSObject
- (CAAnimation *)expandAnimationForplusButton;
- (CAAnimation *)collapseAnnimationForPlusButton;
- (void)animateMainView:(UIView *)mainView frameExpand:(CGRect)rect;
- (void)animateMainView:(UIView *)mainView frameCollapse:(CGRect)rect;
- (void)buttonsHideWithAnimation:(NSArray *)buttons plusButton:(UIButton *)plusButton;
@end
