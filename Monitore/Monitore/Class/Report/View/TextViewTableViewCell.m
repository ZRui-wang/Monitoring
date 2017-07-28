//
//  TextViewTableViewCell.m
//  Monitore
//
//  Created by kede on 2017/7/28.
//  Copyright © 2017年 kede. All rights reserved.
//

#import "TextViewTableViewCell.h"

@interface TextViewTableViewCell ()<UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *title;

@end

@implementation TextViewTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.textView.delegate = self;
    [self.plaseholdLabel alignTop];
    self.plaseholdLabel.text = @"haahahaahahahahha";
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];//按回车取消第一相应者
    }
    return YES;
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    self.plaseholdLabel.alpha = 0;//开始编辑时
    return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{//将要停止编辑(不是第一响应者时)
    if (textView.text.length == 0) {
        self.plaseholdLabel.alpha = 1;
    }
    return YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView{
    if ([_delegate respondsToSelector:@selector(finishEdit)]) {
        [_delegate finishEdit];
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
