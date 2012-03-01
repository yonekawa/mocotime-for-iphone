//
//  DBConnection.h
//  Gemini
//
//  Created by Kenichi Yonekawa on 10/03/09.
//  Copyright 2010 Cybozu, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

// DBConnection
//
/// The connection class for SQLite.
//
@interface DBConnection : NSObject
{
    sqlite3 *db_;
}
@property (nonatomic, readonly, assign) sqlite3 *db;
- (id)initAndConnectToDatabaseByFilePath:(NSString *)path;
@end
