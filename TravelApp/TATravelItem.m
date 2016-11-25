//
//  TATravelItem.m
//  TravelApp
//
//  Created by Alexander on 11/25/16.
//  Copyright © 2016 Home. All rights reserved.
//

#import "TATravelItem.h"
#import <objc/runtime.h>

@implementation TATravelItem

- (instancetype)initWithJSON:(NSDictionary *)json {
  if (self = [super init]) {
    
    @try {
      [self traverceInPropertiesWithBlock:^(NSString *name) {
        if ([name isEqualToString:@"id_"]) {
          [self setValue:json[@"id"] forKey:@"id"];
        } else {
          [self setValue:json[name] forKey:name];
        }
      }];
    } @catch (NSException *exception) {
      NSLog(@"TATravelItem: inittialise with parsing Exception: %@", [exception description]);
    } @finally {
      
    }
    
  }
  return self;
}

- (void)traverceInPropertiesWithBlock:(void(^)(NSString *propertyName)) block {
  unsigned int numberOfProperties = 0;
  objc_property_t *propertyArray = class_copyPropertyList([TATravelItem class], &numberOfProperties);
  
  for (NSUInteger i = 0; i < numberOfProperties; i++) {
    objc_property_t property = propertyArray[i];
    NSString *name = [[NSString alloc] initWithUTF8String:property_getName(property)];
    block(name);
  }
  free(propertyArray);

}

- (void)encodeWithCoder:(NSCoder *)coder {
  [self traverceInPropertiesWithBlock:^(NSString *propertyName) {
    [coder encodeObject:[self valueForKey:propertyName] forKey:propertyName];
  }];
}

- (id)initWithCoder:(NSCoder *)coder {
  self = [super init];
  if (self != nil) {
    [self traverceInPropertiesWithBlock:^(NSString *propertyName) {
      [self setValue:[coder decodeObjectForKey:propertyName] forKey:propertyName];
    }];
  }
  return self;
}
@end
