//
//  TAPlusButton.m
//  TravelApp
//
//  Created by Alexander on 11/28/16.
//  Copyright © 2016 Home. All rights reserved.
//

#import "TAPlusButton.h"

@implementation TAPlusButton

- (void)layoutSubviews {
  [super layoutSubviews];
  if (self.layoutChangeBlock) {
    self.layoutChangeBlock(self.frame);
  }
}
@end
