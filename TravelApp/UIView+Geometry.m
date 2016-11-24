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
@end
