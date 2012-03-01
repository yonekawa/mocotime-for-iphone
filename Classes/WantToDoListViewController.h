//
//  WantToDoListViewController.h
//  MoCoTime
//
//  Created by Kenichi Yonekawa on 10/05/04.
//  Copyright 2010 Cybozu, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WantToDoListViewController : UIViewController
    <UITableViewDelegate, UITableViewDataSource>
{
  @private
    UITableView *tableView_;
    NSArray *arrayOfWantToDo_;
}
@property(nonatomic, retain) UITableView *tableView;
@property(nonatomic, retain) NSArray *arrayOfWantToDo;

- (void)presentAddWantToDoView;
- (void)backToParentView;

@end
