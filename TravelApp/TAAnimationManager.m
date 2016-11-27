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


//@implementation TAAnimationConfiguration
//
//- (instancetype)initWithDuration:(CGFloat)duration
//                         damping:(CGFloat)damping
//                        velocity:(CGFloat)velocity
//                        fromRect:(CGRect)fromRect
//                          toRect:(CGRect)toRect 
//                    functionName:(NSString *)functionName {
//  
//  if (self = [super init]) {
//    _fromRect = fromRect;
//    _toRect = toRect;
//    _velocity = velocity;
//    _duration = duration;
//    _damping = damping;
//    _functionName = functionName;
//  }
//  
//  return self;
//  
//}
//
//
//- (CGFloat)fromX {
//  return self.fromRect.origin.x;
//}
//
//- (CGFloat)fromWidth {
//  return self.fromRect.size.width;
//}
//
//- (CGFloat)toX {
//  return self.toRect.origin.x;
//}
//
//- (CGFloat)toWidth {
//  return self.toRect.size.width;
//}
//
//- (CGFloat)fromHeight {
//  return self.fromRect.size.height;
//}
//@end


@implementation TAAnimationManager

/*

- (NSArray *)valuesConfiguration:(TAAnimationConfiguration *)configuration {

    NSArray *xValues = [self animationValuesFromValue:configuration.fromX
                                              toValue:configuration.toX
                                          withDamping:configuration.damping
                                          andVelocity:configuration.velocity];
  
    NSArray *widthValues = [self animationValuesFromValue:configuration.fromWidth
                                                  toValue:configuration.toWidth
                                              withDamping:configuration.damping
                                              andVelocity:configuration.velocity];
  
    NSMutableArray *pathValues = [NSMutableArray new];
    CGFloat cornerRadius = configuration.fromHeight / 2.f;
    CGRect rect = configuration.fromRect;
    
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
*/


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
- (CAAnimationGroup *)groupWithAnimations:(NSArray *)animations andDuration:(CFTimeInterval)duration {
  CAAnimationGroup *group = [CAAnimationGroup animation];
  group.duration = duration;
  group.animations = animations;
  group.removedOnCompletion = NO;
  group.fillMode = kCAFillModeForwards;
  return group;
}



@end
