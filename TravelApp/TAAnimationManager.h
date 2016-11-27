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
@end


//@interface TAAnimationConfiguration : NSObject
//@property (assign) CGRect fromRect;
//@property (assign) CGRect toRect;
//@property (assign, readonly) CGFloat fromX;
//@property (assign, readonly) CGFloat toX;
//@property (assign, readonly) CGFloat fromWidth;
//@property (assign, readonly) CGFloat toWidth;
//@property (assign, readonly) CGFloat fromHeight;
//@property (assign) CGFloat duration;
//@property (assign) CGFloat damping;
//@property (assign) CGFloat velocity;
//@property (strong, readonly) NSString *functionName;
//
//- (instancetype)initWithDuration:(CGFloat)duration
//                         damping:(CGFloat)damping
//                        velocity:(CGFloat)velocity
//                        fromRect:(CGRect)fromRect
//                          toRect:(CGRect)toRect
//                    functionName:(NSString *)functionName;
//@end
