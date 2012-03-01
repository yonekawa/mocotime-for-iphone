//
//  Transaction.h
//  Gemini
//
//  Created by Kenichi Yonekawa on 10/03/09.
//  Copyright 2010 Cybozu, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DBConnection.h"
#import "DBStatement.h"

// Transaction
//
/// Transaction treats the scope of transaction.
/// If you send the 'initWithDatabaseFilePath' messsage, 
/// Transaction open connection to SQLite DB and execute 'BEGIN;'.
/// You should send 'commit' message to the instance for transaction committing.
/// If you didn't send 'commit', transaction does rollback when Transaction dealloc.
//
@interface Transaction : NSObject
{
    BOOL hasCommitted_;
    DBConnection *connection_;
}
- (id)initWithDatabaseFilePath:(NSString *)path;
- (DBConnection *)connection;
- (void)commit;
- (void)rollback;

@end
