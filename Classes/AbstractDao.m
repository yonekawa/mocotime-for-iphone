//
//  AbstractDao.m
//  Gemini
//
//  Created by Kenichi Yonekawa on 10/03/11.
//  Copyright 2010 Cybozu, Inc. All rights reserved.
//

#import "AbstractDao.h"

@implementation AbstractDao

- (void)dealloc
{
    [self->connection_ release];
    [self->statement_ release];
    [super dealloc];
}

- (id)initWithDBConnection:(DBConnection *)openedConnection
{
    if (self = [super init])
    {
        self->connection_ = [openedConnection retain];
        self->statement_ =
            [[DBStatement alloc] initWithDBConnection:self->connection_];
    }
    return self;
}

@end
