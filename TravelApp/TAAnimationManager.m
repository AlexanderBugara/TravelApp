//
//  TAAnimationManager.m
//  TravelApp
//
//  Created by Alexander on 11/24/16.
//  Copyright © 2016 Home. All rights reserved.
//

#import "TAAnimationManager.h"
#import "YALSpringAnimation.h"

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




//- (CAAnimation *)keyFrameWithConfiguration:(TAAnimationConfiguration *)configuration {
//  CAKeyframeAnimation *keyFrameAnimation = [CAKeyframeAnimation animationWithKeyPath:@"path"];
//  
//  keyFrameAnimation.removedOnCompletion = NO;
//  keyFrameAnimation.fillMode = kCAFillModeForwards;
//  keyFrameAnimation.duration = configuration.duration;
//  keyFrameAnimation.values = [self valuesConfiguration:configuration];
//  
//  keyFrameAnimation.timingFunction = [CAMediaTimingFunction functionWithName:configuration.functionName];
//  
//  return keyFrameAnimation;
//}
//

TAAnimationParameters const kYALTabBarExpandAnimationParameters = (TAAnimationParameters) {
  .duration = kAnimationDuration / 2.0,
  .damping = 0.5,
  .velocity = 0.6
};

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


- (CAAnimation *)animationForTabBarExpandFromRect:(CGRect)fromRect toRect:(CGRect)toRect {
  return [YALSpringAnimation animationForRoundedRectPathWithduration:kYALTabBarExpandAnimationParameters.duration
                                                             damping:kYALTabBarExpandAnimationParameters.damping
                                                            velocity:kYALTabBarExpandAnimationParameters.velocity
                                                           fromValue:fromRect
                                                             toValue:toRect];
}

TAAnimationParameters const kYALTabBarCollapseAnimationParameters = (TAAnimationParameters) {
  .duration = kAnimationDuration * 0.6,
  .damping = 1,
  .velocity = 0.2
};

- (CAAnimation *)animationForTabBarCollapseFromRect:(CGRect)fromRect toRect:(CGRect)toRect {
  return [YALSpringAnimation animationForRoundedRectPathWithduration:kYALTabBarCollapseAnimationParameters.duration
                                                             damping:kYALTabBarCollapseAnimationParameters.damping
                                                            velocity:kYALTabBarCollapseAnimationParameters.velocity
                                                           fromValue:fromRect
                                                             toValue:toRect];
}
@end
