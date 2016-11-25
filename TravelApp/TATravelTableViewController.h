//
//  TATravelTableViewController.h
//  TravelApp
//
//  Created by Alexander on 11/16/16.
//  Copyright © 2016 Home. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TANetworkContext;

@interface TATravelTableViewController : UITableViewController
- (instancetype)initWithNetworkContext:(TANetworkContext *)context;
@end
