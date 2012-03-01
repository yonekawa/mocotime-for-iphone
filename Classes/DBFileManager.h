//
//  DBFileManager.h
//  Gemini
//
//  Created by Kenichi Yonekawa on 10/03/09.
//  Copyright 2010 Cybozu, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

// DBFactory
//
/// The class of the database file factory
//
@interface DBFileManager : NSObject
+ (NSString *)wantToDoDB;
+ (NSString *)dbFilePath:(NSString *)dbFileName;
@end
