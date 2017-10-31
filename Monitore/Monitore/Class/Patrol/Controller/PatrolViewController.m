//
//  PatrolViewController.m
//  Monitore
//
//  Created by kede on 2017/7/26.
//  Copyright © 2017年 kede. All rights reserved.
//

#import "PatrolViewController.h"
#import "PatrolTableViewCell.h"
#import "PatrolTableHeaderView.h"
#import "GoToPatrolViewController.h"
#import "PatrolTrajectoryViewController.h"
#import "PatrolListModel.h"

@interface PatrolViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *patrolListAry;

@end

@implementation PatrolViewController{
    int pageIndex;
    BOOL isMoreData;
    BOOL isLoading;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self leftCustomBarButton];
    self.title = @"巡逻记录";
    
    self.patrolListAry = [NSMutableArray array];
    pageIndex = 1;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"PatrolTableViewCell" bundle:nil] forCellReuseIdentifier:@"PatrolTableViewCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"PatrolTableHeaderView" bundle:nil] forHeaderFooterViewReuseIdentifier:@"PatrolTableHeaderView"];
    self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    self.tableView.mj_header = [MJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(refresh)];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMore)];
        
    self.userTitle = [Tools getPersonData];
}

- (void)refresh{
    
    if (isLoading) {
        return;
    }
    isLoading = YES;
    pageIndex = 1;
    
    [self getPatrolHistory];
}

- (void)loadMore{
    if (!isMoreData) {
        return;
    }
    if (isLoading) {
        return;
    }
    isLoading = YES;
    [self getPatrolHistory];
}

- (void)endRefresh{
    isLoading = NO;
    [self.tableView.mj_footer endRefreshing];
    [self.tableView.mj_header endRefreshing];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.patrolListAry removeAllObjects];
    [self getPatrolHistory];
}

- (void)getPatrolHistory{
    [[DLAPIClient sharedClient]POST:[NSString stringWithFormat:@"userPatrol?USER_ID=%@&currentPage=%d&showCount=10", self.userTitle.usersId, pageIndex] parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"%@", responseObject);
        
        if (pageIndex==1) {
            [self.patrolListAry removeAllObjects];
        }
        
        pageIndex++;
        
        if ([[responseObject[@"page"]objectForKey:@"totalPage"] intValue] > pageIndex) {
            isMoreData = YES;
        }else{
            isMoreData = NO;
        }
        
        if ([responseObject[Kstatus] isEqualToString:Ksuccess]) {
            for (NSDictionary *dic in responseObject[@"dataList"]) {
                PatrolListModel *model = [PatrolListModel modelWithDictionary:dic];
                [self.patrolListAry addObject:model];
            }
            [self.tableView reloadData];
        }else if ([responseObject[Kstatus] isEqualToString:@"404"]  ){
            
        }else{
            
        }
        [self endRefresh];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self endRefresh];
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.patrolListAry.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 60;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PatrolTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PatrolTableViewCell" forIndexPath:indexPath];
    
    [cell showDetailWithModel:self.patrolListAry[indexPath.row]];
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    PatrolTableHeaderView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"PatrolTableHeaderView"];
    return view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PatrolTrajectoryViewController *patrolTrajectoryVc = [[UIStoryboard storyboardWithName:@"Patrol" bundle:nil]instantiateViewControllerWithIdentifier:@"PatrolTrajectoryViewController"];
    
    PatrolListModel *model = self.patrolListAry[indexPath.row];
    patrolTrajectoryVc.patrolID = model.patrolId;
    patrolTrajectoryVc.startTime = model.startTime;
    patrolTrajectoryVc.endTime = model.endTime;
    patrolTrajectoryVc.startAddr = model.startAddress;
    patrolTrajectoryVc.title = model.title;
    patrolTrajectoryVc.name = model.name;
    [self.navigationController pushViewController:patrolTrajectoryVc animated:YES];
}

- (IBAction)goToPatrolAction:(id)sender {
    
    GoToPatrolViewController *goToPatrolVc = [[UIStoryboard storyboardWithName:@"Patrol" bundle:nil]instantiateViewControllerWithIdentifier:@"GoToPatrolViewController"];
    [self.navigationController pushViewController:goToPatrolVc animated:YES];
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
