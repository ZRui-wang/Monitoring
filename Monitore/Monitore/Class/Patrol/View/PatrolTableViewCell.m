//
//  PatrolTableViewCell.m
//  Monitore
//
//  Created by kede on 2017/7/26.
//  Copyright © 2017年 kede. All rights reserved.
//

#import "PatrolTableViewCell.h"

@interface PatrolTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *date;
@property (weak, nonatomic) IBOutlet UILabel *state;

@end

@implementation PatrolTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.state.layer.borderWidth = 1;
    self.state.layer.borderColor = [UIColor colorWithRed:142/255.0 green:195/255.0 blue:30/255.0 alpha:1].CGColor;
    self.state.layer.masksToBounds = YES;
    self.state.layer.cornerRadius = 2;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
