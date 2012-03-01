//
//  WantToDoListCell.h
//  MoCoTime
//
//  Created by Kenichi Yonekawa on 10/05/19.
//  Copyright 2010 Cybozu, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WantToDoAlarm;
@interface WantToDoListCell : UITableViewCell
{
  @private
    UIImageView *wantToDoImageView_;
    UILabel     *requiredTimeLabel_;
    UILabel     *titleLabel_;
}
// This view created by programmatically for round rect.
@property(retain) UIImageView *wantToDoImageView;

@property(nonatomic, retain) IBOutlet UILabel *requiredTimeLabel;
@property(nonatomic, retain) IBOutlet UILabel *titleLabel;

- (void)setWantToDo:(WantToDoAlarm *)wantToDo;
@end
