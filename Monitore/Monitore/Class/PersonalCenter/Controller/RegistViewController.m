//
//  RegistViewController.m
//  Monitore
//
//  Created by kede on 2017/8/1.
//  Copyright © 2017年 kede. All rights reserved.
//

#import "RegistViewController.h"

@interface RegistViewController ()

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

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *buttonPositionX;
@end

@implementation RegistViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self leftCustomBarButton];
    
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
}

- (IBAction)commenUserBtnAction:(UIButton *)sender {
    sender.selected = !sender.isSelected;
    self.specialButton.selected = !sender.selected;
}

- (IBAction)sepcialBtnAction:(UIButton *)sender {
    sender.selected = !sender.isSelected;
    self.commenUserButton.selected = !sender.selected;
}
- (IBAction)registBtnAction:(UIButton *)sender {
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
