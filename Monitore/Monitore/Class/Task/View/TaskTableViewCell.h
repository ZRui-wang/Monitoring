//
//  TaskTableViewCell.h
//  Monitore
//
//  Created by 小王 on 2017/8/14.
//  Copyright © 2017年 kede. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TaskListModel.h"

@interface TaskTableViewCell : UITableViewCell

- (void)showDetailWithData:(TaskListModel *)model;

@end
