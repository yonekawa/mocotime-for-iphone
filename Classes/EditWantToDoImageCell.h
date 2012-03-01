//
//  EditWantToDoImageCell.h
//  MoCoTime
//
//  Created by Kenichi Yonekawa on 10/05/17.
//  Copyright 2010 Cybozu, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EditWantToDoImageCell : UITableViewCell
{
  @private
    id           delegate_;
    UIButton    *imageSelectButton_;
    UIImageView *wantToDoImageView_;
    UIImageView *cameraIconImageView_;
}
// Delegate for view controllre transition.
// Typically, set parent view controller to this.
@property(nonatomic, assign) id                   delegate;

// This view created by programmatically for round rect.
@property(nonatomic, retain) UIImageView          *wantToDoImageView;
@property(nonatomic, retain) IBOutlet UIButton    *imageSelectButton;

@property(nonatomic, retain) IBOutlet UIImageView *cameraIconImageView;
- (void)setContents:(id)contents;
- (CGFloat)heightForCell;
- (void)touchDown;
- (void)touchUp;
- (void)touchUpInside;
@end
