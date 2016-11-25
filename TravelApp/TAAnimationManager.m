//
//  TAAnimationManager.m
//  TravelApp
//
//  Created by Alexander on 11/24/16.
//  Copyright © 2016 Home. All rights reserved.
//

#import "TAAnimationManager.h"

@implementation TAAnimationConfiguration

- (instancetype)initWithDuration:(CGFloat)duration
                         damping:(CGFloat)damping
                        velocity:(CGFloat)velocity
                        fromRect:(CGRect)fromRect
                          toRect:(CGRect)toRect 
                    functionName:(NSString *)functionName {
  
  if (self = [super init]) {
    _fromRect = fromRect;
    _toRect = toRect;
    _velocity = velocity;
    _duration = duration;
    _damping = damping;
    _functionName = functionName;
  }
  
  return self;
  
}


- (CGFloat)fromX {
  return self.fromRect.origin.x;
}

- (CGFloat)fromWidth {
  return self.fromRect.size.width;
}

- (CGFloat)toX {
  return self.toRect.origin.x;
}

- (CGFloat)toWidth {
  return self.toRect.size.width;
}

- (CGFloat)fromHeight {
  return self.fromRect.size.height;
}
@end


@implementation TAAnimationManager

- (CAAnimation *)keyFrameWithConfiguration:(TAAnimationConfiguration *)configuration {
  CAKeyframeAnimation *keyFrameAnimation = [CAKeyframeAnimation animationWithKeyPath:@"path"];
  
  keyFrameAnimation.removedOnCompletion = NO;
  keyFrameAnimation.fillMode = kCAFillModeForwards;
  keyFrameAnimation.duration = configuration.duration;
  keyFrameAnimation.values = [self valuesConfiguration:configuration];
  
  keyFrameAnimation.timingFunction = [CAMediaTimingFunction functionWithName:configuration.functionName];
  
  return keyFrameAnimation;
}

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


static const NSUInteger kNumberOfPoints = 50;
static const double kDampingMutiplier = 10;
static const double kVelocityMutiplier = 10;

double yal_normalizeAnimationValue(double value, double damping, double velocity) {
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
    double normalizedValue = yal_normalizeAnimationValue(x, damping, velocity);
    double value = toValue - distanceBetweenValues * normalizedValue;
    [values addObject:@(value)];
  }
  
  //  with different arguments alghorithm above produces values where
  //  last values not equal to toValue therefore line below is required(not a perfect fix for issue but will do for now)
  [values addObject:@(toValue)];
  
  return [NSArray arrayWithArray:values];
}

@end
