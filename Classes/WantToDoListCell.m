//
//  WantToDoListCell.m
//  MoCoTime
//
//  Created by Kenichi Yonekawa on 10/05/19.
//  Copyright 2010 Cybozu, Inc. All rights reserved.
//

#import "WantToDoListCell.h"
#import <QuartzCore/QuartzCore.h>
#import "WantToDoAlarm.h"
#import "BuiltinImages.h"
#import "NSDate+Utilities.h"
#import "NSDate+RequiredTime.h"

@interface WantToDoListCell()
- (void)setupTiTleLabel:(WantToDoAlarm *)wantToDo;
- (void)setupRequiredTimeLabel:(WantToDoAlarm *)wantToDo;
- (void)setupWantToDoImageView:(WantToDoAlarm *)wantToDo;
@end

@implementation WantToDoListCell
@synthesize wantToDoImageView = wantToDoImageView_;
@synthesize requiredTimeLabel = requiredTimeLabel_;
@synthesize titleLabel = titleLabel_;

- (void)dealloc
{
    [wantToDoImageView_ release];
    [requiredTimeLabel_ release];
    [titleLabel_ release];
    
    [super dealloc];
}

- (void)setWantToDo:(WantToDoAlarm *)wantToDo
{
    [self setupTiTleLabel:wantToDo];
    [self setupRequiredTimeLabel:wantToDo];
    [self setupWantToDoImageView:wantToDo];
}

- (void)setupTiTleLabel:(WantToDoAlarm *)wantToDo
{
    [[self titleLabel] setText:[wantToDo title]];
    CGSize contentSize =
    [[[self titleLabel] text] sizeWithFont:[[self titleLabel] font]
                         constrainedToSize:CGSizeMake([[self titleLabel] frame].size.width, 1000)
                             lineBreakMode:[[self titleLabel] lineBreakMode]];
    
    CGRect newFrame = [[self titleLabel] frame];
    newFrame.size.height = MIN(77.0f, contentSize.height);
    [[self titleLabel] setFrame:newFrame];
}

- (void)setupRequiredTimeLabel:(WantToDoAlarm *)wantToDo
{
    NSDate *requiredTimeDate = 
        [NSDate dateFromRequiredTimeInterval:[wantToDo requiredTimeInterval]];
    NSMutableString *requiredTimeText = [[NSMutableString alloc] init];
    if ([requiredTimeDate hour] > 0 && [requiredTimeDate minute] > 0)
    {
        [requiredTimeText appendFormat:NSLocalizedString(@"If I get up %d hour %d minutes early", @"If I get up early"),
                                       [requiredTimeDate hour],
                                       [requiredTimeDate minute]];
    }
    else if ([requiredTimeDate hour] > 0)
    {
        [requiredTimeText appendFormat:NSLocalizedString(@"If I get up %d hour early", @"If I get up early"),
                                       [requiredTimeDate hour]];
    }
    else if ([requiredTimeDate minute] > 0)
    {
        [requiredTimeText appendFormat:NSLocalizedString(@"If I get up %d minutes early", @"If I get up early"),
                                       [requiredTimeDate minute]];
    }
    [[self requiredTimeLabel] setText:requiredTimeText];
    [requiredTimeText release];
}

- (void)setupWantToDoImageView:(WantToDoAlarm *)wantToDo
{
    if (![self wantToDoImageView])
    {
        CGRect imageViewRect = CGRectMake(10, 10, 57, 57);
        UIView *roundRectMask = [[UIView alloc] initWithFrame:imageViewRect];
        [roundRectMask setClipsToBounds:YES];
        [[roundRectMask layer] setCornerRadius:7];
        
        imageViewRect.origin = CGPointMake(0, 0);
        UIImageView *wantToDoImageView = 
            [[UIImageView alloc] initWithFrame:imageViewRect];
        [self setWantToDoImageView:wantToDoImageView];
        [wantToDoImageView release];
        
        [roundRectMask addSubview:[self wantToDoImageView]];
        [self addSubview:roundRectMask];
        
        [NSThread detachNewThreadSelector:@selector(setupImageByAsynchronous:)
                                 toTarget:self
                               withObject:wantToDo];
    }
}

- (void)setupImageByAsynchronous:(WantToDoAlarm *)wantToDo
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];

    UIImage *wantToDoImage = nil;
    if (![[NSFileManager defaultManager] fileExistsAtPath:[wantToDo imagePath]])
    {
        wantToDoImage =
            [[[BuiltinImages instance] defaultWantToDoViewBackground] retain];
    }
    else
    {
        wantToDoImage = [[UIImage alloc] initWithContentsOfFile:[wantToDo imagePath]];
    }
    [[self wantToDoImageView] performSelectorOnMainThread:@selector(setImage:)
                                               withObject:wantToDoImage
                                            waitUntilDone:YES];        
    [wantToDoImage release];
    [pool release];
}

@end
