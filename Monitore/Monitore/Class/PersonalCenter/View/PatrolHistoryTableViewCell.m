//
//  PatrolHistoryTableViewCell.m
//  Monitore
//
//  Created by kede on 2017/7/28.
//  Copyright © 2017年 kede. All rights reserved.
//

#import "PatrolHistoryTableViewCell.h"

@interface PatrolHistoryTableViewCell()
@property (weak, nonatomic) IBOutlet UILabel *startTime;
@property (weak, nonatomic) IBOutlet UILabel *detail;

@end

@implementation PatrolHistoryTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)showDetailModel:(PatrolDetailModel *)model{
    self.startTime.text = model.startTime;
    self.detail.text = model.remark;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
