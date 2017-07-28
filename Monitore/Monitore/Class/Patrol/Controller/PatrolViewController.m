//
//  PatrolViewController.m
//  Monitore
//
//  Created by kede on 2017/7/26.
//  Copyright © 2017年 kede. All rights reserved.
//

#import "PatrolViewController.h"
#import "PatrolTableViewCell.h"
#import "PatrolTableHeaderView.h"
#import "GoToPatrolViewController.h"
#import "PatrolTrajectoryViewController.h"

@interface PatrolViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation PatrolViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self leftCustomBarButton];
    self.title = @"巡逻记录";
    [self.tableView registerNib:[UINib nibWithNibName:@"PatrolTableViewCell" bundle:nil] forCellReuseIdentifier:@"PatrolTableViewCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"PatrolTableHeaderView" bundle:nil] forHeaderFooterViewReuseIdentifier:@"PatrolTableHeaderView"];
    
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 20;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 60;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PatrolTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PatrolTableViewCell" forIndexPath:indexPath];
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    PatrolTableHeaderView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"PatrolTableHeaderView"];
    return view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PatrolTrajectoryViewController *patrolTrajectoryVc = [[UIStoryboard storyboardWithName:@"Patrol" bundle:nil]instantiateViewControllerWithIdentifier:@"PatrolTrajectoryViewController"];
    [self.navigationController pushViewController:patrolTrajectoryVc animated:YES];
}

- (IBAction)goToPatrolAction:(id)sender {
    
    GoToPatrolViewController *goToPatrolVc = [[UIStoryboard storyboardWithName:@"Patrol" bundle:nil]instantiateViewControllerWithIdentifier:@"GoToPatrolViewController"];
    [self.navigationController pushViewController:goToPatrolVc animated:YES];
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
