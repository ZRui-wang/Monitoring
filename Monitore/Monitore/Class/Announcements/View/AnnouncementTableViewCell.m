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
@property (strong, nonatomic)UIView *bgView;

@end

@implementation AnnouncementTableViewCell{
    NSString *usercircleId;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code

    self.selectionStyle = UITableViewCellSelectionStyleNone;
//    self.title.text = @"asfasjf a\n";
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction1)];
    [self.image1 addGestureRecognizer:tap];
    self.image1.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction2)];
    [self.image2 addGestureRecognizer:tap2];
    self.image2.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tap3 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction3)];
    [self.image3 addGestureRecognizer:tap3];
    self.image3.userInteractionEnabled = YES;
    
}

- (void)tapAction1{
    
    if (self.bgView) {
        [self.bgView removeFromSuperview];
        return;
    }
    
    UIWindow *window = [[UIApplication sharedApplication].delegate window];
    self.bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    self.bgView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(removeBgAction)];
    [self.bgView addGestureRecognizer:tap];
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(30, 0, SCREEN_WIDTH-60, SCREEN_WIDTH-60)];
    imageView.centerY = self.bgView.centerY;
    imageView.image = self.image1.image;
    [self.bgView addSubview:imageView];
    [window addSubview:self.bgView];
    
    
}

- (void)tapAction2{
    
    if (self.bgView) {
        [self.bgView removeFromSuperview];
        return;
    }
    
    UIWindow *window = [[UIApplication sharedApplication].delegate window];
    self.bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    self.bgView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(removeBgAction)];
    [self.bgView addGestureRecognizer:tap];
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(30, 0, SCREEN_WIDTH-60, SCREEN_WIDTH-60)];
    imageView.centerY = self.bgView.centerY;
    imageView.image = self.image2.image;
    [self.bgView addSubview:imageView];
    [window addSubview:self.bgView];
    
    
}

- (void)tapAction3{
    
    if (self.bgView) {
        [self.bgView removeFromSuperview];
        return;
    }
    
    UIWindow *window = [[UIApplication sharedApplication].delegate window];
    self.bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    self.bgView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(removeBgAction)];
    [self.bgView addGestureRecognizer:tap];
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(30, 0, SCREEN_WIDTH-60, SCREEN_WIDTH-60)];
    imageView.centerY = self.bgView.centerY;
    imageView.image = self.image3.image;
    [self.bgView addSubview:imageView];
    [window addSubview:self.bgView];
}

- (void)removeBgAction{
    [self.bgView removeFromSuperview];
    self.bgView = nil;
}

- (void)showDetailWithData:(AnnounceModel *)model{
    [self.header sd_setImageWithURL:[NSURL URLWithString:model.icon]];
    self.name.text = model.userName;
    self.contents.text = model.detail;
    self.time.text = model.createtime;
    usercircleId = model.usercircleId;
    
    if ([model.ckCount integerValue]) {
        [self.likeButton setTitle:[NSString stringWithFormat:@"点赞(%@)", model.ckCount] forState:UIControlStateNormal];
    }
    else{
        [self.likeButton setTitle:@"点赞" forState:UIControlStateNormal];
    }
    
    UserTitle *userTitle = [Tools getPersonData];
    if ([userTitle.usersId isEqualToString:model.userId]) {
        self.delectButton.hidden = NO;
    }else{
        self.delectButton.hidden = YES;
    }
    
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

- (IBAction)delectAction:(id)sender {
    if ([self.delegate respondsToSelector:@selector(delectId:)]) {
        [_delegate delectId:usercircleId];
    }
}


- (IBAction)dianzan:(id)sender {
    if ([self.delegate respondsToSelector:@selector(dianzan)]) {
        [_delegate dianzan];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
