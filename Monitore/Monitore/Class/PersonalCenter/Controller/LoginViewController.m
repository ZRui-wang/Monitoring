//
//  LoginViewController.m
//  Monitore
//
//  Created by 小王 on 2017/7/31.
//  Copyright © 2017年 kede. All rights reserved.
//

#import "LoginViewController.h"
#import "RegistViewController.h"
#import "HomeViewController.h"
#import "ForgetPassWordViewController.h"

@interface LoginViewController ()<UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UIView *nameBgView;
@property (weak, nonatomic) IBOutlet UIView *passWorldBgView;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self leftCustomBarButton];
    self.nameBgView.layer.cornerRadius = self.nameBgView.self.frame.size.height/2.0;
    self.nameBgView.layer.masksToBounds = YES;
    self.passWorldBgView.layer.cornerRadius = self.passWorldBgView.self.frame.size.height/2.0;
    self.passWorldBgView.layer.masksToBounds = YES;
    
    self.loginButton.layer.cornerRadius = self.loginButton.frame.size.height/2.0;
    self.loginButton.layer.masksToBounds = YES;
    
    // 设置导航控制器的代理为self
    self.navigationController.delegate = self;
}

- (IBAction)loginButtonAction:(id)sender {
    HomeViewController *homeVc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"HomeViewController"];
    [self.navigationController pushViewController:homeVc animated:YES];
}

- (IBAction)forgetButtonAction:(id)sender {
    ForgetPassWordViewController *forgetPassWordVc = [[UIStoryboard storyboardWithName:@"PersonalCenter" bundle:nil] instantiateViewControllerWithIdentifier:@"ForgetPassWordViewController"];
    [self.navigationController pushViewController:forgetPassWordVc animated:YES];
//    [self presentViewController:forgetPassWordVc animated:YES completion:nil];
    
}

- (IBAction)registButtonAction:(id)sender {
    RegistViewController *registVc = [[UIStoryboard storyboardWithName:@"PersonalCenter" bundle:nil]instantiateViewControllerWithIdentifier:@"RegistViewController"];
    [self presentViewController:registVc animated:YES completion:nil];
//    [self.navigationController pushViewController:registVc animated:YES];
}

#pragma mark - UINavigationControllerDelegate
// 将要显示控制器
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    // 判断要显示的控制器是否是自己
    BOOL isShowHomePage = [viewController isKindOfClass:[self class]];
    
    [self.navigationController setNavigationBarHidden:isShowHomePage animated:YES];
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
