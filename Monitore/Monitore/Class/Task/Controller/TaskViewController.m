//
//  TaskViewController.m
//  Monitore
//
//  Created by 小王 on 2017/8/14.
//  Copyright © 2017年 kede. All rights reserved.
//

#import "TaskViewController.h"
#import "TaskTableViewCell.h"
#import "TaskHeaderView.h"
#import "TXTimeSelectorViewController.h"
#import "TaskListModel.h"
#import "TaskDetailViewController.h"
#import "MyTaskViewController.h"
#import "categoryModel.h"

@interface TaskViewController ()<UITableViewDelegate, UITableViewDataSource, TaskHeaderViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *listAry;
@property (strong, nonatomic) NSMutableArray *categoryList;
@property (copy, nonatomic) NSString *lon;
@property (copy, nonatomic) NSString *lat;

@end

@implementation TaskViewController{
    
    int dataPage;
    BOOL isNoMoreData;
    BOOL moreData;
    BOOL isDownLoading;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"群防任务";
    [self leftCustomBarButton];
    [self rightCustomBarButton];
    
    dataPage = 1;
    
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 100)];
    
    
    TaskHeaderView *headerView1 = [TaskHeaderView xibView];
    headerView1.delegate = self;
    headerView1.frame = CGRectMake(0, 0, SCREEN_WIDTH, 100);
    
    __block typeof(self) weak = self;
    [[Tools sharedTools]getCurrentAddress:^(NSString *address) {
        headerView1.addressLabel.text = address;
        [weak getGeoCoedAddress:address];
    }];
    
    [headerView addSubview:headerView1];

    self.tableView.tableHeaderView = headerView;
    [self.tableView registerNib:[UINib nibWithNibName:@"TaskTableViewCell" bundle:nil] forCellReuseIdentifier:@"TaskTableViewCell"];
    self.tableView.tableFooterView = [UIView new];
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refresh)];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMore)];
    
    _listAry = [NSMutableArray array];
    _categoryList = [NSMutableArray array];
}

- (void)rightCustomBarButton{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"我的任务" style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButtonAction)];
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor whiteColor];
}

- (void)rightBarButtonAction{
    MyTaskViewController *taskVc = [[UIStoryboard storyboardWithName:@"Announcement" bundle:nil]instantiateViewControllerWithIdentifier:@"MyTaskViewController"];
    taskVc.lon = self.lon;
    taskVc.lat = self.lat;
    [self.navigationController pushViewController:taskVc animated:YES];
}


- (void)getGeoCoedAddress:(NSString *)address{
    CLGeocoder *myGeocoder = [[CLGeocoder alloc] init];
    [myGeocoder geocodeAddressString:address completionHandler:^(NSArray *placemarks, NSError *error) {
        if ([placemarks count] > 0 && error == nil) {
            NSLog(@"Found %lu placemark(s).", (unsigned long)[placemarks count]);
            CLPlacemark *firstPlacemark = [placemarks objectAtIndex:0];
            NSLog(@"Longitude = %f", firstPlacemark.location.coordinate.longitude);
            NSLog(@"Latitude = %f", firstPlacemark.location.coordinate.latitude);
            
            self.lon = [NSString stringWithFormat:@"%f", firstPlacemark.location.coordinate.longitude];
            self.lat = [NSString stringWithFormat:@"%f", firstPlacemark.location.coordinate.latitude];
            
            [self getTaskList];
            
        }
        else if ([placemarks count] == 0 && error == nil) {
            NSLog(@"Found no placemarks.");
        } else if (error != nil) {
            NSLog(@"An error occurred = %@", error);
        }
    }];
}



- (void)getTaskList{
    
    NSDictionary *dic = @{@"TYPE_ID":@"GUANYUWOMEN", @"LAT":self.lon, @"LNG":self.lat};
    
    [[DLAPIClient sharedClient]POST:[NSString stringWithFormat:@"taskList?currentPage=%d", dataPage] parameters:dic success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([responseObject[Kstatus]isEqualToString:Ksuccess]) {
            
            
            if (dataPage == 1) {
                [self.listAry removeAllObjects];
            }
            
            dataPage ++;
            
            if ([[responseObject[@"page"] objectForKey:@"totalPage"] intValue] < dataPage) {
                isNoMoreData = YES;
            }else{
                isNoMoreData = NO;
            }
            
            for (NSDictionary *dic in responseObject[@"dataList"]) {
                TaskListModel *model = [TaskListModel modelWithDictionary:dic];
                [self.listAry addObject:model];
            }
            
            for (NSDictionary *dic in responseObject[@"categoryList"]) {
                categoryModel *model = [categoryModel modelWithDictionary:dic];
                [self.categoryList addObject:model];
            }
            
            [self.tableView reloadData];
        }else{
            [self showErrorMessage:responseObject[Kinfo]];
        }
        [self endRefresh];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self showErrorMessage:@"数据错误"];
    }];
}

- (void)allTypeAction{
    //创建AlertController对象 preferredStyle可以设置是AlertView样式或者ActionSheet样式
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:nil message:@"任务类型" preferredStyle:UIAlertControllerStyleActionSheet];
    //创建取消按钮
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [alertC addAction:action1];
    
    for (int i=0; i<self.categoryList.count; i++) {
        categoryModel *model = self.categoryList[i];
        UIAlertAction *action2 = [UIAlertAction actionWithTitle:model.name style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//            self.model.firstId = model.categoryId;
//            self.model.secodeId = model.categoryId;
//            self.model.firstTitle = model.name;
            [self.tableView reloadData];
        }];
        [alertC addAction:action2];
    }
    
    //显示
    [self presentViewController:alertC animated:YES completion:nil];
}

- (void)startTimeAction{
    [self creatPickView];
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
    
    taskDetailVc.isMyTask = NO;
    
    taskDetailVc.lat = self.lon;
    taskDetailVc.lon = self.lat;
    taskDetailVc.ID = model.taskId;
    [self.navigationController pushViewController:taskDetailVc animated:YES];
}

- (void)refresh{
    if (isDownLoading) {
        return;
    }
    dataPage = 1;
    isDownLoading = YES;
    [self getTaskList];
}

- (void)endRefresh {
    isDownLoading = NO;
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
    self.tableView.mj_footer.hidden = YES;
}

- (void)loadMore{
    if (isDownLoading) {
        [self endRefresh];
        return;
    }
    
    if (!isNoMoreData) {
        [self getTaskList];
    }
    else{
        [self endRefresh];
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
