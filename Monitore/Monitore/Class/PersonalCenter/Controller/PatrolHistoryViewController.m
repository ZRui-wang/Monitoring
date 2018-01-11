//
//  PatrolHistoryViewController.m
//  Monitore
//
//  Created by kede on 2017/7/26.
//  Copyright © 2017年 kede. All rights reserved.
//

#import "PatrolHistoryViewController.h"
#import "PatrolHistoryTableViewCell.h"
#import "HistoryPatrolModel.h"

@interface PatrolHistoryViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
@property (strong, nonatomic) HistoryPatrolModel *model;

@end

@implementation PatrolHistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self leftCustomBarButton];
    self.title = @"巡逻里程";
    
    [self.tableView registerNib:[UINib nibWithNibName:@"PatrolHistoryTableViewCell" bundle:nil] forCellReuseIdentifier:@"PatrolHistoryTableViewCell"];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [UIView new];
    
    [self getData];
}

- (void)getData{
    
    UserTitle *title = [Tools getPersonData];
    
    [[DLAPIClient sharedClient]POST:[NSString stringWithFormat:@"userPatrol?USER_ID=%@", title.usersId] parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([responseObject[Kstatus]isEqualToString:@"202"]) {
            [self showWarningMessage:@"无数据"];
            self.nameLabel.hidden = YES;
            self.distanceLabel.hidden = YES;
        }
        
        if ([responseObject[Kstatus]isEqualToString:Ksuccess]) {
            self.model = [HistoryPatrolModel modelWithDictionary:responseObject];
            self.nameLabel.text = [NSString stringWithFormat:@"姓名：%@", self.model.name];
            self.distanceLabel.text = [NSString stringWithFormat:@"总里程数：%@km", self.model.allDistance];
            [self.tableView reloadData];
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self showErrorMessage:@"网络错误"];
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.model.dataList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 110;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PatrolHistoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PatrolHistoryTableViewCell" forIndexPath:indexPath];
    [cell showDetailModel:self.model.dataList[indexPath.row]];
    return cell;
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
