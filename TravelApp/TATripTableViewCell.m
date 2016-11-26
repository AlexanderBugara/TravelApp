//
//  TATripTableViewCell.m
//  TravelApp
//
//  Created by Alexander on 11/25/16.
//  Copyright © 2016 Home. All rights reserved.
//

#import "TATripTableViewCell.h"
#import "Masonry.h"
#import "TATravelItem.h"
#import "TAThumbnailView.h"

@interface TATripTableViewCell ()
@property (nonatomic, weak, readwrite ) TAThumbnailView *imageView_;
@property (nonatomic, weak, readwrite ) UILabel *departureArrivalTime;
@property (nonatomic, weak, readwrite ) UILabel *numberOfChanges;
@property (nonatomic, weak, readwrite ) UILabel *price;
@property (nonatomic, weak, readwrite ) UILabel *duration;
@property (assign) BOOL constraintsUpdated;
@end

@implementation TATripTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)updateConstraints {
 
  
  if (!self.constraintsUpdated) {
      [self.imageView_ mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(10));
        make.left.equalTo(@10);
        make.height.equalTo(@60);
        make.width.equalTo(@160);
      }];
    
      [self.departureArrivalTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.imageView_.mas_bottom).offset(10);
        make.height.equalTo(@20);
        make.left.equalTo(self.imageView_);
        make.bottom.equalTo(@(-10));
      }];
    
      [self.price mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(10));
        make.right.equalTo(self.contentView.mas_right).offset(-10);
        make.width.equalTo(@150);
        make.height.equalTo(self.departureArrivalTime);
      }];
    
      [self.numberOfChanges mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.departureArrivalTime);
        make.right.equalTo(self.contentView).offset(-10);
        make.width.equalTo(@150);
        make.height.equalTo(self.departureArrivalTime);
      }];

      [self.duration mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.departureArrivalTime);
        make.right.equalTo(self.numberOfChanges.mas_left);
        make.width.equalTo(@100);
        make.height.equalTo(self.numberOfChanges);
      }];
    
      self.constraintsUpdated = YES;
  }
  [super updateConstraints];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier {
  
  if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
    TAThumbnailView *imageView = [[TAThumbnailView alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:imageView];
    _imageView_ = imageView;
    
    UILabel *departureArrivalTime = [[UILabel alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:departureArrivalTime];
    _departureArrivalTime = departureArrivalTime;
    
    UILabel *numberOfChanges = [[UILabel alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:numberOfChanges];
    _numberOfChanges = numberOfChanges;
    [_numberOfChanges setTextAlignment:NSTextAlignmentRight];
    
    UILabel *price = [[UILabel alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:price];
    _price = price;
    [_price setTextAlignment:NSTextAlignmentRight];
    
    
    UILabel *duration = [[UILabel alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:duration];
    _duration = duration;
    [_duration setTextAlignment:NSTextAlignmentRight];
  }
  return self;
  
}

- (void)configureWith:(TATravelItem *)travelItem {
  
  self.departureArrivalTime.text = [NSString stringWithFormat:@"%@ - %@",travelItem.departure_time, travelItem.arrival_time];
  self.numberOfChanges.text = [NSString stringWithFormat:@"Transfers: %@",travelItem.number_of_stops];
  self.price.text = [NSString stringWithFormat:@"Price: %@ EUR",travelItem.price_in_euros];
  self.duration.text = [NSString stringWithFormat:@"Direct: %@",[travelItem durationString]];
  [self.imageView_ setImageWithURL:[NSURL URLWithString:travelItem.provider_logo] ];
}

@end
