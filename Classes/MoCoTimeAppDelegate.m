//
//  MoCoTimeAppDelegate.m
//  MoCoTime
//
//  Created by Kenichi Yonekawa on 10/04/26.
//  Copyright Cybozu, Inc 2010. All rights reserved.
//

#import "MoCoTimeAppDelegate.h"

@implementation MoCoTimeAppDelegate
@synthesize window = window_;
@synthesize setAlarmViewController = setAlarmViewController_;

- (void)dealloc
{
    [window_ release];
    [setAlarmViewController_ release];
    [super dealloc];
}

- (void)applicationDidFinishLaunching:(UIApplication *)application
{
    // Override point for customization after application launch
    UIWindow *window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self setWindow:window];
    [window release];

    SetAlarmViewController *setAlarmViewController = [[SetAlarmViewController alloc] init];
    [self setSetAlarmViewController:setAlarmViewController];
    [setAlarmViewController release];

    [[self window] addSubview:[[self setAlarmViewController] view]];
    [[self window] makeKeyAndVisible];
}

@end
