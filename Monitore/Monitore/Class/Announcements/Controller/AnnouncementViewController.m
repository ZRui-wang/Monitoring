//
//  AnnouncementViewController.m
//  Monitore
//
//  Created by kede on 2017/7/27.
//  Copyright © 2017年 kede. All rights reserved.
//

#import "AnnouncementViewController.h"
#import "AnnouncementVcHeaderView.h"
#import "AnnouncementTableViewCell.h"
#import "PullTableViewCell.h"
#import "PullTableViewCell.h"
#import "DetailViewController.h"
#import "AnnounceListModel.h"
#import "PublishedViewController.h"

@interface AnnouncementViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic)NSMutableArray *dataListAry;


@end

@implementation AnnouncementViewController{
    NSString *categoryId;
    
    int dataPage;
    BOOL isNoMoreData;
    BOOL moreData;
    BOOL isDownLoading;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self leftCustomBarButton];
    self.title = @"邻里守望公告";
    [self rightCustomBarButton];
    
    self.dataListAry = [NSMutableArray array];

    categoryId = @"1";

    [self.tableView registerNib:[UINib nibWithNibName:@"AnnouncementTableViewCell" bundle:nil] forCellReuseIdentifier:@"AnnouncementTableViewCell"];
    self.tableView.estimatedRowHeight = 50;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.tableFooterView = [UIView new];
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refresh)];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMore)];

    dataPage = 1;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];    
    [self getNetWorkData];
}

- (void)rightCustomBarButton{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"+发表" style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButtonAction)];
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor whiteColor];
}

- (void)rightBarButtonAction{
    PublishedViewController *publishedVc = [[UIStoryboard storyboardWithName:@"Announcement" bundle:nil]instantiateViewControllerWithIdentifier:@"PublishedViewController"];
    [self.navigationController pushViewController:publishedVc animated:YES];
}

- (void)getNetWorkData{
    [[DLAPIClient sharedClient]POST:[NSString stringWithFormat:@"userCircleList?currentPage=%d&showCount=10", dataPage] parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"%@", responseObject);
        if ([responseObject[Kstatus]isEqualToString:@"200"]) {
            
            if (dataPage == 1) {
                [self.dataListAry removeAllObjects];
            }
            
            dataPage ++;
            
            if ([[responseObject[@"page"] objectForKey:@"totalPage"] intValue] < dataPage) {
                isNoMoreData = YES;
            }else{
                isNoMoreData = NO;
            }

            AnnounceListModel *model = [AnnounceListModel modelWithDictionary:responseObject];
            [self.dataListAry addObjectsFromArray:model.dataList];
            [self.tableView reloadData];
        }else{
            [self showErrorMessage:responseObject[Kinfo]];
        }
        [self endRefresh];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%@", error);
        [self showErrorMessage:@"网络错误"];
        [self endRefresh];
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return   self.dataListAry.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    AnnouncementTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AnnouncementTableViewCell" forIndexPath:indexPath];
    [cell showDetailWithData:self.dataListAry[indexPath.row]];
    return cell;

}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    DetailViewController *detailVc = [[DetailViewController alloc]init];
    [self.navigationController pushViewController:detailVc animated:YES];
}


- (void)refresh{
    if (isDownLoading) {
        return;
    }
    dataPage = 1;
    isDownLoading = YES;
    [self getNetWorkData];
}

- (void)endRefresh {
    isDownLoading = NO;
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
}

- (void)loadMore{
    if (isDownLoading) {
        [self endRefresh];
        return;
    }
    
    if (!isNoMoreData) {
        [self getNetWorkData];
    }
    else{
        [self endRefresh];
    }
}


- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter]removeObserver:self];
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
