//
//  BlackListTableViewCell.m
//  Monitore
//
//  Created by kede on 2017/9/19.
//  Copyright © 2017年 kede. All rights reserved.
//

#import "BlackListTableViewCell.h"

@interface BlackListTableViewCell()

@property (weak, nonatomic) IBOutlet UIImageView *img;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *time;

@end

@implementation BlackListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)showDetailWithData:(BlackModel *)model{
    [self.img sd_setImageWithURL:[NSURL URLWithString:model.icon]placeholderImage:[UIImage imageNamed:@"维稳黑名单"]];
    if (model.title) {
        self.title.text = model.title;
    }else{
        self.title.text = model.remark;
    }
    
    self.time.text = model.createtime;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
