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


@end

@implementation AwardHistoryTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.cancelButton.tag = self.rowtag;
    self.collectButton.tag = self.rowtag;
    
    self.cancelButton.layer.borderWidth = 1;
    self.cancelButton.layer.borderColor = [UIColor colorWithRed:234/255.0 green:223/255.0 blue:68/255.0 alpha:1].CGColor;
    
    self.collectButton.layer.borderWidth = 1;
    self.collectButton.layer.borderColor = [UIColor colorWithRed:29/255.0 green:136/255.0 blue:230/255.0 alpha:1].CGColor;
    
    
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
