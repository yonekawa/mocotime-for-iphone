//
//  RequiredTimeEditViewController.h
//  MoCoTime
//
//  Created by Kenichi Yonekawa on 10/05/16.
//  Copyright 2010 Cybozu, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WantToDoAlarm;
@interface RequiredTimeEditViewController : UIViewController
{
  @private
    WantToDoAlarm *wantToDo_;
    UIDatePicker *requiredTimePicker_;
}
@property(nonatomic, retain) WantToDoAlarm *wantToDo;
@property(nonatomic, retain) UIDatePicker *requiredTimePicker;
@end
