//
//  TATravelItem.m
//  TravelApp
//
//  Created by Alexander on 11/25/16.
//  Copyright © 2016 Home. All rights reserved.
//

#import "TATravelItem.h"
#import <objc/runtime.h>

@interface TATravelItem ()
@property (nonatomic, strong) NSDateFormatter *dateFormatter;
@end

@implementation TATravelItem

- (NSDateFormatter *)dateFormatter {
  if (!_dateFormatter) {
    _dateFormatter = [[NSDateFormatter alloc] init];
    //[_dateFormatter setDateFormat:@"HH:mm"];
    _dateFormatter.timeStyle = NSDateFormatterShortStyle;
    _dateFormatter.dateFormat = @"k:mm";
    [_dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
  }
  return _dateFormatter;
}

- (instancetype)initWithJSON:(NSDictionary *)json {
  if (self = [super init]) {
    
    @try {
      [self traverceInPropertiesWithBlock:^(NSString *name) {
        if ([name isEqualToString:@"id_"]) {
          [self setValue:json[@"id"] forKey:@"id_"];
        } else if ([name isEqualToString:@"provider_logo"]) {
          NSString *logoURL = json[@"provider_logo"];
          logoURL = [logoURL stringByReplacingOccurrencesOfString:@"{size}" withString:@"63"];
          _provider_logo = logoURL;
        } else {
          [self setValue:json[name] forKey:name];
        }
      }];
      
      NSDate *arrival = [self.dateFormatter dateFromString:json[@"arrival_time"]];
      _arrivalDate = arrival;
    
      NSDate *departure = [self.dateFormatter dateFromString:json[@"departure_time"]];
      _departureDate = departure;
    
      NSTimeInterval secondsBetween = [arrival timeIntervalSinceDate:departure];
      _duration = @(secondsBetween);

    }
     @catch (NSException *exception) {
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

- (NSString *)durationString {
  NSInteger minutes = ([self.duration integerValue]/ 60) % 60;
  NSInteger hours = [self.duration integerValue] / 3600;
  return [NSString stringWithFormat:@"%ld:%ld",(long)hours, (long)minutes];
}

@end
