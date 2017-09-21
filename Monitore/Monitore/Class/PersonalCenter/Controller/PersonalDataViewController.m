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


@interface PersonalDataViewController ()<UITableViewDelegate, UITableViewDataSource, SaveButtonDelegate, SaveInfoDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation PersonalDataViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self leftCustomBarButton];
    self.title = @"个人资料";
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"PersonalDataTableViewCell" bundle:nil] forCellReuseIdentifier:@"PersonalDataTableViewCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"PersonalPhotoTableViewCell" bundle:nil] forCellReuseIdentifier:@"PersonalPhotoTableViewCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"PersonalDataFooterView" bundle:nil] forHeaderFooterViewReuseIdentifier:@"PersonalDataFooterView"];
    [self.tableView registerNib:[UINib nibWithNibName:@"PersonalDataHeaderView" bundle:nil] forHeaderFooterViewReuseIdentifier:@"PersonalDataHeaderView"];

//    self.tableView.tableFooterView = [PersonalDataFooterView xibView];
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
        return 2;
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
        view.delegate = self;
        return view;
    }
    return nil;
}

- (void)saveButtonAction{
//    NSDictionary *dic = @{@"NICKNAME":self.model.nickname, @"IDCARD":self.model.idcard, @"JOB":self.model.job};
        NSDictionary *dic = @{@"NICKNAME":self.model.nickname, @"IDCARD":self.model.idcard, @"JOB":self.model.job};
    [[DLAPIClient sharedClient] POST:@"updUserInfo" parameters:dic success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"%@", responseObject);
        if ([responseObject[Kstatus] isEqualToString:Ksuccess]) {
            [self showSuccessMessage:@"保存成功"];
        }
        else{
            
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
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
        cell.delegate = self;
        cell.indexPath = indexPath;
        if (indexPath.row == 9) {
            cell.date = self.model.createtime;
        }
        
        if (indexPath.row == 0) {
            cell.mobile = self.model.mobile;
        }
        
        [cell displayCellWithData:nil andIndexpath:indexPath];
        return cell;
    }

}

- (void)buildInfoRow:(NSInteger)row info:(NSString *)info{
    switch (row) {
        case 1:
            self.model.nickname = info;
            break;
        case 2:
            
            break;
        case 3:
            
            break;
        case 4:
            self.model.idcard = info;
            break;
        case 5:
            self.model.job = info;
            break;
        case 6:
            
            break;
        case 7:
            
            break;
        case 8:
            
            break;
        case 9:
            
            break;
        case 10:
            
            break;
        case 11:
            
            break;
        case 12:
            
            break;
            
        default:
            break;
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
