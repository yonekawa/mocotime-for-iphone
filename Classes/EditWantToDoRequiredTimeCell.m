//
//  EditWantToDoRequiredTimeCell.m
//  MoCoTime
//
//  Created by Kenichi Yonekawa on 10/05/16.
//  Copyright 2010 Cybozu, Inc. All rights reserved.
//

#import "EditWantToDoRequiredTimeCell.h"
#import "WantToDoAlarm.h"
#import "NSDate+Utilities.h"
#import "NSDate+RequiredTime.h";

@implementation EditWantToDoRequiredTimeCell
@synthesize requiredTimeLabel = requiredTimeLabel_;
@synthesize requiredTimeContents = requiredTimeContents_;

- (void)dealloc
{
    [requiredTimeContents_ release];
    [requiredTimeLabel_ release];
    [super dealloc];
}

- (void)setContents:(id)contents
{
    if (![contents isKindOfClass:[WantToDoAlarm class]])
        return;
    
    [[self requiredTimeLabel] setText:NSLocalizedString(@"Required Time",
                                                        @"required time for want to do")];
    if ([contents requiredTimeInterval] <= 0)
    {
        [[self requiredTimeContents] setText:@""];
    }
    else
    {
        NSDate *requiredTimeDate = 
            [NSDate dateFromRequiredTimeInterval:[contents requiredTimeInterval]];
        
        NSMutableString *requiredTimeText = [[NSMutableString alloc] init];
        if ([requiredTimeDate hour] > 0)
        {
            [requiredTimeText appendFormat:NSLocalizedString(@"%d hour", @"format of required time hour"),
                                           [requiredTimeDate hour]];
        }
        if ([requiredTimeDate minute] > 0)
        {
            if ([requiredTimeDate hour] > 0)
            {
                [requiredTimeText appendString:@" "];
            }
            [requiredTimeText appendFormat:NSLocalizedString(@"%d minutes", @"format of required time minute"),
                                           [requiredTimeDate minute]];
        }

        [[self requiredTimeContents] setText:requiredTimeText];
        [requiredTimeText release];
    }
}

- (CGFloat)heightForCell
{
    return [self frame].size.height;
}

@end
