//
//  AnnouncementTableViewCell.m
//  Monitore
//
//  Created by kede on 2017/7/27.
//  Copyright © 2017年 kede. All rights reserved.
//

#import "AnnouncementTableViewCell.h"

@interface AnnouncementTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *header;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *contents;
@property (weak, nonatomic) IBOutlet UIImageView *image1;
@property (weak, nonatomic) IBOutlet UIImageView *image2;
@property (weak, nonatomic) IBOutlet UIImageView *image3;
@property (weak, nonatomic) IBOutlet UIButton *likeButton;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *yposition;

@end

@implementation AnnouncementTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code

    self.selectionStyle = UITableViewCellSelectionStyleNone;
//    self.title.text = @"asfasjf a\n";
}

- (void)showDetailWithData:(AnnounceModel *)model{
    [self.header sd_setImageWithURL:[NSURL URLWithString:model.icon]];
    self.name.text = model.userName;
    self.contents.text = model.detail;
    self.time.text = model.createtime;
    
    if (model.imgList.count == 1) {
        self.yposition.constant = (SCREEN_WIDTH-80)/3.0-50;
        self.image1.hidden = NO;
        CategoryModel *model1 = model.imgList[0];
        [self.image1 sd_setImageWithURL:[NSURL URLWithString:model1.img]];
        self.image2.hidden = YES;
        self.image3.hidden = YES;
        
    }else if(model.imgList.count == 2){
        self.yposition.constant = (SCREEN_WIDTH-80)/3.0-50;
        self.image1.hidden = NO;
        self.image2.hidden = NO;
        CategoryModel *model1 = model.imgList[0];
        [self.image1 sd_setImageWithURL:[NSURL URLWithString:model1.img]];
        CategoryModel *model2 = model.imgList[1];
        [self.image2 sd_setImageWithURL:[NSURL URLWithString:model2.img]];
        self.image3.hidden = YES;
    }else if(model.imgList.count == 3){
        self.yposition.constant = (SCREEN_WIDTH-80)/3.0-50;
        self.image1.hidden = NO;
        self.image2.hidden = NO;
        self.image3.hidden = NO;
        CategoryModel *model1 = model.imgList[0];
        [self.image1 sd_setImageWithURL:[NSURL URLWithString:model1.img]];
        CategoryModel *model2 = model.imgList[1];
        [self.image2 sd_setImageWithURL:[NSURL URLWithString:model2.img]];
        CategoryModel *model3 = model.imgList[2];
        [self.image1 sd_setImageWithURL:[NSURL URLWithString:model3.img]];
    }else{
        self.yposition.constant = -70;
        self.image1.hidden = YES;
        self.image2.hidden = YES;
        self.image3.hidden = YES;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
