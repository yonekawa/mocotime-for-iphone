//
//  DBStatement.h
//  Gemini
//
//  Created by Kenichi Yonekawa on 10/03/09.
//  Copyright 2010 Cybozu, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DBConnection.h"

// DBStatement
//
/// The class of statement for SQLite.
//
@interface DBStatement : NSObject
{
    sqlite3_stmt *statement_;
    DBConnection *connection_;
}
- (id)initWithDBConnection:(DBConnection *)connection;

- (void)setQuery:(NSString *)newQuery;
- (void)bindString:(NSString *)stringValue withIndex:(int)index;
- (void)bindInt:(int)intValue withIndex:(int)index;
- (void)bindBool:(BOOL)boolValue withIndex:(int)index;
- (void)bindLong:(long long)longValue withIndex:(int)index;
- (void)bindDouble:(double)doubleValue withIndex:(int)index;
- (void)bindDateTime:(NSDate *)datetime withIndex:(int)index;

- (void)execute;
- (NSArray *)executeReader;

@end
