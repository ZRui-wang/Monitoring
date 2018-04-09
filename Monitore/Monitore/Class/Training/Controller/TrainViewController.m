//
//  TrainViewController.m
//  Monitore
//
//  Created by kede on 2017/9/19.
//  Copyright © 2017年 kede. All rights reserved.
//

#import "TrainViewController.h"
#import "TrainTableViewCell.h"
#import "TrainModel.h"
#import "DetailViewController.h"

@interface TrainViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)NSMutableArray *listAry;

@end

@implementation TrainViewController{
    int pageIndex;
    BOOL isNoMoreData;
    BOOL isLoadingMore;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"志愿者学习";
    [self leftCustomBarButton];
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"TrainTableViewCell" bundle:nil] forCellReuseIdentifier:@"TrainTableViewCell"];
    
    self.tableView.mj_header = [MJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(refresh)];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMore)];
    
    self.listAry = [NSMutableArray array];
    pageIndex = 1;
    [self getInfoList];
}

- (void)getInfoList{
    [[DLAPIClient sharedClient]POST:[NSString stringWithFormat:@"fppxList?currentPage=%d&showCount=10", pageIndex] parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([responseObject[Kstatus]isEqualToString:Ksuccess]) {
            
            if (pageIndex==1) {
                [self.listAry removeAllObjects];
            }
            
            pageIndex++;
            
            if (pageIndex<=[[responseObject[@"page"]objectForKey:@"totalPage"]intValue]) {
                isNoMoreData = NO;
            }else{
                isNoMoreData = YES;
            }
            
            for (NSDictionary *dic in responseObject[@"dataList"]) {
                TrainModel *model = [TrainModel modelWithDictionary:dic];
                [self.listAry addObject:model];
            }
            [self.tableView reloadData];
        }else
        {
            [self showErrorMessage:responseObject[Kinfo]];
        }
        [self endRefresh];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self showErrorMessage:@"网络错误"];
        [self endRefresh];
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.listAry.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TrainTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TrainTableViewCell"];
    [cell showDetailWithData:self.listAry[indexPath.row]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    DetailViewController *detailVc = [[UIStoryboard storyboardWithName:@"Announcement" bundle:nil] instantiateViewControllerWithIdentifier:@"DetailViewController"];
    
    TrainModel *model = self.listAry[indexPath.row];
    
    detailVc.infoId = model.newsId;
    
    [self.navigationController pushViewController:detailVc animated:YES];
}

- (void)refresh{
    if (isLoadingMore) {
        return;
    }
    pageIndex = 1;
    [self getInfoList];
}

- (void)loadMore{
    if (isLoadingMore) {
        return;
    }
    
    if (!isNoMoreData) {
        [self getInfoList];
    }else{
        [self endRefresh];
    }
}

- (void)endRefresh{
    isLoadingMore = NO;
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
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
