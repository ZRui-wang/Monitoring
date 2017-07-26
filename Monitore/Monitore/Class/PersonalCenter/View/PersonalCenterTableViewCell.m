//
//  PersonalCenterTableViewCell.m
//  Monitore
//
//  Created by kede on 2017/7/26.
//  Copyright © 2017年 kede. All rights reserved.
//

#import "PersonalCenterTableViewCell.h"

@interface PersonalCenterTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *titleImageView;

@property (weak, nonatomic) IBOutlet UILabel *title;

@end

@implementation PersonalCenterTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)displyCellDetailWithData:(NSDictionary *)dic
{
    self.titleImageView.image = [UIImage imageNamed:[dic objectForKey:@"titleImage"]];
    self.title.text = [dic objectForKey:@"title"];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
