//
//  EditWantToDoTitleCell.m
//  MoCoTime
//
//  Created by Kenichi Yonekawa on 10/05/16.
//  Copyright 2010 Cybozu, Inc. All rights reserved.
//

#import "EditWantToDoTitleCell.h"
#import "WantToDoAlarm.h"

@implementation EditWantToDoTitleCell
@synthesize titleLabel = titleLabel_;
@synthesize titleContents = titleContents_;

- (void)dealloc
{
    [titleLabel_ release];
    [titleContents_ release];
    
    [super dealloc];
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    self->maxHeight_ = 
        [self frame].size.height - [[self titleContents] frame].origin.y * 2;
}

- (void)setContents:(id)contents
{
    if (![contents isKindOfClass:[WantToDoAlarm class]])
        return;
    
    [[self titleLabel] setText:NSLocalizedString(@"Want to do", @"Want To Do")];
    [[self titleContents] setText:[contents title]];
    
    CGSize contentSize =
        [[[self titleContents] text] sizeWithFont:[[self titleContents] font]
                                constrainedToSize:CGSizeMake([[self titleContents] frame].size.width, 1000)
                                    lineBreakMode:[[self titleContents] lineBreakMode]];
    
    CGRect newFrame = [[self titleContents] frame];
    newFrame.size.height = MIN(maxHeight_, contentSize.height);
    newFrame.size.height = MAX(23.0f, newFrame.size.height);
    [[self titleContents] setFrame:newFrame];
    
    cellHeight_ = newFrame.size.height + newFrame.origin.y * 2;
}

- (CGFloat)heightForCell
{
    return cellHeight_;
}

@end
