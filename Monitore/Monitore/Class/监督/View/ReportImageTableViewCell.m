//
//  ReportImageTableViewCell.m
//  Monitore
//
//  Created by kede on 2017/8/12.
//  Copyright © 2017年 kede. All rights reserved.
//

#import "ReportImageTableViewCell.h"

@interface ReportImageTableViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *photo1;
@property (weak, nonatomic) IBOutlet UIImageView *photo2;
@property (weak, nonatomic) IBOutlet UIImageView *photo3;

@end

@implementation ReportImageTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.photo2.hidden = YES;
    self.photo3.hidden = YES;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
    
    [self.photo1 addGestureRecognizer:tap];
    [self.photo2 addGestureRecognizer:tap];
    [self.photo3 addGestureRecognizer:tap];
}

- (void)displayCell{
    
}

- (void)tapAction:(UITapGestureRecognizer *)tap{
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
