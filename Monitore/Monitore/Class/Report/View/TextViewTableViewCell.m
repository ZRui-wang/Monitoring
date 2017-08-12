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
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *plaseholdHeigh;

@end

@implementation TextViewTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.textView.delegate = self;
    self.textView.scrollEnabled = NO;
    self.textView.backgroundColor = [UIColor clearColor];
    [self.plaseholdLabel alignTop];
    self.plaseholdLabel.userInteractionEnabled = YES;
}

- (void)diaplayCell:(NSString *)title{
    self.title.text = title;
    
    if ([title isEqualToString:@"主题"]) {
        self.plaseholdLabel.text = @"限制20个汉字";
        self.plaseholdHeigh.constant = 21;
    }
    else{
        self.plaseholdLabel.text = @"为提高您提交的线索举报被采纳的可能性, 请尽可能详细的描述举报内容， 建议提交图片或视频以协助核查";
        self.plaseholdHeigh.constant = [Tools heightForTextWith:self.plaseholdLabel.text fontSize:14 width:SCREEN_WIDTH-15-10-8-40-15];
    }
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

- (void)textViewDidChange:(UITextView *)textView
{
    CGRect bounds = textView.bounds;
    // 计算 text view 的高度
    CGSize maxSize = CGSizeMake(bounds.size.width, CGFLOAT_MAX);
    CGSize newSize = [textView sizeThatFits:maxSize];
    bounds.size = newSize;
    textView.bounds = bounds;
    
    if ([_delegate respondsToSelector:@selector(finishEditHeigh:row:)]) {
        [_delegate finishEditHeigh:bounds.size.height + 17 row:self.cellRow];
    }
    // 让 table view 重新计算高度
    UITableView *tableView = [self tableView];
    [tableView beginUpdates];
    [tableView endUpdates];
    
    
}

- (UITableView *)tableView
{
    UIView *tableView = self.superview;
    while (![tableView isKindOfClass:[UITableView class]] && tableView) {
        tableView = tableView.superview;
    }
    return (UITableView *)tableView;
}

//- (void)textViewDidEndEditing:(UITextView *)textView{
//    if ([_delegate respondsToSelector:@selector(finishEditHeigh:row:)]) {
//        [_delegate finishEdit];
//    }
//}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
