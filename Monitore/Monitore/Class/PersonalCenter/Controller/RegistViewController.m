//
//  RegistViewController.m
//  Monitore
//
//  Created by kede on 2017/8/1.
//  Copyright © 2017年 kede. All rights reserved.
//

#import "RegistViewController.h"
#import "ProtocolViewController.h"

@interface RegistViewController ()<DLAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *verifyCodeTextField;
@property (weak, nonatomic) IBOutlet UITextField *secrityTextField;
@property (weak, nonatomic) IBOutlet UITextField *sureSecrityTextFeild;
@property (weak, nonatomic) IBOutlet UITextField *recommendCodeTextField;
@property (weak, nonatomic) IBOutlet UIButton *commenUserButton;
@property (weak, nonatomic) IBOutlet UIButton *specialButton;
@property (weak, nonatomic) IBOutlet UIView *recommendBgView;
@property (weak, nonatomic) IBOutlet UIView *sureBgView;
@property (weak, nonatomic) IBOutlet UIView *secriteBgView;
@property (weak, nonatomic) IBOutlet UIView *codeBgView;
@property (weak, nonatomic) IBOutlet UIView *phoneBgView;
@property (weak, nonatomic) IBOutlet UIButton *getCodeButton;
@property (weak, nonatomic) IBOutlet UIButton *protocolButton;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *buttonPositionX;

@property (nonatomic, copy) NSString *userType;

@property (nonatomic, strong)NSTimer *timer;

@property (nonatomic, copy) NSString *code;
@end

@implementation RegistViewController

- (void)dealloc{

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self leftCustomBarButton];
    
    self.userType = @"1";
    
    self.phoneBgView.layer.cornerRadius = 4;
    self.phoneBgView.layer.masksToBounds = YES;
    self.codeBgView.layer.cornerRadius = 4;
    self.codeBgView.layer.masksToBounds = YES;
    self.secriteBgView.layer.cornerRadius = 4;
    self.secriteBgView.layer.masksToBounds = YES;
    self.sureBgView.layer.masksToBounds =YES;
    self.sureBgView.layer.cornerRadius = 4;
    self.recommendBgView.layer.cornerRadius = 4;
    self.recommendBgView.layer.masksToBounds = YES;
    self.commenUserButton.selected = YES;
    self.specialButton.selected = NO;
    
    [self.getCodeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
//    dispatch_source_cancel(_timer);
//    [_timer invalidate];
//    _timer = nil;
}

- (IBAction)getCodeButtonAction:(UIButton *)sender {
    
    NSDictionary *dic = @{@"MOBILE":self.phoneTextField.text, @"TYPE":@0};
    
    __block typeof(self) weak = self;
    [[DLAPIClient sharedClient]POST:@"smsCode" parameters:dic success:^(NSURLSessionDataTask *task, id responseObject) {
        NSSLog(@"%@", responseObject);
        if ([responseObject[Kstatus]isEqualToString:Ksuccess]) {
           [self showSuccessMessage:@"验证码发送成功"];
            weak.code = responseObject[@"code"];
            [weak openCountdown];
            
            
        }else{
           [self showWarningMessage:responseObject[Kinfo]];
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self showWarningMessage:@"数据错误"];
    }];
    
}

- (IBAction)protocolBtnAction:(UIButton *)sender {
    ProtocolViewController *protocolVc = [[ProtocolViewController alloc]init];
    [self presentViewController:protocolVc animated:YES completion:nil];    
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


- (IBAction)commenUserBtnAction:(UIButton *)sender {
    sender.selected = !sender.isSelected;
    self.specialButton.selected = !sender.selected;
    self.userType = @"0";
    
    self.buttonPositionX.constant = 55;
    self.recommendBgView.hidden = YES;
}

- (IBAction)sepcialBtnAction:(UIButton *)sender {
    sender.selected = !sender.isSelected;
    self.commenUserButton.selected = !sender.selected;
    self.userType = @"1";
    
    self.buttonPositionX.constant = 85;
    self.recommendBgView.hidden = NO;
}
- (IBAction)registBtnAction:(UIButton *)sender {
    
    if (![self.verifyCodeTextField.text isEqualToString:self.code]) {
        [self showWarningMessage:@"验证码输入错误"];
        return;
    }
    
    if (![self.secrityTextField.text isEqualToString:self.sureSecrityTextFeild.text]) {
        [self showWarningMessage:@"两次输入的密码不一样"];
        return;
    }
    
    if (self.recommendCodeTextField.text.length ==0 && [self.userType isEqualToString:@"1"]) {
        [self showWarningMessage:@"请输入推荐码"];
        return;
    }
    
    NSDictionary *paraDic = @{@"USERNAME":self.phoneTextField.text,
                              @"PASSWORD":self.sureSecrityTextFeild.text,
                              @"TYPES":self.userType};
    
    [[DLAPIClient sharedClient]POST:@"regist" parameters:paraDic success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([responseObject[Kstatus] isEqualToString:Ksuccess]) {            
            DLAlertView *alertView = [[DLAlertView alloc]initWithTitle:@"提示" message:responseObject[Kinfo] delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alertView show];
            
        }
        else{
            [self showWarningMessage:responseObject[Kinfo]];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%@", task.currentRequest.URL);
        
    }];
    
}
- (IBAction)loginNowButtonAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)alertView:(DLAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    [self dismissViewControllerAnimated:YES completion:nil];
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
