//
//  Alarm.h
//  MoCoTime
//
//  Created by Kenichi Yonekawa on 10/05/05.
//  Copyright 2010 Cybozu, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Alarm : NSObject
{
  @protected
    NSDate *time_;
}
@property(nonatomic, retain) NSDate *time;

@end
