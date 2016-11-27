//
//  TAOfferViewContoller.m
//  TravelApp
//
//  Created by Alexander on 11/27/16.
//  Copyright © 2016 Home. All rights reserved.
//

#import "TAOfferViewContoller.h"
#import "Masonry.h"

@implementation TAOfferViewContoller

- (void)viewDidLoad {
  
  [self.view setBackgroundColor:[UIColor whiteColor]];
  UILabel *label = [[UILabel alloc] init];
  label.text = @"Offer details are not yet implemented!";
  [self.view addSubview:label];
  [label mas_makeConstraints:^(MASConstraintMaker *make) {
    make.center.equalTo(self.view);
  }];
  
  UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userDidTap:)];
  
  [self.view addGestureRecognizer:tapGesture];
}

- (void)userDidTap:(id)sender {
  [self dismissViewControllerAnimated:YES completion:nil];
}
@end
