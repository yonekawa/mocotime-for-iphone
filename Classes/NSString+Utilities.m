//
//  NSString+Utilities.m
//  Gemini
//
//  Created by Kenichi Yonekawa on 10/03/10.
//  Copyright 2010 Cybozu, Inc. All rights reserved.
//

#import "NSString+Utilities.h"

@implementation NSString (Utilities)

- (BOOL)isEmpty
{
    return [self length] == 0;
}

+ (BOOL)isNilOrEmpty:(NSString *)string
{
    if (nil == string)
    {
        return YES;
    }
    return [string isEmpty];
}

+ (NSString *)stringWithUTF8StringNullValidate:(const char *)utf8String
{
    NSString *string = nil;
    if (utf8String != NULL)
    {
        string = [NSString stringWithUTF8String:utf8String];
    }
    return string;
}

@end
