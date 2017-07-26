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

@interface PersonalCenterVc ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong)NSArray *titleAry;

@end

@implementation PersonalCenterVc

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"个人中心";
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.scrollEnabled = NO;
    
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
        [self.navigationController pushViewController:personalDataVc animated:YES];
    }
    else if (indexPath.row == 1)
    {
        // 巡逻里程
        PatrolHistoryViewController *patrolHistoryVc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"PatrolHistoryViewController"];
        [self.navigationController pushViewController:patrolHistoryVc animated:YES];
    }
    else if (indexPath.row == 2)
    {
        // 消息中心
    }
    else if (indexPath.row == 3)
    {
        // 帮助中心
    }
    else if (indexPath.row == 4)
    {
        // 用户反馈
    }
    else
    {
        // 设置
    }
}


- (IBAction)quitButtonAction:(id)sender {
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
