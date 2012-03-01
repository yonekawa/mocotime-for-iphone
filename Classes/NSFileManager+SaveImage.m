//
//  NSFileManager+SaveImage.m
//  MoCoTime
//
//  Created by Kenichi Yonekawa on 10/05/19.
//  Copyright 2010 Cybozu, Inc. All rights reserved.
//

#import "NSFileManager+SaveImage.h"

@implementation NSFileManager (SaveImageExtension)
+ (NSString *)saveTemporaryImage:(UIImage *)image
                        fileName:(NSString *)fileName
                           error:(NSError **)error
{
    NSString *tmpDirectory = NSTemporaryDirectory();
    NSString *targetDirectory = 
        [tmpDirectory stringByAppendingPathComponent:@"images"];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];    
    BOOL isDirectory;
    BOOL foundDirectory = [fileManager fileExistsAtPath:targetDirectory
                                            isDirectory:&isDirectory];
    if (!foundDirectory)
    {
        [fileManager createDirectoryAtPath:targetDirectory
               withIntermediateDirectories:YES
                                attributes:nil
                                     error:error];
    }
    else if (foundDirectory && !isDirectory)
    {
        [fileManager removeItemAtPath:targetDirectory error:error];
        [fileManager createDirectoryAtPath:targetDirectory
               withIntermediateDirectories:YES
                                attributes:nil
                                     error:error];
    }

    NSString *filePath = [targetDirectory stringByAppendingPathComponent:fileName];
    if ([fileManager fileExistsAtPath:filePath])
    {
        [fileManager removeItemAtPath:filePath error:error];
    }    
    [UIImagePNGRepresentation(image) writeToFile:filePath atomically:YES];
    
    return filePath;
}

+ (NSString *)pathOfImages:(NSString *)fileName error:(NSError **)error
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                         NSUserDomainMask,
                                                         YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *targetDirectory = 
        [documentsDirectory stringByAppendingPathComponent:@"images"];

    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    BOOL isDirectory;
    BOOL foundDirectory = [fileManager fileExistsAtPath:targetDirectory
                                            isDirectory:&isDirectory];
    if (!foundDirectory)
    {
        [fileManager createDirectoryAtPath:targetDirectory
               withIntermediateDirectories:YES
                                attributes:nil
                                     error:error];
    }
    else if (foundDirectory && !isDirectory)
    {
        [fileManager removeItemAtPath:targetDirectory error:error];
        [fileManager createDirectoryAtPath:targetDirectory
               withIntermediateDirectories:YES
                                attributes:nil
                                     error:error];
    }
    
    NSString *filePath = [targetDirectory stringByAppendingPathComponent:fileName];
    if ([fileManager fileExistsAtPath:filePath])
    {
        [fileManager removeItemAtPath:filePath error:error];
    }
    return filePath;
}

@end
