//
//  Transaction.m
//  Gemini
//
//  Created by Kenichi Yonekawa on 10/03/09.
//  Copyright 2010 Cybozu, Inc. All rights reserved.
//

#import "Transaction.h"

@implementation Transaction

- (void)dealloc
{
    if (!hasCommitted_)
    {
        [self rollback];
        self->hasCommitted_ = YES;
    }
    
    [self->connection_ release];
    [super dealloc];
}

- (id)initWithDatabaseFilePath:(NSString *)path
{
    if (self = [super init])
    {
        self->hasCommitted_ = NO;
        self->connection_ =
            [[DBConnection alloc] initAndConnectToDatabaseByFilePath:path];

        DBStatement *statement =
            [[DBStatement alloc] initWithDBConnection:self->connection_];
        [statement setQuery:@"BEGIN;"];
        [statement execute];
        [statement release];
    }
    return self;
}

- (DBConnection *)connection
{
    return self->connection_;
}

- (void)commit
{
    if (self->hasCommitted_)
        return;

    DBStatement *statement = [[DBStatement alloc] initWithDBConnection:self->connection_];
    [statement setQuery:@"COMMIT;"];
    [statement execute];
    [statement release];

    self->hasCommitted_ = YES;
}

- (void)rollback
{
    if (self->hasCommitted_)
        return;

    DBStatement *statement =
        [[DBStatement alloc] initWithDBConnection:self->connection_];
    [statement setQuery:@"ROLLBACK;"];
    [statement execute];
    [statement release];
    
    self->hasCommitted_ = YES;
}

@end
