#import "CATransaction+Extend.h"

@implementation CATransaction (Extend)

+ (void)transactionAnimations:(void(^)(void))animations
                   completion:(void(^)(void))completion {
  
    [CATransaction begin]; {
        [CATransaction setCompletionBlock:completion];
        if (animations) {
            animations();
        }
    } [CATransaction commit];
}


@end
