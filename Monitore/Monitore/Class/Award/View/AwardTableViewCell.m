//
//  AwardTableViewCell.m
//  Monitore
//
//  Created by kede on 2017/9/19.
//  Copyright © 2017年 kede. All rights reserved.
//

#import "AwardTableViewCell.h"


@interface AwardTableViewCell()

@property (weak, nonatomic) IBOutlet UIImageView *awardImage;
@property (weak, nonatomic) IBOutlet UILabel *awardName;
@property (weak, nonatomic) IBOutlet UILabel *score;
@property (weak, nonatomic) IBOutlet UILabel *detail;

@end

@implementation AwardTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)showDetailWithData:(GiftListModel *)model{
    [self.awardImage sd_setImageWithURL:[NSURL URLWithString:model.img]];
    self.awardName.text = model.title;
    self.detail.text = model.shl;
    self.score.text = [NSString stringWithFormat:@"积分：%@", model.credit];
}

@end
