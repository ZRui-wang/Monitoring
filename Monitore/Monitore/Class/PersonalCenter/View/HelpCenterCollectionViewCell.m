//
//  HelpCenterCollectionViewCell.m
//  Monitore
//
//  Created by kede on 2017/8/11.
//  Copyright © 2017年 kede. All rights reserved.
//

#import "HelpCenterCollectionViewCell.h"

@interface HelpCenterCollectionViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *titleImage;
@property (weak, nonatomic) IBOutlet UILabel *title;

@end

@implementation HelpCenterCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)displayCell:(NSString *)title image:(NSString *)imageName{
    self.title.text = title;
    self.titleImage.image = [UIImage imageNamed:imageName];
}

@end
