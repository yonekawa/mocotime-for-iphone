//
//  SQLFinder.h
//  Gemini
//
//  Created by Kenichi Yonekawa on 10/04/18.
//  Copyright 2010 Cybozu, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SQLFinder : NSObject
+ (NSString *)sqlByName:(NSString *)name;
@end
