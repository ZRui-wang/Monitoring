//
//  AwardHistoryTableViewCell.h
//  Monitore
//
//  Created by kede on 2017/10/19.
//  Copyright © 2017年 kede. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HistoryModel.h"

@interface AwardHistoryTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UIButton *collectButton;

@property (assign, nonatomic) BOOL rowtag;

- (void)showDetailWithModel:(HistoryModel *)model;

@end
