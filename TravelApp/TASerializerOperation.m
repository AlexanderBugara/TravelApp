//
//  TASerializerOperation.m
//  TravelApp
//
//  Created by Alexander on 11/25/16.
//  Copyright © 2016 Home. All rights reserved.
//

#import "TASerializerOperation.h"

@interface TASerializerOperation ()
@property (nonatomic, strong) NSString *key;
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

- (NSArray *)readArrayWithCustomObjFromUserDefaults:(NSString*)keyName {
  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  NSData *data = [defaults objectForKey:keyName];
  NSArray *myArray = [NSKeyedUnarchiver unarchiveObjectWithData:data];
  [defaults synchronize];
  return myArray;
}

- (instancetype)initWithKey:(NSString *)key {
  if (self = [super init]) {
    _key = key;
  }
  return self;
}
@end
