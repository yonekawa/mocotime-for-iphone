//
//  AbstractDao.h
//  Gemini
//
//  Created by Kenichi Yonekawa on 10/03/11.
//  Copyright 2010 Cybozu, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DBConnection.h"
#import "DBStatement.h"
#import "DBRowReader.h"
#import "SQLFinder.h"

// AbstractDao
//
/// AbstractDao is a class that abstracts DAO.
/// All Dao should extends to this class.
/// AbstractDao give to you the initialized DBStatement.
//
@interface AbstractDao : NSObject
{
  @protected
    DBConnection *connection_;
    DBStatement  *statement_;
}
- (id)initWithDBConnection:(DBConnection *)connection;

@end
