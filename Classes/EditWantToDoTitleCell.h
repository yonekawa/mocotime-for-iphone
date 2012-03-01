//
//  EditWantToDoTitleCell.h
//  MoCoTime
//
//  Created by Kenichi Yonekawa on 10/05/16.
//  Copyright 2010 Cybozu, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EditWantToDoTitleCell : UITableViewCell
{
  @private
    UILabel *titleLabel_;
    UILabel *titleContents_;
    
    CGFloat  maxHeight_;
    CGFloat  cellHeight_;
}
@property(nonatomic, retain) IBOutlet UILabel *titleLabel;
@property(nonatomic, retain) IBOutlet UILabel *titleContents;
- (void)setContents:(id)contents;
- (CGFloat)heightForCell;
@end
