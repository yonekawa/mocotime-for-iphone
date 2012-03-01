//
//  WantToDoDao.m
//  MoCoTime
//
//  Created by Kenichi Yonekawa on 10/05/11.
//  Copyright 2010 Cybozu, Inc. All rights reserved.
//

#import "WantToDoDao.h"
#import "WantToDoAlarm.h"

@implementation WantToDoDao

#pragma mark update queries

- (void)addWantToDo:(WantToDoAlarm *)wantToDo
{
    NSAssert(wantToDo != nil, @"|wantToDo| should not be nil.");
    
    [self->statement_ setQuery:[SQLFinder sqlByName:@"AddWantToDo"]];
    [self->statement_ bindLong:[wantToDo surrogateKey] withIndex:1];
    [self->statement_ bindString:[wantToDo title] withIndex:2];
    if (![wantToDo imagePath])
    {
        [self->statement_ bindString:@"" withIndex:3];
    }
    else
    {
        [self->statement_ bindString:[wantToDo imagePath] withIndex:3];
    }
    [self->statement_ bindDouble:[wantToDo requiredTimeInterval] withIndex:4];

    [self->statement_ execute];
}

- (void)modifyWantToDo:(WantToDoAlarm *)wantToDo
{
    NSAssert(wantToDo != nil, @"|wantToDo| should not be nil.");
    
    [self->statement_ setQuery:[SQLFinder sqlByName:@"ModifyWantToDo"]];
    [self->statement_ bindString:[wantToDo title] withIndex:1];
    if (![wantToDo imagePath])
    {
        [self->statement_ bindString:@"" withIndex:2];
    }
    else
    {
        [self->statement_ bindString:[wantToDo imagePath] withIndex:2];
    }
    [self->statement_ bindDouble:[wantToDo requiredTimeInterval] withIndex:3];
    [self->statement_ bindLong:[wantToDo surrogateKey] withIndex:4];

    [self->statement_ execute];
}

- (void)removeWantToDoByKey:(long long)key
{
    [self->statement_ setQuery:[SQLFinder sqlByName:@"GetWantToDoByKey"]];
    [self->statement_ bindLong:key withIndex:1];
    NSArray *results = [self->statement_ executeReader];
    if (results == nil || [results count] <= 0)
        return;
    
    [self->statement_ setQuery:[SQLFinder sqlByName:@"RemoveWantToDoByKey"]];
    [self->statement_ bindLong:key withIndex:1];

    [self->statement_ execute];
    
    NSDictionary *result = [results objectAtIndex:0];
    DBRowReader *reader = [[DBRowReader alloc] initWithRow:result];
    NSString *imagePath = [reader readString:@"col_image_path"];
    [reader release];

    NSError *error = nil;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if([fileManager fileExistsAtPath:imagePath])
    {
        [fileManager removeItemAtPath:imagePath error:&error];
    }
}

#pragma mark read queries

- (long long)nextPrimaryKey
{
    [self->statement_ setQuery:[SQLFinder sqlByName:@"GetNextPrimaryKeyOfWantToDo"]];
    NSArray *results = [self->statement_ executeReader];
    if (results == nil || [results count] <= 0)
        return 1;
    
    NSDictionary *result = [results objectAtIndex:0];
    DBRowReader *reader = [[DBRowReader alloc] initWithRow:result];
    long long primaryKey = [reader readLong:@"largest_primary_key"];
    [reader release];
    
    return (primaryKey + 1);
}

- (NSArray *)arrayOfWantToDo
{
    [self->statement_ setQuery:[SQLFinder sqlByName:@"GetListOfWantToDo"]];
    NSArray *results = [self->statement_ executeReader];
    if (results == nil || [results count] <= 0)
        return [NSArray array];
    
    NSMutableArray *arrayOfWantToDo = [[[NSMutableArray alloc] init] autorelease];
    for (NSDictionary *result in results)
    {
        DBRowReader *reader = [[DBRowReader alloc] initWithRow:result];
        WantToDoAlarm *wantToDo = [[WantToDoAlarm alloc] init];
        
        [wantToDo setSurrogateKey:[reader readLong:@"_id"]];
        [wantToDo setTitle:[reader readString:@"col_title"]];
        [wantToDo setImagePath:[reader readString:@"col_image_path"]];
        [wantToDo setRequiredTimeInterval:[reader readDouble:@"col_required_time"]];
        [arrayOfWantToDo addObject:wantToDo];
        
        [wantToDo release];
        [reader release];
    }
    return arrayOfWantToDo;
}

- (NSArray *)arrayOfWantToDoOrganized
{
    [self->statement_ setQuery:[SQLFinder sqlByName:@"GetListOfWantToDo"]];
    NSArray *results = [self->statement_ executeReader];
    if (results == nil || [results count] <= 0)
        return [NSArray array];
    
    NSMutableArray *arrayOfWantToDo = [[[NSMutableArray alloc] init] autorelease];
    WantToDoAlarm *previousWantToDo = nil;
    NSMutableArray *arrayOfWantToDoRequiredSameTime = [[NSMutableArray alloc] init];
    for (NSDictionary *result in results)
    {
        DBRowReader *reader = [[DBRowReader alloc] initWithRow:result];
        WantToDoAlarm *wantToDo = [[WantToDoAlarm alloc] init];
        [wantToDo setSurrogateKey:[reader readLong:@"_id"]];
        [wantToDo setTitle:[reader readString:@"col_title"]];
        [wantToDo setImagePath:[reader readString:@"col_image_path"]];
        [wantToDo setRequiredTimeInterval:[reader readDouble:@"col_required_time"]];

        if (previousWantToDo == nil ||
            [previousWantToDo requiredTimeInterval] == [wantToDo requiredTimeInterval])
        {
            if (wantToDo != previousWantToDo)
            {
                [arrayOfWantToDoRequiredSameTime addObject:wantToDo];
                [previousWantToDo release];
                previousWantToDo = wantToDo;
                [previousWantToDo retain];
            }
        }
        else
        {
            NSArray *array = [arrayOfWantToDoRequiredSameTime copy];
            [arrayOfWantToDo addObject:array];
            [array release];
            [arrayOfWantToDoRequiredSameTime removeAllObjects];
            [arrayOfWantToDoRequiredSameTime addObject:wantToDo];
        }
        
        [wantToDo release];
        [reader release];
    }
    
    if ([arrayOfWantToDoRequiredSameTime count] > 0)
        [arrayOfWantToDo addObject:arrayOfWantToDoRequiredSameTime];
    
    [previousWantToDo release];
    [arrayOfWantToDoRequiredSameTime release];
    return arrayOfWantToDo;
}

@end
