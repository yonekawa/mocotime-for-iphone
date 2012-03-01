//
//  WantToDo.h
//  MoCoTime
//
//  Created by Kenichi Yonekawa on 10/04/29.
//  Copyright 2010 Cybozu, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Alarm.h"

// Entity of want to do.
@interface WantToDoAlarm : Alarm
{
  @protected
    long long       surrogateKey_;
    NSString       *imagePath_;
    NSString       *title_;
    NSTimeInterval  requiredTimeInterval_;
}
@property(nonatomic, assign) long long surrogateKey;
@property(nonatomic, copy) NSString *imagePath;
@property(nonatomic, copy)   NSString *title;
@property(nonatomic, assign) NSTimeInterval requiredTimeInterval;

@end
