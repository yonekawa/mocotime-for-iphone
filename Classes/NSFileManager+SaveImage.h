//
//  NSFileManager+SaveImage.h
//  MoCoTime
//
//  Created by Kenichi Yonekawa on 10/05/19.
//  Copyright 2010 Cybozu, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSFileManager (SaveImageExtension)
+ (NSString *)saveTemporaryImage:(UIImage *)image
                        fileName:(NSString *)fileName
                           error:(NSError **)error;
+ (NSString *)pathOfImages:(NSString *)fileName error:(NSError **)error;
@end
