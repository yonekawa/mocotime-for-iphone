//
//  WantToDoDao.h
//  MoCoTime
//
//  Created by Kenichi Yonekawa on 10/05/11.
//  Copyright 2010 Cybozu, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AbstractDao.h"

@class WantToDoAlarm;

@interface WantToDoDao : AbstractDao

#pragma mark update queries
- (void)addWantToDo:(WantToDoAlarm *)wantToDo;
- (void)modifyWantToDo:(WantToDoAlarm *)wantToDo;
- (void)removeWantToDoByKey:(long long)key;

#pragma mark read queries
- (long long)nextPrimaryKey; // !Do not use by multithread project!
- (NSArray *)arrayOfWantToDo;
- (NSArray *)arrayOfWantToDoOrganized;

@end
