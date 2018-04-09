//
//  TrainTableViewCell.m
//  Monitore
//
//  Created by kede on 2017/9/19.
//  Copyright © 2017年 kede. All rights reserved.
//

#import "TrainTableViewCell.h"

@interface TrainTableViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *img;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *time;

@end

@implementation TrainTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)showDetailWithData:(TrainModel *)model{
    
    [self.img sd_setImageWithURL:[NSURL URLWithString:model.icon] placeholderImage:[UIImage imageNamed:@"志愿者学习"]];
    self.title.text = model.title;
    self.time.text = model.createtime;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
