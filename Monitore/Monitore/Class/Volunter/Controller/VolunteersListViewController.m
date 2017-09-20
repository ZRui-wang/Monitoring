//
//  VolunteersListViewController.m
//  Monitore
//
//  Created by kede on 2017/9/15.
//  Copyright © 2017年 kede. All rights reserved.
//

#import "VolunteersListViewController.h"
#import "InfoTableViewCell.h"
#import "VolunteerModel.h"
#import "VolunteerListHeaderView.h"


@interface VolunteersListViewController ()<UITableViewDelegate, UITableViewDataSource, ExpandSectionDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) VolunteerModel *volunteerModel;

@end

@implementation VolunteersListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor redColor];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"InfoTableViewCell" bundle:nil] forCellReuseIdentifier:@"InfoTableViewCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"VolunteerListHeaderView" bundle:nil] forHeaderFooterViewReuseIdentifier:@"VolunteerListHeaderView"];
    
    [self getdata];
}

- (void)getdata{

}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    InfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"InfoTableViewCell" forIndexPath:indexPath];
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    VolunteerListHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"VolunteerListHeaderView"];
    headerView.delegate = self;
    headerView.title.text = @"区域";
    return headerView;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 50;
}

- (void)expandSection:(NSInteger)section isExpand:(BOOL)expand{
    
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
