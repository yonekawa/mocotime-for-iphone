//
//  SetAlarmViewController.m
//  MoCoTime
//
//  Created by Kenichi Yonekawa on 10/05/04.
//  Copyright 2010 Cybozu, Inc. All rights reserved.
//

#import "SetAlarmViewController.h"
#import "SleepingViewController.h"
#import "BuiltinImages.h"
#import "ReadOnlyTransaction.h"
#import "WantToDoDao.h"
#import "DBFileManager.h"
#import "WantToDoAlarm.h"
#import "NSDate+Utilities.h"

@interface SetAlarmViewController()
- (void)buildViews;
@end

@implementation SetAlarmViewController
@synthesize toolbar = toolbar_;
@synthesize wantToDoBarButtonItem = wantToDoBarButtonItem_;
@synthesize alarmPicker = alarmPicker_;
@synthesize startButton = startButton_;
@synthesize backgroundImageView = backgroundImageView_;
@synthesize wantToDoNavigationController = wantToDoNavigationController_;

- (void)dealloc
{
    [alarmPicker_ release];
    [startButton_ release];
    [backgroundImageView_ release];
    [wantToDoNavigationController_ release];
    
    [super dealloc];
}

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
    NSArray *nibFiles = [[NSBundle mainBundle] loadNibNamed:@"SetAlarmView"
                                                      owner:self
                                                    options:nil];
    UIView *view = [nibFiles objectAtIndex:0];
    [self setView:view];
    
    [self buildViews];
}

- (void)buildViews
{
    [[self alarmPicker] setLocale:[NSLocale currentLocale]];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSTimeInterval alarmTimeInterval = [userDefaults doubleForKey:@"AlarmTime"];
    if (alarmTimeInterval > 0)
    {
        [[self alarmPicker] setDate:[NSDate dateWithTimeIntervalSinceReferenceDate:alarmTimeInterval]
                           animated:YES];
    }
    else
    {
        [[self alarmPicker] setDate:[NSDate date]];
    }
    
    [[self startButton] addTarget:self
                           action:@selector(presentSleepingView)
                 forControlEvents:UIControlEventTouchUpInside];

    [[self toolbar] setTintColor:[UIColor colorWithRed:13.0f / 0xff green:59.0f / 0xff blue:89.0f  / 0xff alpha:1.0]];
    
    [[self wantToDoBarButtonItem] setTitle:NSLocalizedString(@"Want to do", @"Want To Do")];
    [[self wantToDoBarButtonItem] setTarget:self];
    [[self wantToDoBarButtonItem] setAction:@selector(presentWantToDoListView)];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSTimeInterval alarmTimeInterval = [userDefaults doubleForKey:@"AlarmTime"];
    if (alarmTimeInterval > 0)
    {
        [[self alarmPicker] setDate:[NSDate dateWithTimeIntervalSinceReferenceDate:alarmTimeInterval]
                           animated:YES];
    }
    else
    {
        [[self alarmPicker] setDate:[NSDate date]];
    }
}

- (void)didReceiveMemoryWarning
{
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload
{
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}

- (void)presentWantToDoListView
{
    if ([self wantToDoNavigationController] == nil)
    {
        WantToDoListViewController *wantToDoListViewController =
            [[WantToDoListViewController alloc] init];
        UINavigationController *navigationController = 
            [[UINavigationController alloc] initWithRootViewController:wantToDoListViewController];
        [[navigationController navigationBar] setTintColor:[UIColor colorWithRed:13.0f / 0xff green:59.0f / 0xff blue:89.0f / 0xff alpha:1.0]];
        [wantToDoListViewController release];
        [self setWantToDoNavigationController:navigationController];
        [navigationController release];
    }
    
    [UIView beginAnimations:@"FlipPresentWantToDoListView" context:nil];
	[UIView setAnimationDuration:0.5];
	[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft
						   forView:[[self view] window]
							 cache:YES];
	[[[self view] window] addSubview:[[self wantToDoNavigationController] view]];
	[UIView commitAnimations];
}

- (void)presentSleepingView
{
    NSDate *alarmTime = [[self alarmPicker] date];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setDouble:[alarmTime timeIntervalSinceReferenceDate]
                     forKey:@"AlarmTime"];
    [userDefaults synchronize];
    
    ReadOnlyTransaction *tx = [[ReadOnlyTransaction alloc]
         initWithDatabaseFilePath:[DBFileManager wantToDoDB]];
    WantToDoDao *dao = [[WantToDoDao alloc] initWithDBConnection:[tx connection]];
    NSArray *arrayOfWantToDo = [dao arrayOfWantToDoOrganized];
    [dao release];
    [tx release];
    
    for (NSArray *wantToDo in arrayOfWantToDo)
    {
        for (WantToDoAlarm *item in wantToDo)
        {
            [item setTime:alarmTime];
        }
    }
    
    SleepingViewController *sleepingViewController =
        [[SleepingViewController alloc] initWithAlarmTime:alarmTime
                                                 wantToDo:arrayOfWantToDo];
    [self presentModalViewController:sleepingViewController animated:YES];
    [sleepingViewController release];
}

@end
