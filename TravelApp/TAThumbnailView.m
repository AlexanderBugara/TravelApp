//
//  TAThumbnailView.m
//  TravelApp
//
//  Created by Alexander on 11/25/16.
//  Copyright © 2016 Home. All rights reserved.
//

#import "TAThumbnailView.h"
#import "TAStoreManager.h"
#import "Masonry.h"
#import "UIView+Geometry.h"

@interface TAThumbnailView ()
@property (nonatomic, strong) NSURLSession *urlSession;
@property (nonatomic, weak) UIActivityIndicatorView *indicator;
@end

@implementation TAThumbnailView

- (void)setImageWithURL:(NSURL *)url {
  
  [self setContentMode:UIViewContentModeScaleAspectFit];
  self.image = [[TAStoreManager sharedManager] imageForKey:[url absoluteString]];
  
  if (self.image) return;
  [self setupActivityIfNeedIt];
  [self.indicator startAnimating];
  
  __weak __typeof (self) weakSelf = self;
  
  NSURLSessionTask *task = [self.urlSession dataTaskWithURL:url
                                          completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                                            if (!error) {
                                              
                                              dispatch_async(dispatch_get_main_queue(), ^{
                                                UIImage *image = [UIImage imageWithData:data];
                                                [[TAStoreManager sharedManager] addImage:image forhKey:[url absoluteString]];
                                                [weakSelf setImage:image];
                                                [weakSelf.indicator stopAnimating];
                                              });
                                            }
    
  }];
  
  [task resume];
}

- (void)setupActivityIfNeedIt {
  if (!self.indicator) {
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [self addSubview:indicator];
    
    [indicator mas_makeConstraints:^(MASConstraintMaker *make) {
      make.center.equalTo(self);
    }];
    
    [indicator setHidesWhenStopped:YES];
    
    self.indicator = indicator;
  }
}


- (NSURLSession *)urlSession {
  if (!_urlSession) {
    _urlSession = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
  }
  return _urlSession;
}
@end
