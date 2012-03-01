//
//  BuiltinImages.h
//  MoCoTime
//
//  Created by Kenichi Yonekawa on 10/05/23.
//  Copyright 2010 Cybozu, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BuiltinImages : NSObject
{
    UIImage *cameraIcon_;
    UIImage *setAlarmViewBackground_;
    UIImage *sleepingViewBackground_;
    UIImage *wakeupViewBackground_;
    UIImage *defaultWantToDoViewBackground_;
    UIImage *goodNightButton_;
    UIImage *goodNightButtonSelected_;
}
@property(retain, readonly) UIImage *cameraIcon;
@property(retain, readonly) UIImage *setAlarmViewBackground;
@property(retain, readonly) UIImage *sleepingViewBackground;
@property(retain, readonly) UIImage *wakeupViewBackground;
@property(retain, readonly) UIImage *defaultWantToDoViewBackground;
@property(retain, readonly) UIImage *goodNightButton;
@property(retain, readonly) UIImage *goodNightButtonSelected;
+ (id)instance;
@end
