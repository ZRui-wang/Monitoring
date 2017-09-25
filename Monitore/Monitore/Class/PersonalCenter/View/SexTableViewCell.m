//
//  SexTableViewCell.m
//  Monitore
//
//  Created by kede on 2017/9/25.
//  Copyright © 2017年 kede. All rights reserved.
//

#import "SexTableViewCell.h"

@interface SexTableViewCell()

@end

@implementation SexTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (IBAction)manButtonAction:(UIButton *)sender {
    self.manButton.selected = !sender.isSelected;
    self.womenButton.selected = !self.manButton.selected;
    
    if ([_delegate respondsToSelector:@selector(selectSexIsMan:)]) {
        [_delegate selectSexIsMan:self.manButton.isSelected];
    }
    
}

- (IBAction)womenButtonAction:(UIButton *)sender {
    self.womenButton.selected = !sender.isSelected;
    self.manButton.selected = !self.womenButton.selected;
    if ([_delegate respondsToSelector:@selector(selectSexIsMan:)]) {
        [_delegate selectSexIsMan:self.manButton.isSelected];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
