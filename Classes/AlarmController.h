//
//  AlarmController.h
//  MoCoTime
//
//  Created by Kenichi Yonekawa on 10/05/05.
//  Copyright 2010 Cybozu, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@class Alarm;
@class WantToDoAlarm;
@interface AlarmController : NSObject
{
  @private
    id   delegate_;
    BOOL doWakeupAlarm_;
    Alarm *alarmForWakeup_;

    AVAudioPlayer *audioPlayer_;    
    NSTimer *vibrateTimer_;
    NSTimer *multipleWantToDoTimer_;
    
    int indexOfDispleyed_;
    NSArray *multipleWantToDoForAlarm_;
    NSMutableArray *alarmsForWantToDo_;
}
@property(assign) id delegate;
@property(retain) Alarm *alarmForWakeup;

@property(retain) AVAudioPlayer *audioPlayer;
@property(retain) NSTimer *vibrateTimer;
@property(retain) NSTimer *multipleWantToDoTimer;

@property(retain) NSArray *multipleWantToDoForAlarm;
@property(retain) NSMutableArray *alarmsForWantToDo;

- (void)startAlarmLoop:(NSDate *)forWakeup wantToDo:(NSArray *)wantToDo;
- (void)stopAlarm;
@end
