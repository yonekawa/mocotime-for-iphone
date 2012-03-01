//
//  DBRowReader.m
//  Gemini
//
//  Created by kojima on 10/03/30.
//  Copyright 2010 Cybozu, Inc. All rights reserved.
//

#import "DBRowReader.h"

@implementation DBRowReader
@synthesize row = row_;

- (id)initWithRow:(NSDictionary *)newRow
{
    if (self = [super init])
    {
        [self setRow:newRow];
    }
    return self;
}

- (BOOL)hasColumn:(NSString *)columnName
{
    return nil != [self->row_ objectForKey:columnName];
}

- (NSString *)readString:(NSString *)columnName
{
    return [self->row_ objectForKey:columnName];
}

- (NSNumber *)readNSNumber:(NSString *)columnName
{
    return [self->row_ objectForKey:columnName];
}

- (int)readInt:(NSString *)columnName
{
    return [[self->row_ objectForKey:columnName] intValue];
}

- (BOOL)readBool:(NSString *)columnName
{
    return [[self->row_ objectForKey:columnName] boolValue];
}

- (long long)readLong:(NSString *)columnName
{
    return [[self->row_ objectForKey:columnName] longLongValue];
}

- (double)readDouble:(NSString *)columnName
{
    return [[self->row_ objectForKey:columnName] doubleValue];
}

- (NSDate *)readDateTime:(NSString *)columnName
{
    return [NSDate dateWithTimeIntervalSinceReferenceDate:[self readDouble:columnName]];
}

@end
