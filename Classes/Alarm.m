//
//  Alarm.m
//  MoCoTime
//
//  Created by Kenichi Yonekawa on 10/05/05.
//  Copyright 2010 Cybozu, Inc. All rights reserved.
//

#import "Alarm.h"

@implementation Alarm
@synthesize time = time_;

- (void)dealloc
{
    [time_ release];
    [super dealloc];
}

@end
