//
//  EditWantToDoRequiredTimeCell.h
//  MoCoTime
//
//  Created by Kenichi Yonekawa on 10/05/16.
//  Copyright 2010 Cybozu, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EditWantToDoRequiredTimeCell : UITableViewCell
{
  @private
    UILabel *requiredTimeLabel_;
    UILabel *requiredTimeContents_;
}
@property(nonatomic, retain) IBOutlet UILabel *requiredTimeLabel;
@property(nonatomic, retain) IBOutlet UILabel *requiredTimeContents;
- (void)setContents:(id)contents;
- (CGFloat)heightForCell;
@end
