//
//  DBConnection.m
//  Gemini
//
//  Created by Kenichi Yonekawa on 10/03/09.
//  Copyright 2010 Cybozu, Inc. All rights reserved.
//

#import "DBConnection.h"

@implementation DBConnection
@synthesize db = db_;

- (void)dealloc
{
    if (self->db_ != NULL)
    {
        sqlite3_close(self->db_);
    }
    
    [super dealloc];
}

- (id)initAndConnectToDatabaseByFilePath:(NSString *)path
{
    if (self = [super init])
    {
        if (SQLITE_OK != sqlite3_open([path UTF8String], &(self->db_)))
        {
            if (self->db_ != NULL)
            {
                sqlite3_close(self->db_);
            }
        }
    }
    return self;
}

@end
