//
//  UserFeedbackViewController.m
//  Monitore
//
//  Created by 小王 on 2017/8/10.
//  Copyright © 2017年 kede. All rights reserved.
//

#import "UserFeedbackViewController.h"

@interface UserFeedbackViewController ()
@property (weak, nonatomic) IBOutlet UITextView *textView;

@end

@implementation UserFeedbackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"用户反馈";
    [self leftCustomBarButton];
    self.textView.layer.borderWidth = 1;
    self.textView.layer.borderColor = [UIColor colorWithRed:29/255.0 green:136/255.0 blue:230/255.0 alpha:1].CGColor;
    self.textView.layer.cornerRadius = 4;
    self.textView.layer.masksToBounds = YES;
}

- (IBAction)commitButtonAction:(UIButton *)sender {
    if (!self.textView.text.length) {
        [self showWarningMessage:@"请输入反馈的内容"];
        return;
    }
    UserTitle *title = [Tools getPersonData];
    NSString *url = [NSString stringWithFormat:@"feedback?USER_ID=%@&CONTENT=%@", title.usersId, self.textView.text];
    url = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    [[DLAPIClient sharedClient]POST: url parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        [self showSuccessMessage:@"提交成功"];
        [self.navigationController popViewControllerAnimated:YES];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self showErrorMessage:@"网络错误"];
    }];
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
