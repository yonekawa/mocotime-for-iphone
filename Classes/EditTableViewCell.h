//
//  EditCell.h
//  MoCoTime
//
//  Created by Kenichi Yonekawa on 10/05/16.
//  Copyright 2010 Cybozu, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject(EditTableViewCell)
- (void)setContents:(id)contents;
- (CGFloat)heightForCell;
@end
