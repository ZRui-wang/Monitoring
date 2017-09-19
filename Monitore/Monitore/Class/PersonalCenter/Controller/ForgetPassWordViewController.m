//
//  ForgetPassWordViewController.m
//  Monitore
//
//  Created by kede on 2017/8/21.
//  Copyright © 2017年 kede. All rights reserved.
//

#import "ForgetPassWordViewController.h"

@interface ForgetPassWordViewController ()
@property (weak, nonatomic) IBOutlet UITextField *phoneNumber;
@property (weak, nonatomic) IBOutlet UITextField *verfyCode;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UITextField *surePassword;
@property (weak, nonatomic) IBOutlet UIButton *getCodeButton;
@property (nonatomic, copy) NSString *code;

@end

@implementation ForgetPassWordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self leftCustomBarButton];
    self.title = @"忘记密码";
}
- (IBAction)commitButtonAction:(id)sender {
}
- (IBAction)getCodeButtonAction:(id)sender {
    
    NSDictionary *dic = @{@"MOBILE":self.phoneNumber.text, @"TYPE":@1};
    
    [[DLAPIClient sharedClient]POST:@"smsCode" parameters:dic success:^(NSURLSessionDataTask *task, id responseObject) {
        NSSLog(@"%@", responseObject);
        if ([responseObject[Kstatus]isEqualToString:Ksuccess]) {
            [self showSuccessMessage:@"验证码发送成功"];
            self.code = responseObject[@"code"];
            
        }else{
            [self showWarningMessage:responseObject[Kinfo]];
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self showWarningMessage:@"数据错误"];
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
