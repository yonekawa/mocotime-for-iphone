//
//  RequiredTimeEditViewController.m
//  MoCoTime
//
//  Created by Kenichi Yonekawa on 10/05/16.
//  Copyright 2010 Cybozu, Inc. All rights reserved.
//

#import "RequiredTimeEditViewController.h"
#import "WantToDoAlarm.h"
#import "NSDate+RequiredTime.h"

@implementation RequiredTimeEditViewController
@synthesize wantToDo = wantToDo_;
@synthesize requiredTimePicker = requiredTimePicker_;

- (void)dealloc
{
    [wantToDo_ release];
    [requiredTimePicker_ release];
    [super dealloc];
}

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
    [super loadView];
    [[self view] setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
    
    if ([self requiredTimePicker] == nil)
    {
        UIDatePicker *requiredTimePicker =
            [[UIDatePicker alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        [requiredTimePicker setDatePickerMode:UIDatePickerModeCountDownTimer];
        [requiredTimePicker setMinuteInterval:5];
        [requiredTimePicker setLocale:[NSLocale currentLocale]];
        [requiredTimePicker setDate:[NSDate dateFromRequiredTimeInterval:[[self wantToDo] requiredTimeInterval]]];
        [self setRequiredTimePicker:requiredTimePicker];
        [requiredTimePicker release];
    }
    [[self view] addSubview:[self requiredTimePicker]];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
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

- (void)viewWillDisappear:(BOOL)animated
{
    [[self wantToDo] setRequiredTimeInterval:[[[self requiredTimePicker] date] requiredTimeInterval]];
}

@end
