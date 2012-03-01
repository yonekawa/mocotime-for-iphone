//
//  SleepingViewController.m
//  MoCoTime
//
//  Created by Kenichi Yonekawa on 10/05/05.
//  Copyright 2010 Cybozu, Inc. All rights reserved.
//

#import "SleepingViewController.h"
#import "BuiltinImages.h"
#import "WantToDoAlarm.h"
#import "NSString+Utilities.h"
#import "NSDate+Utilities.h"

@interface SleepingViewController()
- (void)toSleepingView;
- (void)toWantToDoAlarmView;
- (void)toWakeupAlarmView;
- (void)setWakeupView;
- (void)setDefaultWantToDoView;
- (void)sleepMore;
- (void)clockTickTack;
- (void)setToIdleTimerEnable:(NSNotification *)notification;
@end

@implementation SleepingViewController
@synthesize wantToDoBackgroundImageView = wantToDoBackgroundImageView_;
@synthesize clockBackgroundWakeupImageView = clockBackgroundWakeupImageView_;
@synthesize clockBackgroundImageView = clockBackgroundImageView_;
@synthesize backgroundImageView = backgroundImageView_;
@synthesize clockLabel = clockLabel_;
@synthesize wakeupTitleLabel = wakeupTitleLabel_;
@synthesize wakeupTimeLabel = wakeupTimeLabel_;
@synthesize wantToDoTitleLabel = wantToDoTitleLabel_;
@synthesize sleepMoreButton = sleepMoreButton_;
@synthesize alarmController = alarmController_;

- (void)dealloc
{
    [UIApplication sharedApplication].idleTimerDisabled = NO;
    
    [clockLabel_ release];
    [wakeupTitleLabel_ release];
    [wakeupTimeLabel_ release];
    [wantToDoTitleLabel_ release];
    [sleepMoreButton_ release];
    [backgroundImageView_ release];
    [clockBackgroundImageView_ release];
    [clockBackgroundWakeupImageView_ release];
    [wantToDoBackgroundImageView_ release];
    [alarmController_ release];
    
    [super dealloc];
}

- (id)initWithAlarmTime:(NSDate *)alarmTime wantToDo:(NSArray *)wantToDo
{
    if (self = [self init])
    {
        AlarmController *alarmController = [[AlarmController alloc] init];
        [alarmController setDelegate:self];
        [self setAlarmController:alarmController];
        [alarmController release];
        
        [[self alarmController] startAlarmLoop:alarmTime wantToDo:wantToDo];

        // When application will terminate, set idle timer to be enabled. 
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(setToIdleTimerEnable:)
                                                     name:UIApplicationWillTerminateNotification
                                                   object:[UIApplication sharedApplication]];
    }
    return self;
}

- (void)setToIdleTimerEnable:(NSNotification *)notification
{
    [UIApplication sharedApplication].statusBarHidden = NO;
    [UIApplication sharedApplication].idleTimerDisabled = NO;
}

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
    NSArray *nibFiles = [[NSBundle mainBundle] loadNibNamed:@"SleepingView"
                                                      owner:self
                                                    options:nil];
    UIView *view = [nibFiles objectAtIndex:0];
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 4.0)
    {
        CGRect viewFrame = [view frame];
        viewFrame.origin.y -= 20;
        [view setFrame:viewFrame];
    }
    [self setView:view];
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 4.0)
    {
        CGRect frame = [[self backgroundImageView] frame];
        frame.origin.y -= 20;
        [[self backgroundImageView] setFrame:frame];
    }
    
    NSDate *now = [NSDate date];
    NSString *clock = [[NSString alloc] initWithFormat:@"%02d:%02d",
                                                       [now hour],
                                                       [now minute]];
    [[self clockLabel] setText:clock];
    [clock release];

    [[self wakeupTitleLabel] setText:NSLocalizedString(@"Alarm", @"title for alarm")];

    NSString *alarmTime = [[NSString alloc] initWithFormat:@"%02d:%02d",
                                                       [[[[self alarmController] alarmForWakeup] time] hour],
                                                       [[[[self alarmController] alarmForWakeup] time] minute]];
    [[self wakeupTimeLabel] setText:alarmTime];
    [alarmTime release];
    
    NSString *buttonTitle = NSLocalizedString(@"Sleep Again", @"Sleep again");
    [[self sleepMoreButton] setTitle:buttonTitle forState:UIControlStateNormal];
    [[self sleepMoreButton] setTitle:buttonTitle forState:UIControlStateHighlighted];
    [[self sleepMoreButton] addTarget:self
                               action:@selector(sleepMore)
                     forControlEvents:UIControlEventTouchUpInside];
    
    [self toSleepingView];
}

- (void)toSleepingView
{
    [[self wakeupTitleLabel] setHidden:NO];
    [[self wakeupTimeLabel] setHidden:NO];
    [[self sleepMoreButton] setHidden:YES];
    [[self wantToDoTitleLabel] setHidden:YES];
    [[self wantToDoBackgroundImageView] setHidden:YES];
    [[self clockBackgroundImageView] setHidden:YES];
    [[self clockBackgroundWakeupImageView] setHidden:YES];
    
    CGRect frame = [[self clockLabel] frame];
    frame.origin.x = 39.0f;
    frame.origin.y = 169.0f;
    [[self clockLabel] setFrame:frame];
    [[self clockLabel] setTextColor:[UIColor whiteColor]];
    
    [[self backgroundImageView] setImage:[[BuiltinImages instance] sleepingViewBackground]];
    [[self view] setNeedsDisplay];
}

- (void)toWantToDoAlarmView
{
    [[self wakeupTitleLabel] setHidden:YES];
    [[self wakeupTimeLabel] setHidden:YES];
    [[self sleepMoreButton] setHidden:NO];
    [[self wantToDoTitleLabel] setHidden:NO];
    [[self wantToDoBackgroundImageView] setHidden:NO];
    [[self clockBackgroundImageView] setHidden:NO];
    [[self clockBackgroundWakeupImageView] setHidden:YES];
    
    CGRect frame = [[self clockLabel] frame];
    frame.origin.x = 39.0f;
    frame.origin.y = 20.0f;
    [[self clockLabel] setFrame:frame];
    [[self clockLabel] setTextColor:[UIColor whiteColor]];
    
    [[self clockBackgroundImageView] setCenter:[[self clockLabel] center]];
    [[self wantToDoBackgroundImageView] setCenter:[[self wantToDoTitleLabel] center]];
    
    [[self view] setNeedsDisplay];
}

- (void)toWakeupAlarmView
{
    [[self wakeupTitleLabel] setHidden:YES];
    [[self wakeupTimeLabel] setHidden:YES];
    [[self sleepMoreButton] setHidden:YES];
    [[self wantToDoTitleLabel] setHidden:YES];
    [[self wantToDoBackgroundImageView] setHidden:YES];
    [[self clockBackgroundImageView] setHidden:YES];
    [[self clockBackgroundWakeupImageView] setHidden:NO];
    
    CGRect frame = [[self clockLabel] frame];
    frame.origin.x = 39.0f;
    frame.origin.y = 20.0f;
    [[self clockLabel] setFrame:frame];
    [[self clockLabel] setFont:[UIFont boldSystemFontOfSize:92.0f]];
    [[self clockLabel] setTextColor:[UIColor blackColor]];
    
    [self setWakeupView];
    [[self view] setNeedsDisplay];
}

- (void)setWakeupView
{
    [[self backgroundImageView] setImage:[[BuiltinImages instance] wakeupViewBackground]];
}

- (void)setDefaultWantToDoView
{
    [[self backgroundImageView] setImage:[[BuiltinImages instance] defaultWantToDoViewBackground]];
}

- (void)sleepMore
{
    [[self alarmController] stopAlarm];
    [self toSleepingView];
}

- (void)setAlarmView
{
    [self toWakeupAlarmView];
}

- (void)setAlarmViewWithWantToDo:(WantToDoAlarm *)wantToDo;
{
    [[self wantToDoTitleLabel] setText:[wantToDo title]];
    if ([NSString isNilOrEmpty:[wantToDo imagePath]])
    {        
        [self setDefaultWantToDoView];
        [self toWantToDoAlarmView];
        return;
    }
    if (![[NSFileManager defaultManager] fileExistsAtPath:[wantToDo imagePath]])
    {
        [self setDefaultWantToDoView];
        [self toWantToDoAlarmView];
        return;
    }

    UIImage *backgroundImage = [[UIImage alloc] initWithContentsOfFile:[wantToDo imagePath]];
    [[self backgroundImageView] setImage:backgroundImage];
    [backgroundImage release];

    [self toWantToDoAlarmView];
}

- (void)clockTickTack
{
    NSDate *now = [NSDate date];
    NSString *clock = [[NSString alloc] initWithFormat:@"%02d:%02d",
                                                       [now hour],
                                                       [now minute]];
    [[self clockLabel] setText:clock];
    [clock release];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [UIApplication sharedApplication].statusBarHidden = YES;
    [UIApplication sharedApplication].idleTimerDisabled = YES;
    
    NSTimer *alarmTimer = [NSTimer timerWithTimeInterval:1
                                                  target:self
                                                selector:@selector(clockTickTack)
                                                userInfo:nil
                                                 repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:alarmTimer forMode:NSDefaultRunLoopMode];
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

@end
