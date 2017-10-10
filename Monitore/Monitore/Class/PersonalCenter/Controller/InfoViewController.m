//
//  InfoViewController.m
//  Monitore
//
//  Created by kede on 2017/10/10.
//  Copyright © 2017年 kede. All rights reserved.
//

#import "InfoViewController.h"
#import "BlackListTableViewCell.h"
#import "BlackModel.h"
#import "DetailViewController.h"
#import "UserTitle.h"

@interface InfoViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)NSMutableArray *listAry;

@end

@implementation InfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"消息列表";
    [self leftCustomBarButton];
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"BlackListTableViewCell" bundle:nil] forCellReuseIdentifier:@"BlackListTableViewCell"];
    
    self.listAry  = [NSMutableArray array];
    [self getBlackListData];
}

- (void)getBlackListData{
    
    UserTitle *title = [Tools getPersonData];
    
    NSDictionary *dic = @{@"USER_ID":title.usersId};
    
    [[DLAPIClient sharedClient]POST:@"creditLogList" parameters:dic success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([responseObject[Kstatus]isEqualToString:Ksuccess]) {
            for (NSDictionary *dic in responseObject[@"dataList"]) {
                BlackModel *model = [BlackModel modelWithDictionary:dic];
                [self.listAry addObject:model];
            }
            [self.tableView reloadData];
        }else{
            
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
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
