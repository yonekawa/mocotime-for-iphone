//
//  DBRowReader.h
//  Gemini
//
//  Created by kojima on 10/03/30.
//  Copyright 2010 Cybozu, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DBRowReader : NSObject
{
    NSDictionary *row_;
}
@property(nonatomic, retain) NSDictionary *row;

- (id)initWithRow:(NSDictionary *)newRow;

- (BOOL)hasColumn:(NSString *)columnName;
- (NSString *)readString:(NSString *)columnName;
- (NSNumber *)readNSNumber:(NSString *)columnName;
- (int)readInt:(NSString *)columnName;
- (BOOL)readBool:(NSString *)columnName;
- (long long)readLong:(NSString *)columnName;
- (double)readDouble:(NSString *)columnName;
- (NSDate *)readDateTime:(NSString *)columnName;

@end
