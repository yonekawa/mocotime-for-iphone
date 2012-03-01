//
//  ReadOnlyTransaction.m
//  Gemini
//
//  Created by Kenichi Yonekawa on 10/03/11.
//  Copyright 2010 Cybozu, Inc. All rights reserved.
//

#import "ReadOnlyTransaction.h"

@implementation ReadOnlyTransaction

- (id)initWithDatabaseFilePath:(NSString *)path
{
    if (self = [super init])
    {
        self->hasCommitted_ = NO;
        self->connection_ =
            [[DBConnection alloc] initAndConnectToDatabaseByFilePath:path];
    }
    return self;
}

- (void) commit
{
    //Do Nothing.
}

- (void) rollback
{
    //Do Nothing.
}

@end
