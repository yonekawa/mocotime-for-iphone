//
//  MoCoTimeAppDelegate.h
//  MoCoTime
//
//  Created by Kenichi Yonekawa on 10/04/26.
//  Copyright Cybozu, Inc 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SetAlarmViewController.h"

@interface MoCoTimeAppDelegate : NSObject <UIApplicationDelegate>
{
  @private
    UIWindow *window_;
    SetAlarmViewController *setAlarmViewController_;
}
@property(nonatomic, retain) UIWindow *window;
@property(nonatomic, retain) SetAlarmViewController *setAlarmViewController;

@end

