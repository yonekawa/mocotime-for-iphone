//
//  NSDate+TimeAndMinuteComparison.h
//  MoCoTime
//
//  Created by Kenichi Yonekawa on 10/05/06.
//  Copyright 2010 Cybozu, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (TimeAndMinuteCompareExtensions)
- (BOOL)isEqualToTimeAndMinutes:(NSDate *)time;
@end
