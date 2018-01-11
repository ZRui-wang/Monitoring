//
//  BlackListViewController.m
//  Monitore
//
//  Created by kede on 2017/9/19.
//  Copyright © 2017年 kede. All rights reserved.
//

#import "BlackListViewController.h"
#import "BlackListTableViewCell.h"
#import "BlackModel.h"
#import "DetailViewController.h"

@interface BlackListViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)NSMutableArray *listAry;

@end

@implementation BlackListViewController{
    int dataPage;
    BOOL isNoMoreData;
    BOOL moreData;
    BOOL isDownLoading;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"维稳黑名单";
    [self leftCustomBarButton];
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"BlackListTableViewCell" bundle:nil] forCellReuseIdentifier:@"BlackListTableViewCell"];

    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refresh)];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMore)];

    
    self.listAry  = [NSMutableArray array];
    dataPage = 1;
    [self getBlackListData];
}

- (void)getBlackListData{
    [[DLAPIClient sharedClient]POST:[NSString stringWithFormat:@"hmdList?currentPage=%d&showCount=10", dataPage] parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([responseObject[Kstatus]isEqualToString:Ksuccess]) {
            
            if (dataPage == 1) {
                [self.listAry removeAllObjects];
            }
            
            dataPage ++;
            
            if ([[responseObject[@"page"] objectForKey:@"totalPage"] intValue] <= dataPage) {
                isNoMoreData = YES;
            }else{
                isNoMoreData = NO;
            }
            
            for (NSDictionary *dic in responseObject[@"dataList"]) {
                BlackModel *model = [BlackModel modelWithDictionary:dic];
                [self.listAry addObject:model];
            }
            [self.tableView reloadData];
        }else{
            
        }
        [self endRefresh];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self endRefresh];
        [self showErrorMessage:@"网络错误"];
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.listAry.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    BlackListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BlackListTableViewCell"];
    [cell showDetailWithData:self.listAry[indexPath.row]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    DetailViewController *detailVc = [[UIStoryboard storyboardWithName:@"Announcement" bundle:nil] instantiateViewControllerWithIdentifier:@"DetailViewController"];
    
    BlackModel *model = self.listAry[indexPath.row];
    
    detailVc.infoId = model.newsId;
    
    [self.navigationController pushViewController:detailVc animated:YES];
}

- (void)refresh{
    if (isDownLoading) {
        return;
    }
    dataPage = 1;
    isDownLoading = YES;
    [self getBlackListData];
}

- (void)endRefresh {
    isDownLoading = NO;
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
}

- (void)loadMore{
    if (isDownLoading) {
        return;
    }
    
    if (!isNoMoreData) {
       [self getBlackListData];
    }
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
