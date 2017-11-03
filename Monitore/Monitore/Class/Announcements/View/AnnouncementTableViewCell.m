//
//  AnnouncementTableViewCell.m
//  Monitore
//
//  Created by kede on 2017/7/27.
//  Copyright © 2017年 kede. All rights reserved.
//

#import "AnnouncementTableViewCell.h"

@interface AnnouncementTableViewCell ()


@end

@implementation AnnouncementTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code

    self.selectionStyle = UITableViewCellSelectionStyleNone;
//    self.title.text = @"asfasjf a\n";
}

- (void)showDetailWithData:(AnnounceModel *)model{

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
