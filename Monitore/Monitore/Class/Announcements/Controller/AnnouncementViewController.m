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
#import "PullAnnounceMentViewController.h"

@interface AnnouncementViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic)UIView *bgView;

@end

@implementation AnnouncementViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 55, SCREEN_WIDTH, 200)];
    self.bgView.backgroundColor = [UIColor redColor];
    [self.view addSubview:self.bgView];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"AnnouncementTableViewCell" bundle:nil] forCellReuseIdentifier:@"AnnouncementTableViewCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"AnnouncementVcHeaderView" bundle:nil] forHeaderFooterViewReuseIdentifier:@"AnnouncementVcHeaderView"];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 30;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 55;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    AnnouncementTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AnnouncementTableViewCell" forIndexPath:indexPath];
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    AnnouncementVcHeaderView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"AnnouncementVcHeaderView"];
    
    [view.typeButton addTarget:self action:@selector(typeButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    return view;
}

- (void)typeButtonAction:(UIButton *)button{
    
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 55, SCREEN_WIDTH, 200)];
    bgView.backgroundColor = [UIColor redColor];
    [self.view addSubview:bgView];
    
//    PullAnnounceMentViewController *pullAnnounceMentVc = [[UIStoryboard storyboardWithName:@"Announcement" bundle:nil]instantiateViewControllerWithIdentifier:@"PullAnnounceMentViewController"];
//    [self presentViewController:pullAnnounceMentVc animated:YES completion:nil];
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
