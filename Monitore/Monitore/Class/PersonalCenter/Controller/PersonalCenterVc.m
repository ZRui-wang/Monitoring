//
//  PersonalCenterVc.m
//  Monitore
//
//  Created by kede on 2017/7/26.
//  Copyright © 2017年 kede. All rights reserved.
//

#import "PersonalCenterVc.h"
#import "PersonalCenterTableViewCell.h"
#import "PersonalDataViewController.h"
#import "PatrolHistoryViewController.h"
#import "SettingViewController.h"
#import "HelpCenterViewController.h"
#import "UserFeedbackViewController.h"
#import "UserTitle.h"
#import "UserModel.h"
#import "InfoViewController.h"

@interface PersonalCenterVc ()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UIImageView *userHeader;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *stars;
@property (weak, nonatomic) IBOutlet UILabel *scores;
@property (nonatomic, strong)NSArray *titleAry;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (nonatomic, strong) UserTitle *userTitle;
@property (nonatomic, strong) UserModel *model;

@end

@implementation PersonalCenterVc

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"个人中心";
    [self leftCustomBarButton];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.scrollEnabled = NO;
    
    NSData *myEncodedObject = [[NSUserDefaults standardUserDefaults]objectForKey:@"userTitle"];

    NSKeyedUnarchiver *unArchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:myEncodedObject];
    // 解码返回一个对象
    self.userTitle = [unArchiver decodeObjectForKey:@"userTitle"]; // 此时调用反归档方法initWithCoder:
    // 反归档完成
    [unArchiver finishDecoding];

    self.userName.text = self.userTitle.mobile;
    self.stars.text = [NSString stringWithFormat:@"%ld", self.userTitle.stars];
    self.scores.text = [NSString stringWithFormat:@"%ld", self.userTitle.score];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"PersonalCenterTableViewCell" bundle:nil] forCellReuseIdentifier:@"PersonalCenterTableViewCell"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    
    NSArray *titleTemptAry = @[@{@"titleImage":@"个人资料",
                            @"title":@"个人资料"},
                          @{@"titleImage":@"巡逻里程",
                            @"title":@"巡逻里程"},
                          @{@"titleImage":@"消息中心",
                            @"title":@"消息中心"},
                          @{@"titleImage":@"帮助中心",
                            @"title":@"帮助中心"},
                          @{@"titleImage":@"用户反馈",
                            @"title":@"用户反馈"},
                          @{@"titleImage":@"设置",
                            @"title":@"设置"}];
    self.titleAry = titleTemptAry;
    
    [self requestNetWork];
}

- (void)requestNetWork{
    NSDictionary *dic = @{@"ID":self.userTitle.usersId};
    [[DLAPIClient sharedClient]POST:@"getUserInfo" parameters:dic success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"%@", responseObject);
        if ([responseObject[Kstatus]isEqualToString:Ksuccess]) {
            self.model = [UserModel modelWithDictionary:responseObject[@"user"]];
            self.model.mobile = self.userTitle.mobile;
            self.userName.text = self.model.nickname;
            self.address.text = self.model.address;
            self.stars.text = self.model.stars;
            self.score.text = self.model.score;
            self.phoneNo.text = self.model.mobile;
            self.nameLabel.text = self.model.nickname;
            [self.userHeader sd_setImageWithURL:[NSURL URLWithString:self.model.icon]];
        }else{
            
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}

#pragma mark - UITableViewDatasouse
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 6;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return ((SCREEN_HEIGHT-64)*0.5)/6.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PersonalCenterTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PersonalCenterTableViewCell" forIndexPath:indexPath];
    [cell displyCellDetailWithData:[self.titleAry objectAtIndexCheck:indexPath.row]];
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        // 个人资料
        PersonalDataViewController *personalDataVc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"PersonalDataViewController"];
        personalDataVc.model = self.model;
        [self.navigationController pushViewController:personalDataVc animated:YES];
    }
    else if (indexPath.row == 1)
    {
        // 巡逻里程
        PatrolHistoryViewController *patrolHistoryVc = [[UIStoryboard storyboardWithName:@"PersonalCenter" bundle:nil]instantiateViewControllerWithIdentifier:@"PatrolHistoryViewController"];
        [self.navigationController pushViewController:patrolHistoryVc animated:YES];
    }
    else if (indexPath.row == 2)
    {
        // 消息中心
        InfoViewController *infoVc = [[InfoViewController alloc]init];
        [self.navigationController pushViewController:infoVc animated:YES];
        
    }
    else if (indexPath.row == 3)
    {
        // 帮助中心
        HelpCenterViewController *helpCenterVc = [[UIStoryboard storyboardWithName:@"PersonalCenter" bundle:nil]instantiateViewControllerWithIdentifier:@"HelpCenterViewController"];
        [self.navigationController pushViewController:helpCenterVc animated:YES];
    }
    else if (indexPath.row == 4)
    {
        // 用户反馈
        UserFeedbackViewController *userFeedbackVc = [[UIStoryboard storyboardWithName:@"PersonalCenter" bundle:nil]instantiateViewControllerWithIdentifier:@"UserFeedbackViewController"];
        [self.navigationController pushViewController:userFeedbackVc animated:YES];

    }
    else
    {
        // 设置
        SettingViewController *settingVc = [[UIStoryboard storyboardWithName:@"PersonalCenter" bundle:nil]instantiateViewControllerWithIdentifier:@"SettingViewController"];
        [self.navigationController pushViewController:settingVc animated:YES];
    }
}


- (IBAction)quitButtonAction:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
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
