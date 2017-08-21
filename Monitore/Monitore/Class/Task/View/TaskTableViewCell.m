//
//  TaskTableViewCell.m
//  Monitore
//
//  Created by 小王 on 2017/8/14.
//  Copyright © 2017年 kede. All rights reserved.
//

#import "TaskTableViewCell.h"

@interface TaskTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *taskTitleLable;
@property (weak, nonatomic) IBOutlet UILabel *taskLabel;
@property (weak, nonatomic) IBOutlet UILabel *taskClass;
@property (weak, nonatomic) IBOutlet UILabel *address;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@end

@implementation TaskTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.distanceLabel.layer.borderColor = [UIColor redColor].CGColor;
    self.distanceLabel.layer.borderWidth  = 1;
    self.distanceLabel.layer.cornerRadius = 4;
    self.distanceLabel.layer.masksToBounds = YES;
    
    self.taskTitleLable.layer.cornerRadius = 4;
    self.taskTitleLable.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end