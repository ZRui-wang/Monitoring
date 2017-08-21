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

@interface TaskViewController ()<UITableViewDelegate, UITableViewDataSource, TaskHeaderViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation TaskViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self leftCustomBarButton];
    
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 100)];
    
    
    TaskHeaderView *headerView1 = [TaskHeaderView xibView];
    headerView1.delegate = self;
    headerView1.frame = CGRectMake(0, 0, SCREEN_WIDTH, 100);
    
    [headerView addSubview:headerView1];
    
//    headerView.backgroundColor = [UIColor redColor];
//    self.tableView.tableHeaderView = headerView;
    self.tableView.tableHeaderView = headerView;
    [self.tableView registerNib:[UINib nibWithNibName:@"TaskTableViewCell" bundle:nil] forCellReuseIdentifier:@"TaskTableViewCell"];
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
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 170;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TaskTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TaskTableViewCell" forIndexPath:indexPath];
    return cell;
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