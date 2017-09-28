//
//  TaskViewController.m
//  Monitore
//
//  Created by 小王 on 2017/8/14.
//  Copyright © 2017年 kede. All rights reserved.
//

#import "MyTaskViewController.h"
#import "TaskTableViewCell.h"
#import "TXTimeSelectorViewController.h"
#import "TaskListModel.h"
#import "TaskDetailViewController.h"
#import "UserTitle.h"

@interface MyTaskViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *listAry;

@end

@implementation MyTaskViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"我的任务";
    [self leftCustomBarButton];
    [self getTaskList];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"TaskTableViewCell" bundle:nil] forCellReuseIdentifier:@"TaskTableViewCell"];
    self.tableView.tableFooterView = [UIView new];
    
    _listAry = [NSMutableArray array];
}

- (void)getTaskList{
    
    UserTitle *model = [Tools getPersonData];
    
    NSDictionary *dic = @{@"USER_ID":model.usersId, @"LAT":self.lon, @"LNG":self.lat};
    
    [[DLAPIClient sharedClient]POST:@"myTaskList" parameters:dic success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([responseObject[Kstatus]isEqualToString:Ksuccess]) {
            for (NSDictionary *dic in responseObject[@"dataList"]) {
                TaskListModel *model = [TaskListModel modelWithDictionary:dic];
                [self.listAry addObject:model];
            }
            [self.tableView reloadData];
        }else{
            [self showErrorMessage:responseObject[Kinfo]];
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self showErrorMessage:@"数据错误"];
    }];
}

- (void)creatPickView{
    TXTimeSelectorViewController *tc = [[TXTimeSelectorViewController alloc]initWithShowFrame:CGRectMake(0, 104, SCREEN_WIDTH , SCREEN_HEIGHT/2) ShowStyle:MYPresentedViewShowStyleFromTopSpreadStyle callback:^(NSString  *result) {
        NSLog(@"time --> %@",result);
        //        [self.btn setTitle:result forState:UIControlStateNormal];
    }];
    tc.mode = UIDatePickerModeDateAndTime;
    [self presentViewController:tc animated:YES completion:nil];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.listAry.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 170;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TaskTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TaskTableViewCell" forIndexPath:indexPath];
    [cell showDetailWithData:self.listAry[indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    TaskListModel *model = self.listAry[indexPath.row];
    
    TaskDetailViewController *taskDetailVc = [[UIStoryboard storyboardWithName:@"Announcement" bundle:nil]instantiateViewControllerWithIdentifier:@"TaskDetailViewController"];
    taskDetailVc.isMyTask = YES;
    taskDetailVc.lat = self.lon;
    taskDetailVc.lon = self.lat;
    taskDetailVc.ID = model.taskId;
    [self.navigationController pushViewController:taskDetailVc animated:YES];
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
