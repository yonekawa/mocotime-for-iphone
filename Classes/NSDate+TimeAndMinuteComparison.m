//
//  NSDate+TimeAndMinuteComparison.m
//  MoCoTime
//
//  Created by Kenichi Yonekawa on 10/05/06.
//  Copyright 2010 Cybozu, Inc. All rights reserved.
//

#import "NSDate+TimeAndMinuteComparison.h"
#import "NSDate+Utilities.h"

@implementation NSDate (TimeAndMinuteCompareExtensions)
- (BOOL)isEqualToTimeAndMinutes:(NSDate *)time
{
    NSDate *now = [NSDate date];
    return ([now hour] == [time hour] && [now minute] == [time minute]);
}

@end
