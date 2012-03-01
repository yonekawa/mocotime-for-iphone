//
//  EditWantToDoViewController.m
//  MoCoTime
//
//  Created by Kenichi Yonekawa on 10/05/16.
//  Copyright 2010 Cybozu, Inc. All rights reserved.
//

#import "EditWantToDoViewController.h"
#import "TextEditViewController.h"
#import "RequiredTimeEditViewController.h"
#import "Transaction.h"
#import "ReadOnlyTransaction.h"
#import "WantToDoDao.h"
#import "DBFileManager.h"
#import "WantToDoAlarm.h"
#import "EditTableViewCell.h"
#import "EditWantToDoImageCell.h"
#import "NSString+Utilities.h"
#import "NSDate+Utilities.h"
#import "NSDate+RequiredTime.h"
#import "NSFileManager+SaveImage.h"

typedef enum
{
    ActionSheetTypeRemove = 0,
    ActionSheetTypeSelectPhoto = 1
} ActionSheetType;

typedef enum
{
    SelectPhotoTypeCamera = 0,
    SelectPhotoTypePhotoLibrary = 1,
} SelectPhotoType;

@interface EditWantToDoViewController()
- (void)buildNavigationBar;
- (void)buildToolBar;
- (void)refreshEditTable;
- (BOOL)validate;
@end

@implementation EditWantToDoViewController
@synthesize isSavedToTemporary = isSavedToTemporary_;
@synthesize isEditing = isEditing_;
@synthesize wantToDo = wantToDo_;
@synthesize sections = sections_;
@synthesize toolbar = toolbar_;
- (void)dealloc
{
    [wantToDo_ release];
    [sections_ release];
    [toolbar_ release];
    [super dealloc];
}

- (id)initWithWantToDo:(WantToDoAlarm *)wantToDo style:(UITableViewStyle)style
{
    if (self = [super initWithStyle:style])
    {
        [self setWantToDo:wantToDo];

        NSMutableArray *sections = [[NSMutableArray alloc] init];
        [self setSections:sections];
        [sections release];
    }
    return self;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    if (self = [super initWithStyle:style])
    {
        ReadOnlyTransaction *tx = [[ReadOnlyTransaction alloc]
                                   initWithDatabaseFilePath:[DBFileManager wantToDoDB]];
        WantToDoDao *dao = [[WantToDoDao alloc] initWithDBConnection:[tx connection]];
        long long primaryKey = [dao nextPrimaryKey];
        [dao release];
        [tx release];
        
        WantToDoAlarm *wantToDo = [[WantToDoAlarm alloc] init];
        [wantToDo setSurrogateKey:primaryKey];
        [self setWantToDo:wantToDo];
        [wantToDo release];        
        
        NSMutableArray *sections = [[NSMutableArray alloc] init];
        [self setSections:sections];
        [sections release];
    }
    return self;
}

- (void)loadView
{
    [super loadView];
    [self buildNavigationBar];
    if ([self isEditing])
    {
        [self buildToolBar];
    }
}

- (void)buildNavigationBar
{
    if (![self isEditing])
    {
        [self setTitle:NSLocalizedString(@"Add", @"Add")];
        [[[self navigationController] navigationBar] setTintColor:[UIColor colorWithRed:13.0f / 0xff green:59.0f / 0xff blue:89.0f / 0xff alpha:1.0]];
        UIBarButtonItem *backButtonItem =
            [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Cancel", @"Cancel button")
                                             style:UIBarButtonItemStylePlain
                                            target:self
                                            action:@selector(cancel)];
        self.navigationItem.leftBarButtonItem = backButtonItem;
        [backButtonItem release];
    }
    else
    {
        [self setTitle:NSLocalizedString(@"Edit", @"Edit")];
    }
    
    UIBarButtonItem *doneButtonItem =
        [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Done", @"Title for done button")
                                         style:UIBarButtonItemStyleDone
                                        target:self
                                        action:@selector(done)];
    self.navigationItem.rightBarButtonItem = doneButtonItem;
    [doneButtonItem release];
}

- (void)buildToolBar
{
    UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0.0f, 433.0f, 320.0f, 47.0f)];
    [toolbar setTintColor:[UIColor colorWithRed:13.0f / 0xff green:59.0f / 0xff blue:89.0f / 0xff alpha:1.0]];
    UIBarButtonItem *removeWantToDoButton =
        [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash
                                                      target:self
                                                      action:@selector(removeWantToDo)];
    UIBarButtonItem *flexibleSpace = 
        [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                  target:nil
                                                  action:nil];
    NSArray *items = [[NSArray alloc] initWithObjects:flexibleSpace,
                                                      removeWantToDoButton,
                                                      flexibleSpace,
                                                      nil];
    [removeWantToDoButton release];
    [flexibleSpace release];
    
    [toolbar setItems:items animated:NO];
    [items release];
    
    [self setToolbar:toolbar];
    [toolbar release];
}

- (void)viewDidLoad
{
     [super viewDidLoad];
    
    [[self sections] removeAllObjects];
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] ||
        [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
    {
        NSMutableArray *section = [[NSMutableArray alloc] init];
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"EditWantToDoImageCell"
                                                         owner:self
                                                       options:nil];
            EditWantToDoImageCell *imageCell = [nib objectAtIndex:0];
            // Remove border of cell.
            UIView *backView = [[UIView alloc] initWithFrame:CGRectZero];
            backView.backgroundColor = [UIColor clearColor];
            [imageCell setBackgroundView:backView];
            [backView release];

            [imageCell setDelegate:self];
            [section addObject:imageCell];
        }

        [[self sections] addObject:section];
        [section release];
    }
    
    {
        NSMutableArray *section = [[NSMutableArray alloc] init];
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"EditWantToDoTitleCell"
                                                         owner:self
                                                       options:nil];
            UITableViewCell *titleCell = [nib objectAtIndex:0];
            [section addObject:titleCell];
        }
        
        [[self sections] addObject:section];
        [section release];
    }
    
    {
        NSMutableArray *section = [[NSMutableArray alloc] init];
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"EditWantToDoRequiredTimeCell"
                                                         owner:self
                                                       options:nil];
            UITableViewCell *requiredTimeCell = [nib objectAtIndex:0];
            [section addObject:requiredTimeCell];
        }
        
        [[self sections] addObject:section];
        [section release];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self refreshEditTable];
    if ([self isEditing])
    {
        [[[self navigationController] view] addSubview:[self toolbar]];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if ([self isEditing])
    {
        [[self toolbar] removeFromSuperview];
    }
}

- (void)refreshEditTable
{
    if (![self validate])
    {
        [[[self navigationItem] rightBarButtonItem] setEnabled:NO];
    }
    else
    {
        [[[self navigationItem] rightBarButtonItem] setEnabled:YES];
    }
    
    for (NSArray *section in [self sections])
    {
        for (UITableViewCell *cell in section)
        {
            if ([cell respondsToSelector:@selector(setContents:)])
                [cell setContents:[self wantToDo]];
        }
    }
    
    [[self tableView] reloadData];
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
    id cellInSection =
        [[[self sections] objectAtIndex:[indexPath section]] objectAtIndex:[indexPath row]];
    if (cellInSection != nil && [cellInSection respondsToSelector:@selector(heightForCell)])
    {
        return [cellInSection heightForCell];
    }
    return 60.0f;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [[self sections] count];
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[[self sections] objectAtIndex:section] count];
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cellInSection =
        [[[self sections] objectAtIndex:[indexPath section]] objectAtIndex:[indexPath row]];
    if (cellInSection != nil)
        return cellInSection;
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                       reuseIdentifier:CellIdentifier] autorelease];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // for "Want to do" cell.
    if ([indexPath section] == 1 && [indexPath row] == 0)
    {
        TextEditViewController *textEditViewController = [[TextEditViewController alloc] init];
        [textEditViewController setWantToDo:[self wantToDo]];
        [[self navigationController] pushViewController:textEditViewController animated:YES];
        [textEditViewController release];
    }
    // for "Required Time" cell.
    else if ([indexPath section] == 2 && [indexPath row] == 0)
    {
        RequiredTimeEditViewController *requredTimeEditViewController =
            [[RequiredTimeEditViewController alloc] init];
        [requredTimeEditViewController setWantToDo:[self wantToDo]];
        [[self navigationController] pushViewController:requredTimeEditViewController
                                               animated:YES];
        [requredTimeEditViewController release];
    }
}

- (void)didSelectEditImageRow
{
    NSString *cameraButtonTitle = 
        [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]
            ? NSLocalizedString(@"Camera", "Camera")
            : nil;
    NSString *photoAlbumButtonTitle = 
        [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]
            ? NSLocalizedString(@"Photo Albums", "Photo Albums")
            : nil;
    
    UIActionSheet *actionSheet = nil;
    if (cameraButtonTitle != nil)
    {
         actionSheet = [[UIActionSheet alloc] initWithTitle:NSLocalizedString(@"Select photo", "Select photo for want to do")
                                                   delegate:self
                                          cancelButtonTitle:NSLocalizedString(@"Cancel", "Cancel")
                                     destructiveButtonTitle:nil
                                          otherButtonTitles:cameraButtonTitle,
                                                            photoAlbumButtonTitle,
                                                            nil];
    }
    else
    {
        actionSheet = [[UIActionSheet alloc] initWithTitle:NSLocalizedString(@"Select photo", "Select photo for want to do")
                                                  delegate:self
                                         cancelButtonTitle:NSLocalizedString(@"Cancel", "Cancel")
                                        destructiveButtonTitle:nil
                                             otherButtonTitles:photoAlbumButtonTitle,
                                                               nil];
    }

    [actionSheet setTag:ActionSheetTypeSelectPhoto];
    [actionSheet showInView:[[self navigationController] view]];
    [actionSheet release];
}

- (BOOL)validate
{
    if ([NSString isNilOrEmpty:[[self wantToDo] title]])
        return NO;    
    if ([[self wantToDo] requiredTimeInterval] <= 0)
        return NO;
    return YES;
}

- (void)removeWantToDo
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:[[self wantToDo] title]
                                                             delegate:self
                                                    cancelButtonTitle:NSLocalizedString(@"Cancel", @"Cancel")
                                               destructiveButtonTitle:NSLocalizedString(@"Remove", @"Remove Want To Do")
                                                    otherButtonTitles:nil];
    [actionSheet setTag:ActionSheetTypeRemove];
    [actionSheet showInView:[[self navigationController] view]];
    [actionSheet release];
}

- (void)done
{
    if ([self isSavedToTemporary])
    {
        NSError *error = nil;
        NSString *fileName = [[NSString alloc] initWithFormat:@"%d.png",
                                                              [[self wantToDo] surrogateKey]];
        
        NSString *fromPath = [[self wantToDo] imagePath];
        NSString *toPath = [NSFileManager pathOfImages:fileName error:&error];
        [[NSFileManager defaultManager] copyItemAtPath:fromPath
                                                toPath:toPath
                                                 error:&error];
        [fileName release];
        
        [[self wantToDo] setImagePath:toPath];
    }
    
    Transaction *tx = [[Transaction alloc]
                       initWithDatabaseFilePath:[DBFileManager wantToDoDB]];
    WantToDoDao *dao = [[WantToDoDao alloc] initWithDBConnection:[tx connection]];
    if ([self isEditing])
    {
        [dao modifyWantToDo:[self wantToDo]];
    }
    else
    {
        [dao addWantToDo:[self wantToDo]];
    }
    [tx commit];    
    [dao release];
    [tx release];
    
    if ([self isEditing])
    {
        [[self navigationController] popViewControllerAnimated:YES];
    }
    else
    {
        [self dismissModalViewControllerAnimated:YES];
    }
}

- (void)cancel
{
    [self dismissModalViewControllerAnimated:YES];
}

#pragma mark image picker methods

- (void)imagePickerController:(UIImagePickerController*)picker
        didFinishPickingImage:(UIImage*)image
                  editingInfo:(NSDictionary*)editingInfo
{
    [self dismissModalViewControllerAnimated:YES];
    
    CGSize newSize = { 320, 480 };
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    NSError *error = nil;
    NSString *fileName = [[NSString alloc] initWithFormat:@"%d.png",
                                                          [[self wantToDo] surrogateKey]];
    [[self wantToDo] setImagePath:[NSFileManager saveTemporaryImage:newImage
                                                           fileName:fileName
                                                              error:&error]];
    [fileName release];
    [self setIsSavedToTemporary:YES];
    [self refreshEditTable];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController*)picker
{
    [self dismissModalViewControllerAnimated:YES];
}

#pragma mark actionsheet

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.cancelButtonIndex == buttonIndex)
        return;

    if ([actionSheet tag] != ActionSheetTypeRemove)
    {
        if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
        {
            buttonIndex += 1;
        }
        
        UIImagePickerController* imagePicker = [[UIImagePickerController alloc] init];
        [imagePicker setDelegate:self];
        switch (buttonIndex)
        {
            case SelectPhotoTypeCamera:
                [imagePicker setSourceType:UIImagePickerControllerSourceTypeCamera];
                break;
            case SelectPhotoTypePhotoLibrary:
                [imagePicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
                break;
        }
        if ([UIImagePickerController isSourceTypeAvailable:[imagePicker sourceType]])
        {
            [self presentModalViewController:imagePicker animated:YES];
        }
        [imagePicker release];
    }
    else
    {
        if ([self isEditing])
        {
            Transaction *tx = [[Transaction alloc]
                               initWithDatabaseFilePath:[DBFileManager wantToDoDB]];
            WantToDoDao *dao = [[WantToDoDao alloc] initWithDBConnection:[tx connection]];
            [dao removeWantToDoByKey:[[self wantToDo] surrogateKey]];
            [tx commit];    
            [dao release];
            [tx release];
            
            [[self navigationController] popViewControllerAnimated:YES];
        }
    }
}

@end
