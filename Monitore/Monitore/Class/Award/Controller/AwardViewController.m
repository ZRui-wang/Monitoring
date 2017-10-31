//
//  AwardViewController.m
//  Monitore
//
//  Created by kede on 2017/9/19.
//  Copyright © 2017年 kede. All rights reserved.
//

#import "AwardViewController.h"
#import "AwardTableViewCell.h"
#import "ArardHistoryViewController.h"
#import "UserTitle.h"
#import "GiftListModel.h"

@interface AwardViewController ()<UITableViewDataSource, UITableViewDelegate, DLAlertViewDelegate>

@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *listAry;


@end

@implementation AwardViewController{
    NSInteger row;
    BOOL isMoreData;
    BOOL isLoading;
    int pageIndex;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"奖励兑换";
    [self leftCustomBarButton];
    [self rightCustomBarButton];
    
    self.listAry = [NSMutableArray array];
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"AwardTableViewCell" bundle:nil] forCellReuseIdentifier:@"AwardTableViewCell"];
    self.tableView.tableFooterView = [UIView new];
    self.tableView.mj_header = [MJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(refresh)];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMore)];
    
    [self gitGiftList];
}


- (void)refresh{
    
    if (isLoading) {
        return;
    }
    isLoading = YES;
    pageIndex = 1;
    
    [self gitGiftList];
}

- (void)loadMore{
    if (!isMoreData) {
        [self endRefresh];
        return;
    }
    if (isLoading) {
        [self endRefresh];
        return;
    }
    isLoading = YES;
    [self gitGiftList];
}

- (void)endRefresh{
    isLoading = NO;
    [self.tableView.mj_footer endRefreshing];
    [self.tableView.mj_header endRefreshing];
}

- (void)gitGiftList{
    [[DLAPIClient sharedClient] POST:@"giftList" parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"奖品=%@", responseObject);
                
        
        if (pageIndex==1) {
            [self.listAry removeAllObjects];
        }
        
        pageIndex++;
        
        if ([[responseObject[@"page"]objectForKey:@"totalPage"] intValue] > pageIndex) {
            isMoreData = YES;
        }else{
            isMoreData = NO;
        }
        
        if ([responseObject[Kstatus]isEqualToString:Ksuccess]) {
            for (NSDictionary *dic in responseObject[@"dataList"]) {
                GiftListModel *model = [GiftListModel modelWithDictionary:dic];
                [self.listAry addObject:model];
            }
            [self.tableView reloadData];
        }else{
            [self showWarningMessage:@"数据错误"];
        }
        [self endRefresh];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self showErrorMessage:@"网络错误"];
        [self endRefresh];
    }];
}

- (void)rightCustomBarButton{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"兑换记录" style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButtonAction)];
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor whiteColor];
}

- (void)rightBarButtonAction{
    ArardHistoryViewController *collectVc = [[UIStoryboard storyboardWithName:@"Report" bundle:nil] instantiateViewControllerWithIdentifier:@"ArardHistoryViewController"];
    [self.navigationController pushViewController:collectVc animated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.listAry.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    AwardTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AwardTableViewCell"];
    [cell showDetailWithData:self.listAry[indexPath.row]];
    
    [cell.checkButton addTarget:self action:@selector(checkButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

}

- (void)checkButtonAction:(UIButton *)button{
   row = button.tag;
    DLAlertView *alertView = [[DLAlertView alloc]initWithTitle:@"提示" message:@"确定要兑换？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"兑换", nil];
    [alertView show];
}

- (void)alertView:(DLAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    GiftListModel *model = self.listAry[row];
    UserTitle *userTitle = [Tools getPersonData];
    NSDictionary *dic = @{@"USER_ID":userTitle.usersId, @"GIFT_ID":model.giftId};
    [[DLAPIClient sharedClient]POST:@"duihuan" parameters:dic     success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"%@", responseObject);
        if ([responseObject[Kstatus]isEqualToString:Ksuccess]) {
            [self showSuccessMessage:responseObject[Kinfo]];
        }else{
            [self showWarningMessage:responseObject[Kinfo]];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self showWarningMessage:@"数据错误"];
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
