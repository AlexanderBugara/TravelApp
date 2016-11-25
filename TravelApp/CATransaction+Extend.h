#import <QuartzCore/QuartzCore.h>

@interface CATransaction (Extend)

+ (void)transactionAnimations:(void(^)(void))animations
                   completion:(void(^)(void))completion;

@end
