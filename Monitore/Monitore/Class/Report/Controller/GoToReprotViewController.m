//
//  GoToReprotViewController.m
//  Monitore
//
//  Created by kede on 2017/7/27.
//  Copyright © 2017年 kede. All rights reserved.
//

#import "GoToReprotViewController.h"
#import "GoToReportTableViewCell.h"
#import "TextViewTableViewCell.h"

@interface GoToReprotViewController ()<UITableViewDataSource, UITableViewDelegate, UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic)UITextView *textView;

@end

@implementation GoToReprotViewController
{
    CGFloat titleHeigh;
    CGFloat detailHeigh;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self leftCustomBarButton];
    self.title = @"我要举报";
    
    [self.tableView registerNib:[UINib nibWithNibName:@"GoToReportTableViewCell" bundle:nil] forCellReuseIdentifier:@"GoToReportTableViewCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"TextViewTableViewCell" bundle:nil] forCellReuseIdentifier:@"TextViewTableViewCell"];
    
    titleHeigh = 40;
    detailHeigh = 80;
    
}

- (void)textViewDidEndEditing:(UITextView *)textView{
    if (textView.tag == 2) {
        // 标题
        titleHeigh = [Tools heightForTextWith:textView.text fontSize:14 width:SCREEN_WIDTH-90];
    }
    else{
        // 描述
        detailHeigh = [Tools heightForTextWith:textView.text fontSize:14 width:SCREEN_WIDTH-90];
    }
    
    [self.tableView reloadData];
    
}
//
//- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
//    if ([text isEqualToString:@"\n"]) {
//        [textView resignFirstResponder];//按回车取消第一相应者
//    }
//    return YES;
//}
//
//- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
//{
//    self.plaseholdLabel.alpha = 0;//开始编辑时
//    return YES;
//}
//
//- (BOOL)textViewShouldEndEditing:(UITextView *)textView
//{//将要停止编辑(不是第一响应者时)
//    if (textView.text.length == 0) {
//        self.plaseholdLabel.alpha = 1;
//    }
//    return YES;
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row < 2) {
        return 40;
    }
    else if(indexPath.row == 2){
        return titleHeigh;
    }
    else if(indexPath.row == 3){
        return detailHeigh;
    }
    else{
        return 10;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < 2) {
        GoToReportTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GoToReportTableViewCell" forIndexPath:indexPath];
        return cell;
    }
    else{
        TextViewTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TextViewTableViewCell" forIndexPath:indexPath];
//        self.textView = cell.textView;
//        self.textView.delegate = self;
//        self.textView.tag = indexPath.row;
        
//        if (indexPath.row == 2) {
//            cell.textView.text = @"限制20个字";
//        }
//        else{
//            cell.textView.text = @"为提高您提交的线索举报被采纳的可能性， 请尽可能详细地地描述举报内容， 建议提交图片或者视频以协助核查";
//        }
        
        return cell;
    }
}

- (IBAction)saveButtonAction:(id)sender {
}

- (IBAction)submitButtonAction:(id)sender {
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
