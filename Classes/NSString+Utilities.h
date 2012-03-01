//
//  NSString+Utilities.h
//  Gemini
//
//  Created by Kenichi Yonekawa on 10/03/10.
//  Copyright 2010 Cybozu, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

// Utilities for NSString.
@interface NSString (Utilities)

// Check to "Is This empty?"
- (BOOL)isEmpty;

// Check to "Strting is nil or empty?"
+ (BOOL)isNilOrEmpty:(NSString *)string;

// Create NSString with validate null characters.
+ (NSString *)stringWithUTF8StringNullValidate:(const char *)utf8String;

@end
