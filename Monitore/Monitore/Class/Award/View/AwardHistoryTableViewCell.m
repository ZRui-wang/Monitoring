//
//  AwardHistoryTableViewCell.m
//  Monitore
//
//  Created by kede on 2017/10/19.
//  Copyright © 2017年 kede. All rights reserved.
//

#import "AwardHistoryTableViewCell.h"

@interface AwardHistoryTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *goodsImage;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UIButton *collectButton;

@end

@implementation AwardHistoryTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)showDetailWithModel:(HistoryModel *)model{
    self.timeLabel.text = [NSString stringWithFormat:@"兑换时间：%@", model.createtime];
    [self.goodsImage sd_setImageWithURL:[NSURL URLWithString:model.img] placeholderImage:[UIImage imageNamed:@"jiangli"]];
    self.detailLabel.text = model.title;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
