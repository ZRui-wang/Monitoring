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

@interface AwardViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *listAry;


@end

@implementation AwardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"奖励兑换";
    [self leftCustomBarButton];
    [self rightCustomBarButton];
    
    self.listAry = [NSMutableArray array];
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"AwardTableViewCell" bundle:nil] forCellReuseIdentifier:@"AwardTableViewCell"];
    
    [self gitGiftList];
}

- (void)gitGiftList{
    
    UserTitle *title = [Tools getPersonData];
    
    [[DLAPIClient sharedClient] POST:@"giftList" parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"奖品=%@", responseObject);
        if ([responseObject[Kstatus]isEqualToString:Ksuccess]) {
            for (NSDictionary *dic in responseObject[@"dataList"]) {
                GiftListModel *model = [GiftListModel modelWithDictionary:dic];
                [self.listAry addObject:model];
            }
            [self.tableView reloadData];
        }else{
            [self showWarningMessage:@"数据错误"];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self showErrorMessage:@"网络错误"];
    }];
}

- (void)rightCustomBarButton{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"兑换记录" style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButtonAction)];
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor whiteColor];
}

- (void)rightBarButtonAction{
    ArardHistoryViewController *awardHistoryVc = [[ArardHistoryViewController alloc]init];
    [self.navigationController pushViewController:awardHistoryVc animated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.listAry.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    AwardTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AwardTableViewCell"];
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
    GiftListModel *model = self.listAry[indexPath.row];
    UserTitle *userTitle = [Tools getPersonData];
    NSDictionary *dic = @{@"USER_ID":userTitle.usersId, @"GIFT_ID":model.credit};
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
