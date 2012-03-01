//
//  SleepingViewController.h
//  MoCoTime
//
//  Created by Kenichi Yonekawa on 10/05/05.
//  Copyright 2010 Cybozu, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AlarmController.h"

@interface SleepingViewController : UIViewController
{
  @private
    AlarmController *alarmController_;
    UILabel *clockLabel_;
    UILabel *wakeupTitleLabel_;
    UILabel *wakeupTimeLabel_;
    UILabel *wantToDoTitleLabel_;
    UIButton *sleepMoreButton_;
    UIImageView *backgroundImageView_;
    UIImageView *clockBackgroundImageView_;
    UIImageView *clockBackgroundWakeupImageView_;
    UIImageView *wantToDoBackgroundImageView_;
}
@property(nonatomic, retain) AlarmController *alarmController;
@property(nonatomic, retain) IBOutlet UILabel *clockLabel;
@property(nonatomic, retain) IBOutlet UILabel *wakeupTitleLabel;
@property(nonatomic, retain) IBOutlet UILabel *wakeupTimeLabel;
@property(nonatomic, retain) IBOutlet UILabel *wantToDoTitleLabel;
@property(nonatomic, retain) IBOutlet UIButton *sleepMoreButton;
@property(nonatomic, retain) IBOutlet UIImageView *backgroundImageView;
@property(nonatomic, retain) IBOutlet UIImageView *clockBackgroundImageView;
@property(nonatomic, retain) IBOutlet UIImageView *clockBackgroundWakeupImageView;
@property(nonatomic, retain) IBOutlet UIImageView *wantToDoBackgroundImageView;

// Designated initializer.
// |alarmTime| and |wantToDo| will be passed to AlarmController's startAlarm. 
- (id)initWithAlarmTime:(NSDate *)alarmTime wantToDo:(NSArray *)wantToDo;
- (void)setAlarmView;
- (void)setAlarmViewWithWantToDo:(WantToDoAlarm *)imagePath;
@end
