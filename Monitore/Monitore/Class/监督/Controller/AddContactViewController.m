//
//  AddContactViewController.m
//  Monitore
//
//  Created by kede on 2017/9/14.
//  Copyright © 2017年 kede. All rights reserved.
//

#import "AddContactViewController.h"

@interface AddContactViewController ()
@property (weak, nonatomic) IBOutlet UITextField *name;
@property (weak, nonatomic) IBOutlet UITextField *phoneNumber;

@end

@implementation AddContactViewController

- (void)dealloc{
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"紧急联系人";
    [self leftCustomBarButton];
    
    self.name.text = self.linkerModel.urgentLinkman;
    self.phoneNumber.text = self.linkerModel.urgentMobile;
    
}
- (IBAction)saveButtonAction:(id)sender {
    UserTitle *title = [Tools getPersonData];
    NSDictionary *dic = @{@"ID":title.usersId, @"URGENT_LINKMAN":self.name.text, @"URGENT_MOBILE":self.phoneNumber.text};
    
    [[DLAPIClient sharedClient]POST:@"editUngentLink" parameters:dic success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([responseObject[Kstatus]isEqualToString:Ksuccess]) {
            [self showSuccessMessage:@"添加成功"];
            
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 2 * NSEC_PER_SEC);
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                // do something
                            [self.navigationController popViewControllerAnimated:YES];
            });
        }
        else
        {
            [self showSuccessMessage:@"添加失败"];
        }
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
