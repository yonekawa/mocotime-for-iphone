//
//  TextEditViewController.h
//  MoCoTime
//
//  Created by Kenichi Yonekawa on 10/05/16.
//  Copyright 2010 Cybozu, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WantToDoAlarm;
@interface TextEditViewController : UIViewController
    <UITextViewDelegate>
{
  @private
    WantToDoAlarm *wantToDo_;
    UITextView *textView_;
}
@property(nonatomic, retain) WantToDoAlarm *wantToDo;
@property(nonatomic, retain) UITextView *textView;
@end
