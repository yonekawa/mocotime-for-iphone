//
//  DBStatement.m
//  Gemini
//
//  Created by Kenichi Yonekawa on 10/03/09.
//  Copyright 2010 Cybozu, Inc. All rights reserved.
//

#import "DBStatement.h"
#import "NSString+Utilities.h"

@implementation DBStatement

- (void)dealloc
{
    if (self->statement_ != NULL)
    {
        sqlite3_finalize(self->statement_);
    }
    
    [super dealloc];
}

- (id)initWithDBConnection:(DBConnection *)openedConnection
{
    if (self = [super init])
    {
        self->connection_ = openedConnection;
    }
    return self;
}

- (void)setQuery:(NSString *)newQuery
{
    if (self->statement_)
    {
        sqlite3_reset(self->statement_);
    }

    if (SQLITE_OK != sqlite3_prepare_v2([self->connection_ db],
                                        [newQuery UTF8String],
                                        -1,
                                        &(self->statement_),
                                        NULL))
    {
        NSLog(@"Error while creating statement '%s'",
              sqlite3_errmsg([self->connection_ db]));
    };
}

- (void)bindString:(NSString *)stringValue withIndex:(int)index
{
    if (self->statement_ != NULL)
    {
        sqlite3_bind_text(self->statement_,
                          index,
                          [stringValue UTF8String],
                          -1,
                          SQLITE_TRANSIENT);
    }
}

- (void)bindLong:(long long)longValue withIndex:(int)index
{
    if (self->statement_ != NULL)
    {
        sqlite3_bind_int64(self->statement_, index, longValue);
    }
}

- (void)bindInt:(int)intValue withIndex:(int)index
{
    if (self->statement_ != NULL)
    {
        sqlite3_bind_int(self->statement_, index, intValue);
    }
}

- (void)bindBool:(BOOL)boolValue withIndex:(int)index
{
    if (self->statement_ != NULL)
    {
        sqlite3_bind_int(self->statement_, index, boolValue ? 1 : 0);
    }
}

- (void)bindDouble:(double)doubleValue withIndex:(int)index
{
    if (self->statement_ != NULL)
    {
        sqlite3_bind_double(self->statement_, index, doubleValue);
    }
}

- (void)bindDateTime:(NSDate *)datetime withIndex:(int)index
{
    [self bindDouble:[datetime timeIntervalSinceReferenceDate]
           withIndex:index];
}

- (void)execute
{
    if (self->statement_ != NULL)
    {
        if (SQLITE_DONE != sqlite3_step(self->statement_))
        {
            NSLog(@"Error while executing statement '%s'",
                  sqlite3_errmsg([self->connection_ db]));
        }
        sqlite3_reset(self->statement_);
    }
}

- (NSArray *)executeReader
{
    if (self->statement_ == NULL)
    {
        return nil;
    }

    NSMutableArray *rows = [[[NSMutableArray alloc] init] autorelease];
    while (SQLITE_ROW == sqlite3_step(self->statement_))
    {
        NSMutableDictionary *row = [[NSMutableDictionary alloc] init];
        for (int i = 0; i < sqlite3_column_count(self->statement_); i++)
        {
            switch (sqlite3_column_type(self->statement_, i))
            {
                case SQLITE_INTEGER:
                    [row setValue:[NSNumber numberWithLongLong:
                                   sqlite3_column_int64(self->statement_, i)]
                           forKey:[NSString stringWithUTF8String:
                                   sqlite3_column_name(self->statement_, i)]];
                    break;
                case SQLITE_TEXT:
                    [row setValue:[NSString stringWithUTF8StringNullValidate:
                                   (const char *)sqlite3_column_text(self->statement_, i)]
                           forKey:[NSString stringWithUTF8String:
                                   sqlite3_column_name(self->statement_, i)]];
                    break;
                case SQLITE_FLOAT:
                    [row setValue:[NSNumber numberWithDouble:
                                   sqlite3_column_double(self->statement_, i)]
                           forKey:[NSString stringWithUTF8String:
                                   sqlite3_column_name(self->statement_, i)]];
                    break;
                case SQLITE_NULL:
                    [row setValue:nil
                           forKey:[NSString stringWithUTF8String:
                                   sqlite3_column_name(self->statement_, i)]];
                    break;
                case SQLITE_BLOB:
                default:
                    break;
            }
        }
        [rows addObject:row];
        [row release];
    }
    sqlite3_reset(self->statement_);
    return rows;
}

@end
