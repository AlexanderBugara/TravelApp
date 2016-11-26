//
//  TASerializerOperation.m
//  TravelApp
//
//  Created by Alexander on 11/25/16.
//  Copyright © 2016 Home. All rights reserved.
//

#import "TASerializerOperation.h"

@interface TASerializerOperation ()

@end

@implementation TASerializerOperation
- (void)main {
  @try {
    [self writeArrayWithCustomObjToUserDefaults:self.key withArray:self.trips];
  } @catch (NSException *exception) {
    NSLog(@"TASerializerOperation: %@", exception.description);
  } @finally {
    
  }
}

- (void)writeArrayWithCustomObjToUserDefaults:(NSString *)keyName
                                    withArray:(NSArray *)myArray {
  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  NSData *data = [NSKeyedArchiver archivedDataWithRootObject:myArray];
  [defaults setObject:data forKey:keyName];
  [defaults synchronize];
}

@end
