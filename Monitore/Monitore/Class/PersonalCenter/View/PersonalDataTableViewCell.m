//
//  PersonalDataTableViewCell.m
//  Monitore
//
//  Created by kede on 2017/7/26.
//  Copyright © 2017年 kede. All rights reserved.
//

#import "PersonalDataTableViewCell.h"

@interface PersonalDataTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *titleDetail;
@property (weak, nonatomic) IBOutlet UILabel *skipTitle;
@property (weak, nonatomic) IBOutlet UIImageView *skipImage;

@property (strong, nonatomic)NSArray *titleAry;

@end

@implementation PersonalDataTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    NSArray *titleTempAry = @[@"当前账号:", @"真实姓名:", @"性别:", @"群防力量类型:", @"身份证号:", @"职业:", @"单位及职务:", @"推荐人手机号:", @"", @"申请时间:", @"所属地区:", @"注册派出所:", @"常住地址:"];
    self.titleAry = titleTempAry;
}

- (void)displayCellWithData:(NSDictionary *)dic andIndexpath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        self.title.text = self.titleAry[indexPath.row];
        if (indexPath.row == 0) {
            self.skipTitle.text = @"修改手机号";
            self.skipTitle.hidden = YES;
            self.skipImage.hidden = YES;
        }
        if (indexPath.row == 3) {
            self.skipTitle.text = @"修改类型";
            self.skipTitle.hidden = YES;
            self.skipImage.hidden = YES;
        }
    }
    else
    {
        self.title.text = self.titleAry[indexPath.row + 10];
        if (indexPath.row == 1) {
            self.skipTitle.text = @"修改";
            self.skipTitle.hidden = NO;
            self.skipImage.hidden = NO;
        }
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
