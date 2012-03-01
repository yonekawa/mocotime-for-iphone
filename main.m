//
//  main.m
//  MoCoTime
//
//  Created by Kenichi Yonekawa on 10/04/26.
//  Copyright Cybozu, Inc 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

int main(int argc, char *argv[]) {
    
    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
    int retVal = UIApplicationMain(argc, argv, nil, @"MoCoTimeAppDelegate");
    [pool release];
    return retVal;
}
