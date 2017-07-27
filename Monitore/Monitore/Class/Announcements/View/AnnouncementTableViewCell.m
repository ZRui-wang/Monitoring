//
//  AnnouncementTableViewCell.m
//  Monitore
//
//  Created by kede on 2017/7/27.
//  Copyright © 2017年 kede. All rights reserved.
//

#import "AnnouncementTableViewCell.h"

@interface AnnouncementTableViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *titleImage;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *date;

@end

@implementation AnnouncementTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self.title alignTop];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
