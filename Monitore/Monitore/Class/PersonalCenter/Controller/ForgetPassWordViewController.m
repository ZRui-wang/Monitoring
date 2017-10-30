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
        NSLog(@"%@", responseObject);
        if ([responseObject[Kstatus]isEqualToString:Ksuccess]) {
            [self showSuccessMessage:@"验证码发送成功"];
            self.code = responseObject[@"code"];
            [self openCountdown];
            
        }else{
            [self showWarningMessage:responseObject[Kinfo]];
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self showWarningMessage:@"数据错误"];
    }];
    
}

// 开启倒计时效果
-(void)openCountdown{
    
    __block NSInteger time = 59; //倒计时时间
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    
    dispatch_source_set_event_handler(_timer, ^{
        
        if(time <= 0){ //倒计时结束，关闭
            
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                
                //设置按钮的样式
                [self.getCodeButton setTitle:@"重新发送" forState:UIControlStateNormal];
                self.getCodeButton.userInteractionEnabled = YES;
            });
            
        }else{
            
            int seconds = time % 60;
            dispatch_async(dispatch_get_main_queue(), ^{
                
                //设置按钮显示读秒效果
                self.getCodeButton.userInteractionEnabled = NO;
                self.getCodeButton.titleLabel.text = [NSString stringWithFormat:@"已发送(%.2d)", seconds];
                [self.getCodeButton setTitle:[NSString stringWithFormat:@"已发送(%.2d)", seconds] forState:UIControlStateNormal];
                
            });
            time--;
        }
    });
    dispatch_resume(_timer);
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
