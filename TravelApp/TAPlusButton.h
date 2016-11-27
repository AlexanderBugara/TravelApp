//
//  TAPlusButton.h
//  TravelApp
//
//  Created by Alexander on 11/28/16.
//  Copyright © 2016 Home. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TAPlusButton : UIButton
@property (copy) void (^layoutChangeBlock)(CGRect frame);
@end
