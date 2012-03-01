//
//  NSDate+RequiredTime.m
//  MoCoTime
//
//  Created by Kenichi Yonekawa on 10/05/16.
//  Copyright 2010 Cybozu, Inc. All rights reserved.
//

#import "NSDate+RequiredTime.h"
#import "NSDate+Utilities.h"

@implementation NSDate(RequiredTimeExtensions)
+ (NSDate *)dateFromRequiredTimeInterval:(NSTimeInterval)interval
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    //[calendar setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
    NSCalendarUnit flags = NSEraCalendarUnit |
                           NSYearCalendarUnit |
                           NSMonthCalendarUnit |
                           NSDayCalendarUnit |
                           NSHourCalendarUnit |
                           NSMinuteCalendarUnit |
                           NSSecondCalendarUnit;
    NSDateComponents *components =
        [calendar components:flags fromDate:[NSDate date]];
    [components setYear:2001];
    [components setMonth:1];
    [components setDay:1];
    [components setHour:0];
    [components setMinute:0];
    [components setSecond:0];
    
    NSDate *referenceDate = [calendar dateFromComponents:components];
    return [referenceDate addTimeInterval:interval];
}

- (NSTimeInterval)requiredTimeInterval
{
    NSDate *from = [NSDate dateWithTimeIntervalSinceReferenceDate:0];
    NSDate *to = [NSDate dateWithTimeIntervalSinceReferenceDate:0];
    to = [to dateByAddingHours:[self hour]];
    to = [to dateByAddingMinutes:[self minute]];
    return [to timeIntervalSinceDate:from];
}

@end
