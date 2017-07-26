//
//  PersonalDataViewController.m
//  Monitore
//
//  Created by kede on 2017/7/26.
//  Copyright © 2017年 kede. All rights reserved.
//

#import "PersonalDataViewController.h"
#import "PersonalDataTableViewCell.h"
#import "PersonalPhotoTableViewCell.h"
#import "PersonalDataFooterView.h"
#import "PersonalDataHeaderView.h"


@interface PersonalDataViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation PersonalDataViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"个人资料";
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"PersonalDataTableViewCell" bundle:nil] forCellReuseIdentifier:@"PersonalDataTableViewCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"PersonalPhotoTableViewCell" bundle:nil] forCellReuseIdentifier:@"PersonalPhotoTableViewCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"PersonalDataFooterView" bundle:nil] forHeaderFooterViewReuseIdentifier:@"PersonalDataFooterView"];
    [self.tableView registerNib:[UINib nibWithNibName:@"PersonalDataHeaderView" bundle:nil] forHeaderFooterViewReuseIdentifier:@"PersonalDataHeaderView"];

    self.tableView.tableFooterView = [PersonalDataFooterView xibView];
}

#pragma mark - UITableDatasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 10;
    }
    else
    {
        return 3;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0 && indexPath.row == 8) {
        return 100;
    }
    else
    {
        return 40;
    }
}

 - (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 0) {
        return 0.1;
    }
    else
    {
        return 51;
    }

}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section==1) {
        PersonalDataFooterView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"PersonalDataFooterView"];
        return view;
    }
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    PersonalDataHeaderView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"PersonalDataHeaderView"];
    if (section == 0) {
        view.title.text = @"基本信息";
    }
    else{
        view.title.text = @"地址信息";
    }
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0 && indexPath.row == 8) {
        PersonalPhotoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PersonalPhotoTableViewCell" forIndexPath:indexPath];
        return cell;
    }
    else
    {
        PersonalDataTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PersonalDataTableViewCell" forIndexPath:indexPath];
        [cell displayCellWithData:nil andIndexpath:indexPath];
        return cell;
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