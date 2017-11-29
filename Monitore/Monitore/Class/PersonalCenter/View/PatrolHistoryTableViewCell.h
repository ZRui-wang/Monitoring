//
//  PatrolHistoryTableViewCell.h
//  Monitore
//
//  Created by kede on 2017/7/28.
//  Copyright © 2017年 kede. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HistoryPatrolModel.h"

@interface PatrolHistoryTableViewCell : UITableViewCell

- (void)showDetailModel:(PatrolDetailModel *)model;

@end
