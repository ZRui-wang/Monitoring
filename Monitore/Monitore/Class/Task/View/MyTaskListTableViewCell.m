//
//  MyTaskListTableViewCell.m
//  Monitore
//
//  Created by kede on 2017/9/27.
//  Copyright © 2017年 kede. All rights reserved.
//

#import "MyTaskListTableViewCell.h"

@interface MyTaskListTableViewCell()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleDetail;
@property (weak, nonatomic) IBOutlet UILabel *startAddress;
@property (weak, nonatomic) IBOutlet UILabel *endAddress;
@property (weak, nonatomic) IBOutlet UILabel *startTime;
@property (weak, nonatomic) IBOutlet UILabel *endTime;
@end

@implementation MyTaskListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
