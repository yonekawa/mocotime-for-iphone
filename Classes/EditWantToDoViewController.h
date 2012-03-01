//
//  EditWantToDoViewController.h
//  MoCoTime
//
//  Created by Kenichi Yonekawa on 10/05/16.
//  Copyright 2010 Cybozu, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WantToDoAlarm;
@interface EditWantToDoViewController : UITableViewController
    <UIActionSheetDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>
{
  @private
    BOOL isEditing_;
    WantToDoAlarm *wantToDo_;
    BOOL isSavedToTemporary_;
    NSMutableArray *sections_;

    UIToolbar *toolbar_;
}
@property(nonatomic, assign) BOOL            isEditing;
@property(nonatomic, assign) BOOL            isSavedToTemporary;
@property(nonatomic, retain) WantToDoAlarm  *wantToDo;
@property(nonatomic, retain) NSMutableArray *sections;
@property(nonatomic, retain) UIToolbar      *toolbar;
- (id)initWithWantToDo:(WantToDoAlarm *)wantToDo style:(UITableViewStyle)style;
- (void)done;
- (void)cancel;
- (void)didSelectEditImageRow;
- (void)removeWantToDo;
@end
