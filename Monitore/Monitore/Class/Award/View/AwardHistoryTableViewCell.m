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
    
    self.cancelButton.layer.cornerRadius = self.cancelButton.size.height/2.0;
    self.cancelButton.layer.masksToBounds = YES;
    
    self.collectButton.layer.borderWidth = 1;
    self.collectButton.layer.borderColor = [UIColor colorWithRed:29/255.0 green:136/255.0 blue:230/255.0 alpha:1].CGColor;
    
    
}

- (void)showDetailWithModel:(HistoryModel *)model{
    self.timeLabel.text = [NSString stringWithFormat:@"兑换时间：%@", model.createtime];
    [self.goodsImage sd_setImageWithURL:[NSURL URLWithString:model.img] placeholderImage:[UIImage imageNamed:@"jiangli"]];
    self.detailLabel.text = model.title;
    if ([model.state intValue] == 1) {
        self.cancelButton.hidden = NO;
        self.collectButton.hidden = NO;
    }
    else if([model.state intValue] == 2){
        self.cancelButton.hidden = NO;
        self.collectButton.hidden = YES;
    }
    else{
        self.cancelButton.hidden = YES;
        self.collectButton.hidden = YES;
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
