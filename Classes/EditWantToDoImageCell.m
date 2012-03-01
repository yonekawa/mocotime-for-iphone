//
//  EditWantToDoImageCell.m
//  MoCoTime
//
//  Created by Kenichi Yonekawa on 10/05/17.
//  Copyright 2010 Cybozu, Inc. All rights reserved.
//

#import "EditWantToDoImageCell.h"
#import "WantToDoAlarm.h"
#import "BuiltinImages.h"
#import "NSString+Utilities.h"
#import <QuartzCore/QuartzCore.h>

@implementation EditWantToDoImageCell
@synthesize delegate = delegate_;
@synthesize imageSelectButton = imageSelectButton_;
@synthesize wantToDoImageView = wantToDoImageView_;
@synthesize cameraIconImageView = cameraIconImageView_;

- (void)dealloc
{
    [imageSelectButton_ release];
    [cameraIconImageView_ release];
    [wantToDoImageView_ release];
    [super dealloc];
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    // Create round rect views.
    CGRect imageViewRect = CGRectMake(0, 0, 140, 210);
    UIView *roundRectMask = [[UIView alloc] initWithFrame:imageViewRect];
    [roundRectMask setClipsToBounds:YES];
    [[roundRectMask layer] setCornerRadius:7];
    
    UIImageView *wantToDoImageView = 
        [[UIImageView alloc] initWithFrame:imageViewRect];
    UIImage *photoImage = [[BuiltinImages instance] defaultWantToDoViewBackground];
    [wantToDoImageView setImage:photoImage];
    
    [self setWantToDoImageView:wantToDoImageView];
    [wantToDoImageView release];
    
    [roundRectMask setCenter:[self center]];
    [roundRectMask addSubview:[self wantToDoImageView]];
    
    UIImageView *cameraIconImageView =
        [[UIImageView alloc] initWithFrame:CGRectMake(105, 177, 31, 31)];
    [cameraIconImageView setImage:[[BuiltinImages instance] cameraIcon]];
    [self setCameraIconImageView:cameraIconImageView];
    [cameraIconImageView release];
    [roundRectMask addSubview:[self cameraIconImageView]];

    UIButton *imageSelectButton = [[UIButton alloc] initWithFrame:imageViewRect];
    [imageSelectButton setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0]];
    [imageSelectButton addTarget:self
                          action:@selector(touchDown)
                forControlEvents:UIControlEventTouchDown];
    [imageSelectButton addTarget:self
                          action:@selector(touchUp)
                forControlEvents:UIControlEventTouchUpOutside];
    [imageSelectButton addTarget:self
                           action:@selector(touchUp)
                forControlEvents:UIControlEventTouchDragOutside];
    [imageSelectButton addTarget:self
                          action:@selector(touchUpInside)
                forControlEvents:UIControlEventTouchUpInside];
    [self setImageSelectButton:imageSelectButton];
    [imageSelectButton release];
    [roundRectMask addSubview:[self imageSelectButton]];

    [self addSubview:roundRectMask];
    [roundRectMask release];
}

- (void)touchDown
{
    [[self imageSelectButton] setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.2f]];
}

- (void)touchUp
{
    [[self imageSelectButton] setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.0f]];
}

- (void)touchUpInside
{
    [self touchUp];
    if ([[self delegate] respondsToSelector:@selector(didSelectEditImageRow)])
    {
        [[self delegate] performSelector:@selector(didSelectEditImageRow)];
    }
}

- (void)setContents:(id)contents
{
    if (![contents isKindOfClass:[WantToDoAlarm class]])
        return;
    
    WantToDoAlarm *wantToDo = (WantToDoAlarm *)contents;
    UIImage *wantToDoImage = nil;
    if ([NSString isNilOrEmpty:[wantToDo imagePath]] || 
        ![[NSFileManager defaultManager] fileExistsAtPath:[wantToDo imagePath]])
    {
        wantToDoImage =
            [[[BuiltinImages instance] defaultWantToDoViewBackground] retain];
    }
    else
    {
        wantToDoImage = [[UIImage alloc] initWithContentsOfFile:[wantToDo imagePath]];
    }

    [[self wantToDoImageView] setImage:wantToDoImage];
    [wantToDoImage release];
}

- (CGFloat)heightForCell
{
    return [[self wantToDoImageView] frame].size.height;
}

@end
