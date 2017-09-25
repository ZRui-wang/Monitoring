//
//  PersonalDataTableViewCell.m
//  Monitore
//
//  Created by kede on 2017/7/26.
//  Copyright © 2017年 kede. All rights reserved.
//

#import "PersonalDataTableViewCell.h"

@interface PersonalDataTableViewCell ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *skipTitle;
@property (weak, nonatomic) IBOutlet UIImageView *skipImage;
@property (weak, nonatomic) IBOutlet UITextField *textField;

@property (strong, nonatomic)NSArray *titleAry;

@end

@implementation PersonalDataTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    NSArray *titleTempAry = @[@"当前账号:", @"真实姓名:", @"性别:", @"群防力量类型:", @"身份证号:", @"职业:", @"单位及职务:", @"推荐人手机号:", @"", @"申请时间:", @"所属地区:", @"常住地址:"];
    self.titleAry = titleTempAry;
    self.textField.delegate = self;
    self.textField.tag = self.indexPath.section*9 + self.indexPath.row;
}

- (void)textFieldDidEndEditing:(UITextField *)textField reason:(UITextFieldDidEndEditingReason)reason{
    if ([_delegate respondsToSelector:@selector(buildInfoRow:info:)]) {
        [_delegate buildInfoRow:self.indexPath.section*10+self.indexPath.row info:textField.text];
    }
}

- (void)displayCellWithData:(NSDictionary *)dic andIndexpath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        self.title.text = self.titleAry[indexPath.row];
        if (indexPath.row == 0) {
            self.skipTitle.text = @"修改手机号";
            self.skipTitle.hidden = YES;
            self.skipImage.hidden = YES;
            
            self.textField.text = self.mobile;
            self.textField.userInteractionEnabled = NO;
        }
        else if (indexPath.row == 2) {
            self.skipTitle.hidden = YES;
            self.skipImage.hidden = YES;
            self.textField.text = self.titleValue;
        }
        else if (indexPath.row == 3) {
            self.skipTitle.text = @"修改类型";
            self.skipTitle.hidden = YES;
            self.skipImage.hidden = YES;
            self.textField.text = self.titleValue;
            self.textField.userInteractionEnabled = NO;
            
        }
        else if (indexPath.row == 9) {
            self.textField.text = self.date;
            self.textField.userInteractionEnabled = NO;
        }else{
            self.textField.text = self.titleValue;
        }

    }
    else
    {
        self.title.text = self.titleAry[indexPath.row + 10];
        self.textField.text = self.titleValue;
        self.textField.userInteractionEnabled = YES;
        if (indexPath.row == 1) {
            self.skipTitle.text = @"修改";
            self.skipTitle.hidden = YES;
            self.skipImage.hidden = YES;
        }
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
