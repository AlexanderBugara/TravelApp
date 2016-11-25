//
//  TAStoreManager.h
//  TravelApp
//
//  Created by Alexander on 11/25/16.
//  Copyright © 2016 Home. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface TAStoreManager : NSObject
+ (id)sharedManager;
- (void)addImage:(UIImage *)image forhKey:(NSString *)key;
- (UIImage *)imageForKey:(NSString *)key;
@end
