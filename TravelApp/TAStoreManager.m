//
//  TAStoreManager.m
//  TravelApp
//
//  Created by Alexander on 11/25/16.
//  Copyright © 2016 Home. All rights reserved.
//

#import "TAStoreManager.h"


@interface TAStoreManager ()
@property (nonatomic, strong) NSMutableDictionary *thumbnailStorage;
@end

@implementation TAStoreManager
+ (id)sharedManager {
  
  static TAStoreManager *sharedMyManager = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    sharedMyManager = [[self alloc] init];
  });
  return sharedMyManager;
}

- (id)init {
  if (self = [super init]) {
    
  }
  return self;
}

- (void)dealloc {
  // Should never be called, but just here for clarity really.
}

- (void)addImage:(UIImage *)image forhKey:(NSString *)key {
  
  if (image && key) {
    [self.thumbnailStorage setObject:image forKey:key];
  }
}
- (UIImage *)imageForKey:(NSString *)key {
  return self.thumbnailStorage[key];
}

- (NSMutableDictionary *)thumbnailStorage {
  if (!_thumbnailStorage) {
    _thumbnailStorage = [NSMutableDictionary dictionary];
  }
  return _thumbnailStorage;
}
@end
