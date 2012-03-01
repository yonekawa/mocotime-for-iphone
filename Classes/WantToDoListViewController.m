//
//  WantToDoListViewController.m
//  MoCoTime
//
//  Created by Kenichi Yonekawa on 10/05/04.
//  Copyright 2010 Cybozu, Inc. All rights reserved.
//

#import "WantToDoListViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "EditWantToDoViewController.h"
#import "ReadOnlyTransaction.h"
#import "DBFileManager.h"
#import "WantToDoDao.h"
#import "WantToDoAlarm.h"
#import "WantToDoListCell.h"

@interface WantToDoListViewController()
- (void)buildNavigationBar;
- (void)buildTableView;
@end

@implementation WantToDoListViewController
@synthesize tableView = tableView_;
@synthesize arrayOfWantToDo = arrayOfWantToDo_;

- (void)dealloc
{
    [arrayOfWantToDo_ release];
    [tableView_ release];
    [super dealloc];
}

- (void)loadView
{
    [super loadView];
    [[self view] setBackgroundColor:[UIColor blackColor]];

    [self buildNavigationBar];
    [self buildTableView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    ReadOnlyTransaction *tx = [[ReadOnlyTransaction alloc]
                               initWithDatabaseFilePath:[DBFileManager wantToDoDB]];
    WantToDoDao *dao = [[WantToDoDao alloc] initWithDBConnection:[tx connection]];
    [self setArrayOfWantToDo:[dao arrayOfWantToDo]];
    [dao release];
    [tx release];

    [[self tableView] reloadData];
}

- (void)buildNavigationBar
{
    [[self navigationItem] setTitle:NSLocalizedString(@"Want to do", @"Want To Do")];    
    UIBarButtonItem *backButtonItem =
        [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Back", @"Back button")
                                         style:UIBarButtonItemStylePlain
                                        target:self
                                        action:@selector(backToParentView)];
    self.navigationItem.leftBarButtonItem = backButtonItem;
    [backButtonItem release];
    
    UIBarButtonItem *addingButtonItem =
        [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                      target:self
                                                      action:@selector(presentAddWantToDoView)];
    self.navigationItem.rightBarButtonItem = addingButtonItem;
    [addingButtonItem release];
}

- (void)buildTableView
{
    CGRect tableFrame = [[UIScreen mainScreen] bounds];
    tableFrame.size.height -= [[[self navigationController] navigationBar] frame].size.height;
    tableFrame.size.height -= 20.0f; // Status bar.
    UITableView *tableView =
        [[UITableView alloc] initWithFrame:tableFrame style:UITableViewStylePlain];
    [tableView setDelegate:self];
    [tableView setDataSource:self];
    [tableView setContentMode:UIViewContentModeScaleToFill];
    [tableView setAutoresizesSubviews:YES];
    [tableView setClipsToBounds:YES];
    [tableView setScrollEnabled:YES];
    [tableView setBounces:YES];
    [tableView setCanCancelContentTouches:YES];
    
    [self setTableView:tableView];
    [tableView release];
    [[self view] addSubview:[self tableView]];
}

- (void)presentAddWantToDoView
{
    EditWantToDoViewController *editWantToDoViewController =
        [[EditWantToDoViewController alloc] initWithStyle:UITableViewStyleGrouped];
    UINavigationController *navigationController =
        [[UINavigationController alloc] initWithRootViewController:editWantToDoViewController];
    [[navigationController navigationBar] setTintColor:[UIColor colorWithRed:13.0f / 0xff green:59.0f / 0xff blue:89.0f / 0xff alpha:1.0]];
    [editWantToDoViewController release];
    
    [editWantToDoViewController setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
    [[self navigationController] presentModalViewController:navigationController
                                                   animated:YES];
    [navigationController release];
}

- (void)backToParentView
{
    [UIView beginAnimations:@"FlipBackToParentView" context:nil];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight
                           forView:[[self view] window]
                             cache:YES];
    [[[self navigationController] view] removeFromSuperview];
    [UIView commitAnimations];
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

#pragma mark Table view methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 77.0f;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self arrayOfWantToDo] count];
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView 
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *reuseIdentifier = [[NSString alloc] initWithFormat:@"WantToDoListCell%d",
                                                                 indexPath.row];
    WantToDoListCell *cell = 
        (WantToDoListCell *)[tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    [reuseIdentifier release];
    
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"WantToDoListCell"
                                                     owner:self
                                                   options:nil];
        cell = [nib objectAtIndex:0];
    }
    WantToDoAlarm *wantToDo = [[self arrayOfWantToDo] objectAtIndex:[indexPath row]];
    [cell setWantToDo:wantToDo];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    EditWantToDoViewController *editWantToDoViewController =
        [[EditWantToDoViewController alloc] initWithWantToDo:[[self arrayOfWantToDo] objectAtIndex:[indexPath row]]
                                                       style:UITableViewStyleGrouped];
    [editWantToDoViewController setIsEditing:YES];
	[[self navigationController] pushViewController:editWantToDoViewController animated:YES];
	[editWantToDoViewController release];
}

@end
