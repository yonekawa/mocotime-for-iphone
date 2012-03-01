//
//  SQLFinder.m
//  Gemini
//
//  Created by Kenichi Yonekawa on 10/04/18.
//  Copyright 2010 Cybozu, Inc. All rights reserved.
//

#import "SQLFinder.h"

@implementation SQLFinder

+ (NSString *)sqlByName:(NSString *)name
{
    NSString *path = [[NSBundle mainBundle] pathForResource:name ofType:@"sql"];
    NSString *sql = [[NSString alloc] initWithContentsOfFile:path
                                                    encoding:NSUTF8StringEncoding
                                                       error:nil];

    return [sql autorelease];
}

@end
