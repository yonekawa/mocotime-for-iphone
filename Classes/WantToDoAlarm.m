//
//  WantToDoAlarm.m
//  MoCoTime
//
//  Created by Kenichi Yonekawa on 10/04/29.
//  Copyright 2010 Cybozu, Inc. All rights reserved.
//

#import "WantToDoAlarm.h"
#import "NSDate+Utilities.h"
#import "NSDate+RequiredTime.h"

@implementation WantToDoAlarm
@synthesize surrogateKey = surrogateKey_;
@synthesize imagePath = imagePath_;
@synthesize title = title_;
@synthesize requiredTimeInterval = requiredTimeInterval_;

- (void)dealloc
{
    [imagePath_ release];
    [title_ release];
    [super dealloc];
}

- (NSDate *)time
{
    return [time_ addTimeInterval:-[self requiredTimeInterval]];
}

@end
