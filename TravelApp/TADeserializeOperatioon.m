//
//  TADeserializeOperatioon.m
//  TravelApp
//
//  Created by Alexander on 11/26/16.
//  Copyright © 2016 Home. All rights reserved.
//

#import "TADeserializeOperatioon.h"

@interface TADeserializeOperatioon ()
@end

@implementation TADeserializeOperatioon

- (void)main {
  @try {
    self.trips = [self readArrayWithCustomObjFromUserDefaults:self.key];
  } @catch (NSException *exception) {
    NSLog(@"TADeserializeOperatioon: %@", exception.description);
  } @finally {
    
  }
}


- (NSArray *)readArrayWithCustomObjFromUserDefaults:(NSString*)keyName {
  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  NSData *data = [defaults objectForKey:keyName];
  NSArray *myArray = [NSKeyedUnarchiver unarchiveObjectWithData:data];
  [defaults synchronize];
  return myArray;
}

@end
