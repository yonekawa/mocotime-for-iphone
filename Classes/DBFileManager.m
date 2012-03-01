//
//  DBFileManager.m
//  Gemini
//
//  Created by Kenichi Yonekawa on 10/03/09.
//  Copyright 2010 Cybozu, Inc. All rights reserved.
//

#import "DBFileManager.h"

@implementation DBFileManager

+ (NSString *)wantToDoDB
{
    return [DBFileManager dbFilePath:@"wanttodo.db"];
}

+ (NSString *)dbFilePath:(NSString *)dbFileName
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *dbFilePath =
        [documentsDirectory stringByAppendingPathComponent:dbFileName];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    BOOL found = [fileManager fileExistsAtPath:dbFilePath];     
    if(!found) 
    {
        NSString *resourcePath = [[NSBundle mainBundle] resourcePath];
        NSString *defaultDBFilePath =
            [resourcePath stringByAppendingPathComponent:dbFileName];
        
        [fileManager copyItemAtPath:defaultDBFilePath
                             toPath:dbFilePath
                              error:&error];
    }
    
    return dbFilePath;
}

@end
