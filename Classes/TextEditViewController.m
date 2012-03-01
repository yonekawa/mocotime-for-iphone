//
//  TextEditViewController.m
//  MoCoTime
//
//  Created by Kenichi Yonekawa on 10/05/16.
//  Copyright 2010 Cybozu, Inc. All rights reserved.
//

#import "TextEditViewController.h"

@implementation TextEditViewController
@synthesize wantToDo = wantToDo_;
@synthesize textView = textView_;

- (void)dealloc
{
    [wantToDo_ release];
    [textView_ release];
    [super dealloc];
}

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
    [super loadView];
    
    [[self view] setBackgroundColor:[UIColor whiteColor]];
    if ([self textView] == nil)
    {
        UITextView *textView =
            [[UITextView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        [textView setFont:[UIFont systemFontOfSize:20.0f]];
        [textView setScrollEnabled:YES];
        [textView setAlwaysBounceVertical:YES];
        [textView setText:[[self wantToDo] title]];
        [self setTextView:textView];
        [textView release];
    }
    [[self view] addSubview:[self textView]];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if ([self.textView resignFirstResponder])
    {
        [self.textView becomeFirstResponder];
        [[self textView] setSelectedRange:NSMakeRange(0, 0)];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[self wantToDo] setTitle:[[self textView] text]];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
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

- (void)keyboardWasShown:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    NSValue *aValue = nil;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 4.0)
    {
        aValue = [info objectForKey:UIKeyboardBoundsUserInfoKey];
    }
    else
    {
        aValue = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
    }
    CGSize keyboardSize = [aValue CGRectValue].size;
    
    CGRect textViewFrame = CGRectZero;
    textViewFrame.size.width = self.view.frame.size.width;
    textViewFrame.size.height = self.view.frame.size.height - keyboardSize.height;
    [[self textView] setFrame:textViewFrame];
}

@end
