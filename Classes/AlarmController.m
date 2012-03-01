//
//  AlarmController.m
//  MoCoTime
//
//  Created by Kenichi Yonekawa on 10/05/05.
//  Copyright 2010 Cybozu, Inc. All rights reserved.
//

#import "AlarmController.h"
#import "Alarm.h"
#import "AlarmType.h"
#import "WantToDoAlarm.h"
#import <AudioToolbox/AudioToolbox.h>
#import "NSDate+TimeAndMinuteComparison.h"

@interface AlarmController()
- (void)tickTack;
- (void)playAlarm:(AlarmType)type;
- (void)playVibrate;
- (void)playWantToDoAlarm;
- (void)createMiscTimer:(AlarmType)type;
- (void)cancelAlarm:(AlarmType)type;
- (void)invokeAlarm:(AlarmType)type withAlarmInfo:(id)info;
- (void)invokeWakeupAlarm;
- (void)invokeWantToDoAlarm:(NSArray *)multipleWantToDo;
@end

@implementation AlarmController
@synthesize delegate = delegate_;
@synthesize alarmForWakeup = alarmForWakeup_;
@synthesize alarmsForWantToDo = alarmsForWantToDo_;
@synthesize audioPlayer = audioPlayer_;
@synthesize vibrateTimer = vibrateTimer_;
@synthesize multipleWantToDoForAlarm = multipleWantToDoForAlarm_;
@synthesize multipleWantToDoTimer = multipleWantToDoTimer_;

- (void)dealloc
{
    [alarmForWakeup_ release];
    [alarmsForWantToDo_ release];
    [audioPlayer_ release];
    [vibrateTimer_ release];
    [multipleWantToDoForAlarm_ release];
    [multipleWantToDoTimer_ release];
    
    [super dealloc];
}

- (void)startAlarmLoop:(NSDate *)forWakeup wantToDo:(NSArray *)wantToDo
{
    Alarm *wakeUpAlarm = [[Alarm alloc] init];
    [wakeUpAlarm setTime:forWakeup];
    [self setAlarmForWakeup:wakeUpAlarm];
    [wakeUpAlarm release];
    [self setAlarmsForWantToDo:[wantToDo mutableCopy]];
    
    NSTimer *alarmTimer = [NSTimer timerWithTimeInterval:1
                                                  target:self
                                                selector:@selector(tickTack)
                                                userInfo:nil
                                                 repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:alarmTimer forMode:NSDefaultRunLoopMode];
}

- (void)stopAlarm
{
    [self cancelAlarm:AlarmTypeWantToDo];
}

- (void)tickTack
{
    if (doWakeupAlarm_)
        return;

    NSDate *now = [NSDate date];
    if ([now isEqualToTimeAndMinutes:[[self alarmForWakeup] time]])
    {
        [self invokeAlarm:AlarmTypeWakeup withAlarmInfo:nil];
    }
    else
    {
        int i;
        int count = [[self alarmsForWantToDo] count];
        for (i = 0; i < count; i++)
        {
            // wantToDo is multiple
            NSArray *multipleWantToDo = [[self alarmsForWantToDo] objectAtIndex:i];
            WantToDoAlarm *firstWantToDo =
                (WantToDoAlarm *)[multipleWantToDo objectAtIndex:0];
            if ([now isEqualToTimeAndMinutes:[firstWantToDo time]])
            {
                [self invokeAlarm:AlarmTypeWantToDo withAlarmInfo:multipleWantToDo];
                break;
            }
        }
        
        // Remove invoked alarm.
        if (i < count)
            [[self alarmsForWantToDo] removeObjectAtIndex:i];
    }
}

- (void)createMiscTimer:(AlarmType)type
{
    NSTimeInterval timerInterval = 1;
    if (type == AlarmTypeWantToDo)
    {
        timerInterval = 2;
        [self setMultipleWantToDoTimer:[NSTimer timerWithTimeInterval:timerInterval
                                                               target:self
                                                             selector:@selector(playWantToDoAlarm)
                                                             userInfo:nil
                                                              repeats:YES]];
    }
    
    [self setVibrateTimer:[NSTimer timerWithTimeInterval:timerInterval
                                                  target:self
                                                selector:@selector(playVibrate)
                                                userInfo:nil
                                                 repeats:YES]];
}

- (void)cancelAlarm:(AlarmType)type
{
    [[self multipleWantToDoTimer] invalidate];
    [[self vibrateTimer] invalidate];
    [[self audioPlayer] stop];
    [[self audioPlayer] setCurrentTime:0];
}

- (void)invokeAlarm:(AlarmType)type withAlarmInfo:(id)info
{
    [self playAlarm:type];
    switch (type)
    {
        case AlarmTypeWakeup:
        {
            [self invokeWakeupAlarm];
            break;
        }
        case AlarmTypeWantToDo:
        {
            NSArray *multipleWantToDo = (NSArray *)info;
            [self invokeWantToDoAlarm:multipleWantToDo];
            break;
        }
    }
}

- (void)invokeWakeupAlarm
{
    if (!doWakeupAlarm_)
    {
        doWakeupAlarm_ = YES;
        if ([[self delegate] respondsToSelector:@selector(setAlarmView)])
        {
            [[self delegate] performSelectorOnMainThread:@selector(setAlarmView)
                                              withObject:nil
                                           waitUntilDone:YES];
        }
    }
}

- (void)invokeWantToDoAlarm:(NSArray *)multipleWantToDo
{
    indexOfDispleyed_ = 0;
    [self setMultipleWantToDoForAlarm:multipleWantToDo];
    [[NSRunLoop currentRunLoop] addTimer:[self multipleWantToDoTimer]
                                 forMode:NSDefaultRunLoopMode];
}

- (void)playAlarm:(AlarmType)type
{
    [self cancelAlarm:type];
    [self createMiscTimer:type];
    
    [[NSRunLoop currentRunLoop] addTimer:[self vibrateTimer] forMode:NSDefaultRunLoopMode];

    NSString *soundPath = nil;
    if (type == AlarmTypeWakeup)
    {
        soundPath = [[NSBundle mainBundle] pathForResource:@"wakeup" ofType:@"mp3"];
    }
    else
    {
        soundPath = [[NSBundle mainBundle] pathForResource:@"wantToDo" ofType:@"mp3"];
    }
    NSError *error = nil;
    NSURL *url = [[NSURL alloc] initWithString:soundPath];
    AVAudioPlayer *player = [[AVAudioPlayer alloc] initWithContentsOfURL:url
                                                                   error:&error];
    [url release];
    [player setCurrentTime:0];
    [player setNumberOfLoops:-1];
    [self setAudioPlayer:player];
    [player release];
    
    [[self audioPlayer] play];
}

- (void)playVibrate
{
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
}

- (void)playWantToDoAlarm
{
    if (indexOfDispleyed_ >= [[self multipleWantToDoForAlarm] count])
        return;
    
    WantToDoAlarm *wantToDo =
        [[self multipleWantToDoForAlarm] objectAtIndex:indexOfDispleyed_];
    if ([[self delegate] respondsToSelector:@selector(setAlarmViewWithWantToDo:)])
    {
        [[self delegate] performSelectorOnMainThread:@selector(setAlarmViewWithWantToDo:)
                                          withObject:wantToDo
                                       waitUntilDone:YES];
    }
    
    indexOfDispleyed_ += 1;
    if (indexOfDispleyed_ >= [[self multipleWantToDoForAlarm] count])
    {
        indexOfDispleyed_ = 0;
    }
}

@end
