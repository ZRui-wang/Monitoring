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

@interface AnnouncementViewController ()<UITableViewDelegate, UITableViewDataSource, DelectDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic)NSMutableArray *dataListAry;


@end

@implementation AnnouncementViewController{
    NSString *categoryId;
    
    int dataPage;
    BOOL isNoMoreData;
    BOOL moreData;
    BOOL isDownLoading;
    NSString *userCircleID;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self leftCustomBarButton];
    self.title = @"邻里守望";
    [self rightCustomBarButton];
    
    self.dataListAry = [NSMutableArray array];

    categoryId = @"1";

    [self.tableView registerNib:[UINib nibWithNibName:@"AnnouncementTableViewCell" bundle:nil] forCellReuseIdentifier:@"AnnouncementTableViewCell"];
    self.tableView.estimatedRowHeight = 50;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.tableFooterView = [UIView new];
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refresh)];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMore)];

}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];    
    dataPage = 1;
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
    UserTitle *title = [Tools getPersonData];
    [[DLAPIClient sharedClient]POST:[NSString stringWithFormat:@"userCircleList?currentPage=%d&showCount=10&USER_ID=%@", dataPage, title.usersId] parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
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
    cell.delegate = self;
//    [cell.delectButton addTarget:self action:@selector(delectButtonAction) forControlEvents:UIControlEventTouchUpInside];
    return cell;

}

- (void)delectId:(NSString *)userid{
    DLAlertView *alert = [[DLAlertView alloc]initWithTitle:@"提示" message:@"确定要删除吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    userCircleID = userid;
    [alert show];
}

-(void)alertView:(DLAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==1) {
        [[DLAPIClient sharedClient]POST:[NSString stringWithFormat:@"userCircleDel?USERCIRCLE_ID=%@", userCircleID] parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
            [self refresh];
            [self showSuccessMessage:@"删除成功"];
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            [self showErrorMessage:@"删除失败"];
        }];
    }
}

- (void)dianzan:(NSString *)detailId isLike:(BOOL)isLike{
        UserTitle *title = [Tools getPersonData];
    if (isLike) {
        [[DLAPIClient sharedClient]POST:[NSString stringWithFormat:@"clickUp?USER_ID=%@&USERCIRCLE_ID=%@", title.usersId, detailId] parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
            if ([responseObject[Kstatus]isEqualToString:Ksuccess]) {
                [self showSuccessMessage:@"点赞"];
                [self refresh];
            }
            else{
                [self showWarningMessage:responseObject[@"info"]];
            }
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            [self showErrorMessage:@"网络错误"];
        }];
    }
    else{
        [[DLAPIClient sharedClient]POST:[NSString stringWithFormat:@"clickDown?USER_ID=%@&USERCIRCLE_ID=%@", title.usersId, detailId] parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
            if ([responseObject[Kstatus]isEqualToString:Ksuccess]) {
                [self showSuccessMessage:@"取消"];
                [self refresh];
            }
            else{
                [self showWarningMessage:responseObject[@"info"]];
            }
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            [self showErrorMessage:@"网络错误"];
        }];
    }


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
