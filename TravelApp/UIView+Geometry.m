//
//  UIView+Geometry.m
//  TravelApp
//
//  Created by Alexander on 11/23/16.
//  Copyright © 2016 Home. All rights reserved.
//

#import "UIView+Geometry.h"

@implementation UIView (Geometry)
- (void)setOrigin:(CGPoint)origin {
  CGRect copyRect = self.frame;
  copyRect.origin = origin;
  self.frame = copyRect;
}

- (CGFloat)height_ {
  return self.frame.size.height;
}

- (CGFloat)width_ {
  return self.frame.size.width;
}

- (CGFloat)centerX_ {
  if (self.frame.size.width != 0)
    return self.frame.size.width / 2;
  
  return 0;
}

- (CGFloat)x_ {
  return self.frame.origin.x;
}

- (CGFloat)y_ {
  return self.frame.origin.y;
}
@end
