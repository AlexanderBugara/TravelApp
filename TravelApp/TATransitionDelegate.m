//
//  TATransitionDelegate.m
//  TravelApp
//
//  Created by Alexander on 11/27/16.
//  Copyright © 2016 Home. All rights reserved.
//

#import "TATransitionDelegate.h"

@implementation TAAnimateTransitioning

- (CATransform3D)yRotation:(double)angle {
  return CATransform3DMakeRotation((CGFloat)angle, 0.0, 1.0, 0.0);
}

- (void)perspectiveTransformForContainerView:(UIView *)containerView {
  CATransform3D transform = CATransform3DIdentity;
  transform.m34 = -0.002;
  containerView.layer.sublayerTransform = transform;
}

- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext {
  return 20.0;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
  UIViewController *from = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
  UIViewController *to =[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
  
  CGRect initialRect = CGRectZero;
  CGRect finalRect = to.view.frame;
  
  UIView *snapshot = [to.view snapshotViewAfterScreenUpdates:YES];
  snapshot.frame = initialRect;
  snapshot.layer.cornerRadius = 25;
  snapshot.layer.masksToBounds = YES;
  
  UIView *containerView = [transitionContext containerView];
  //[containerView addSubview:to.view];
 // [to.view setHidden:YES];
  [containerView addSubview:snapshot];
  
  snapshot.layer.transform = [self yRotation:M_PI_2];
  [self perspectiveTransformForContainerView:containerView];
  
  double duration = [self transitionDuration:transitionContext];
  
  
  [UIView animateKeyframesWithDuration:duration
                                 delay:0.0
                               options:UIViewKeyframeAnimationOptionCalculationModeCubic
                            animations:^{
                              
                               [UIView addKeyframeWithRelativeStartTime:0.0
                                 relativeDuration:duration/3
                                 animations:^{
                                   from.view.layer.transform = [self yRotation:-M_PI_2];
                               }];
                              
                              
                              [UIView addKeyframeWithRelativeStartTime:duration/3
                                                      relativeDuration:duration/3
                                                            animations:^{
                                                              snapshot.layer.transform = [self yRotation:0.0];
                                                            }];
                              
                              [UIView addKeyframeWithRelativeStartTime:2*duration/3
                                                      relativeDuration:duration/3
                                                            animations:^{
                                                              snapshot.frame = finalRect;
                                                            }];


                            }
                            completion:^(BOOL finished) {
                              
                            }];
 
//                              
//
////
//                            } completion:^(BOOL finished) {
////                              [to.view setHidden:NO];
////                              from.view.layer.transform = [self yRotation:0.0];
////                              [snapshot removeFromSuperview];
////                              [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
//                            }];
}

@end

@implementation TATransitionDelegate
/*
 @optional
 ;
 
 - (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed;
 
 - (nullable id <UIViewControllerInteractiveTransitioning>)interactionControllerForPresentation:(id <UIViewControllerAnimatedTransitioning>)animator;
 
 - (nullable id <UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id <UIViewControllerAnimatedTransitioning>)animator;
 
 - (nullable UIPresentationController *)presentationControllerForPresentedViewController:(UIViewController *)presented presentingViewController:(nullable UIViewController *)presenting sourceViewController:(UIViewController *)source NS_AVAILABLE_IOS(8_0);

 */
- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
  
  return [TAAnimateTransitioning new];
}


@end


