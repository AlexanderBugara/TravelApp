//
//  TATripTableViewCell.h
//  TravelApp
//
//  Created by Alexander on 11/25/16.
//  Copyright © 2016 Home. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TATravelItem, TAThumbnailView;

@interface TATripTableViewCell : UITableViewCell
@property (nonatomic, weak, readonly ) TAThumbnailView *imageView_;
@property (nonatomic, weak, readonly ) UILabel *departureArrivalTime;
@property (nonatomic, weak, readonly ) UILabel *numberOfChanges;
@property (nonatomic, weak, readonly ) UILabel *price;
@property (nonatomic, weak, readonly ) UILabel *duration;

- (void)configureWith:(TATravelItem *)travelItem;

@end
