//
//  SetAlarmViewController.h
//  MoCoTime
//
//  Created by Kenichi Yonekawa on 10/05/04.
//  Copyright 2010 Cybozu, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WantToDoListViewController.h"

@class WantToDoAlarm;
@interface SetAlarmViewController : UIViewController
{
  @private
    UIToolbar *toolbar_;
    UIBarButtonItem *wantToDoBarButtonItem_;
    UIDatePicker *alarmPicker_;
    UIButton *startButton_;
    UIImageView *backgroundImageView_;
    
    UINavigationController *wantToDoNavigationController_;
}
@property(nonatomic, retain) IBOutlet UIToolbar *toolbar;
@property(nonatomic, retain) IBOutlet UIBarButtonItem *wantToDoBarButtonItem;
@property(nonatomic, retain) IBOutlet UIDatePicker *alarmPicker;
@property(nonatomic, retain) IBOutlet UIButton *startButton;
@property(nonatomic, retain) IBOutlet UIImageView *backgroundImageView;

@property(nonatomic, retain) UINavigationController *wantToDoNavigationController;
@end
