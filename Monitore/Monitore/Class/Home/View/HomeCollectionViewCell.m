//
//  HomeCollectionViewCell.m
//  Monitore
//
//  Created by kede on 2017/7/24.
//  Copyright © 2017年 kede. All rights reserved.
//

#import "HomeCollectionViewCell.h"

@interface HomeCollectionViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UIImageView *titleImage;

@end

@implementation HomeCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)displayCellWithData:(NSString *)title
{
    self.title.text = title;
    self.titleImage.image = [UIImage imageNamed:title];
}

@end
