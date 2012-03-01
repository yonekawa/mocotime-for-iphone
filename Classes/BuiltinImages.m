//
//  BuiltinImages.m
//  MoCoTime
//
//  Created by Kenichi Yonekawa on 10/05/23.
//  Copyright 2010 Cybozu, Inc. All rights reserved.
//

#import "BuiltinImages.h"

@interface BuiltinImages()
- (void)loadBuiltinImages;
@end

@implementation BuiltinImages
@synthesize cameraIcon = cameraIcon_;
@synthesize setAlarmViewBackground = setAlarmViewBackground_;
@synthesize goodNightButton = goodNightButton_;
@synthesize goodNightButtonSelected = goodNightButtonSelected_;
@synthesize sleepingViewBackground = sleepingViewBackground_;
@synthesize wakeupViewBackground = wakeupViewBackground_;
@synthesize defaultWantToDoViewBackground = defaultWantToDoViewBackground_;

static BuiltinImages* instance_;

+ (id)instance
{
    @synchronized(self)
    {
        if (instance_ == nil)
        {
            instance_ = [[self alloc] init];
        }
    }
    return instance_;
}

+ (id)allocWithZone:(NSZone *)zone
{
	@synchronized(self)
    {
		if (instance_ == nil)
        {
			instance_ = [super allocWithZone:zone];
			return instance_;
		}
	}
	return nil;
}

- (id)copyWithZone:(NSZone*)zone
{
	return self;
}

- (id)retain
{
	return self;
}

- (unsigned)retainCount
{
	return UINT_MAX;
}

- (void)release
{
}

- (id)autorelease
{
	return self;
}

- (void)dealloc
{
    [cameraIcon_ release];
    [setAlarmViewBackground_ release];
    [goodNightButton_ release];
    [goodNightButtonSelected_ release];
    [sleepingViewBackground_ release];
    [wakeupViewBackground_ release];
    [defaultWantToDoViewBackground_ release];
    [super dealloc];
}

- (id)init
{
    self = [super init];
    if (self)
    {
        [self loadBuiltinImages];
    }
    return self;
}

- (void)loadBuiltinImages
{
    cameraIcon_ = 
        [[UIImage imageNamed:@"cameraIcon.png"] retain];    
    setAlarmViewBackground_ = 
        [[UIImage imageNamed:@"setAlarmViewBackground.png"] retain];
    sleepingViewBackground_ = 
        [[UIImage imageNamed:@"sleepingViewBackground.png"] retain];
    wakeupViewBackground_ = 
        [[UIImage imageNamed:@"wakeupViewBackground.png"] retain];
    goodNightButton_ =  
        [[UIImage imageNamed:@"goodNightButton.png"] retain];
    goodNightButtonSelected_ = 
        [[UIImage imageNamed:@"goodNightButton_selected.png"] retain];
    
    defaultWantToDoViewBackground_ =
        [[UIImage imageNamed:@"defaultWantToDoViewBackground.png"] retain];
    
    /*
    CGSize newSize = { 57, 57 };
    UIGraphicsBeginImageContext(newSize);
    [defaultWantToDoViewBackground_ drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *smallImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    defaultWantToDoViewBackgroundSmall_ = [smallImage retain];
    */
}

@end
