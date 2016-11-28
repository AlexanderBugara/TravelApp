//
//  TAAnimationManager.m
//  TravelApp
//
//  Created by Alexander on 11/24/16.
//  Copyright © 2016 Home. All rights reserved.
//

#import "TAAnimationManager.h"

CFTimeInterval const kAnimationDuration = 1.0;

CGFloat const kDegreeToRadiansRatio = M_PI / 180.f;

typedef struct {
  CFTimeInterval beginTime;
  CFTimeInterval duration;
  double fromValue;
  double toValue;
  double damping;
  double velocity;
} TAAnimationParameters;

typedef struct {
  TAAnimationParameters rotation;
  TAAnimationParameters bounce;
} TAPlusButtonAnimationsParameters;

TAPlusButtonAnimationsParameters const kPlusButtonExpandAnimationParameters = (TAPlusButtonAnimationsParameters) {
  .rotation = (TAAnimationParameters) {
    .duration = kAnimationDuration / 4.0,
    .fromValue = 0.0,
    .toValue = M_PI * 2.0 + 45.0 * kDegreeToRadiansRatio
  },
  .bounce = (TAAnimationParameters) {
    .beginTime = kAnimationDuration / 4.0,
    .fromValue = 45.0 * kDegreeToRadiansRatio + M_PI / 8.0,
    .toValue = 45.0 * kDegreeToRadiansRatio
  }
};

TAAnimationParameters const kBounceAnimationParameters = (TAAnimationParameters) {
  .duration = kAnimationDuration * 2.0 / 3.0,
  .damping = 0.5,
  .velocity = 3.0
};


TAPlusButtonAnimationsParameters const kPlusButtonCollapseAnimationParameters = (TAPlusButtonAnimationsParameters) {
  .rotation = (TAAnimationParameters) {
    .duration = kAnimationDuration / 4.0,
    .fromValue = 0.0,
    .toValue = 315.0 * kDegreeToRadiansRatio
  },
  .bounce = (TAAnimationParameters) {
    .beginTime = kAnimationDuration / 4.0,
    .fromValue = M_PI / 8.0,
    .toValue = 0.0
  }
};

TAAnimationParameters const kTabBarExpandAnimationParameters = (TAAnimationParameters) {
  .duration = kAnimationDuration / 2.0,
  .damping = 0.5,
  .velocity = 0.6
};

TAAnimationParameters const kTabBarCollapseAnimationParameters = (TAAnimationParameters) {
  .duration = kAnimationDuration * 0.6,
  .damping = 1,
  .velocity = 0.2
};


typedef struct {
  NSTimeInterval duration;
  NSTimeInterval delay;
  CGFloat damping;
  CGFloat velocity;
  UIViewAnimationOptions options;
} TATabBarItemViewAnimationParameters;

TATabBarItemViewAnimationParameters const kHideTabBarItemViewAnimationParameters = (TATabBarItemViewAnimationParameters) {
  .duration = 1 / 8.0,
};


@implementation TAAnimationManager

- (CAAnimation *)expandAnimationForplusButton {
  return [self animationForPlusButton:kPlusButtonExpandAnimationParameters];
}

- (CAAnimation *)collapseAnnimationForPlusButton {
  return [self animationForPlusButton:kPlusButtonCollapseAnimationParameters];
}


- (CAAnimation *)animationForPlusButton:(TAPlusButtonAnimationsParameters)animationsParameters {
  
  CABasicAnimation *rotation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
  rotation.fromValue = @(animationsParameters.rotation.fromValue);
  rotation.toValue = @(animationsParameters.rotation.toValue);
  rotation.duration = animationsParameters.rotation.duration;
  rotation.fillMode = kCAFillModeForwards;
  rotation.removedOnCompletion = NO;
  
  
  CAKeyframeAnimation *bouncedRotation = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation.z"];
  
  bouncedRotation.removedOnCompletion = NO;
  bouncedRotation.fillMode = kCAFillModeForwards;
  bouncedRotation.duration = kBounceAnimationParameters.duration;
  bouncedRotation.values = [self animationValuesFromValue:animationsParameters.bounce.fromValue
                                            toValue:animationsParameters.bounce.toValue
                                        withDamping:kBounceAnimationParameters.damping
                                        andVelocity:kBounceAnimationParameters.velocity];
  
  bouncedRotation.beginTime = animationsParameters.bounce.beginTime;
  
  return [self groupWithAnimations:@[rotation, bouncedRotation] andDuration:kAnimationDuration];
}

static const NSUInteger kNumberOfPoints = 50;
static const double kDampingMutiplier = 10;
static const double kVelocityMutiplier = 10;

double normalizeAnimationValue(double value, double damping, double velocity) {
  return pow(M_E, -damping * value) * cos(velocity * value);
}

- (NSArray *)animationValuesFromValue:(double)fromValue
                              toValue:(double)toValue
                          withDamping:(double)damping
                          andVelocity:(double)velocity
{
  NSMutableArray *values = [NSMutableArray new];
  CGFloat distanceBetweenValues = toValue - fromValue;
  velocity *= kVelocityMutiplier;
  damping *= kDampingMutiplier;
  
  for (double i = 0; i < kNumberOfPoints; ++i) {
    double x = i / kNumberOfPoints;
    double normalizedValue = normalizeAnimationValue(x, damping, velocity);
    double value = toValue - distanceBetweenValues * normalizedValue;
    [values addObject:@(value)];
  }
  
  //  with different arguments alghorithm above produces values where
  //  last values not equal to toValue therefore line below is required(not a perfect fix for issue but will do for now)
  [values addObject:@(toValue)];
  
  return [NSArray arrayWithArray:values];
}


- (CAAnimationGroup *)groupWithAnimations:(NSArray *)animations andDuration:(CFTimeInterval)duration {
  CAAnimationGroup *group = [CAAnimationGroup animation];
  group.duration = duration;
  group.animations = animations;
  group.removedOnCompletion = NO;
  group.fillMode = kCAFillModeForwards;
  return group;
}

- (void)animateMainView:(UIView *)mainView frameExpand:(CGRect)rect {
  CAAnimation *animation = [self animationForTabBarExpandFromRect:mainView.bounds toRect:rect];
  animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
  [mainView.layer.mask addAnimation:animation forKey:nil];
}

- (void)animateMainView:(UIView *)mainView frameCollapse:(CGRect)rect {
  CAAnimation *animation = [self animationForTabBarCollapseFromRect:mainView.bounds toRect:rect];
  animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
  [mainView.layer.mask addAnimation:animation forKey:nil];
}



- (NSArray *)animationValuesForPathFromValue:(CGRect)fromValue
                                     toValue:(CGRect)toValue
                                 withDamping:(double)damping
                                 andVelocity:(double)velocity
{
  NSArray *xValues = [self animationValuesFromValue:fromValue.origin.x
                                            toValue:toValue.origin.x
                                        withDamping:damping
                                        andVelocity:velocity];
  NSArray *widthValues = [self animationValuesFromValue:fromValue.size.width
                                                toValue:toValue.size.width
                                            withDamping:damping
                                            andVelocity:velocity];
  NSMutableArray *pathValues = [NSMutableArray new];
  CGFloat cornerRadius = fromValue.size.height / 2.f;
  CGRect rect = fromValue;
  
  for (NSInteger i = 0; i < xValues.count; ++i) {
    CGFloat x = [(NSNumber *)xValues[i] floatValue];
    CGFloat width = [(NSNumber *)widthValues[i] floatValue];
    
    rect.origin.x = x;
    rect.size.width = width;
    
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:cornerRadius];
    [pathValues addObject:(id)path.CGPath];
  }
  
  return [NSArray arrayWithArray:pathValues];
}


- (CAAnimation *)animationForTabBarExpandFromRect:(CGRect)fromRect toRect:(CGRect)toRect {
  return [self animationExpandCollapse:kTabBarExpandAnimationParameters from:fromRect toRect:toRect];
}


- (CAAnimation *)animationExpandCollapse:(TAAnimationParameters)params 
                                    from:(CGRect)fromRect
                                  toRect:(CGRect)toRect {
  CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"path"];
  
  animation.removedOnCompletion = NO;
  animation.fillMode = kCAFillModeForwards;
  animation.duration = params.duration;
  animation.values = [self animationValuesForPathFromValue:fromRect
                                                   toValue:toRect
                                               withDamping:params.damping
                                               andVelocity:params.velocity];
  return animation;

}


- (CAAnimation *)animationForTabBarCollapseFromRect:(CGRect)fromRect toRect:(CGRect)toRect {
  return [self animationExpandCollapse:kTabBarCollapseAnimationParameters from:fromRect toRect:toRect];
}

- (void)buttonsHideWithAnimation:(NSArray *)buttons plusButton:(UIButton *)plusButton {
  [UIView animateWithDuration:kHideTabBarItemViewAnimationParameters.duration
                   animations:^{
                     for (UIButton *button in buttons) {
                       button.center = CGPointMake(plusButton.center.x + CGRectGetWidth(plusButton.frame) + 15.0f, plusButton.center.y);
                     }
                   }completion:^(BOOL finished) {
                     for (UIButton *button in buttons) {
                       button.hidden = YES;
                     }
                   }];

}
@end
