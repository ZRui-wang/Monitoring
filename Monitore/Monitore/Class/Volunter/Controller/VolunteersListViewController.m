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

@property (strong, nonatomic) NSMutableArray *listArray;

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
    
    self.listArray = [NSMutableArray array];
    
    [self getdata];
}

- (void)getdata{
    [[DLAPIClient sharedClient]POST:@"qfList" parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"%@", responseObject);
        for (NSDictionary *dic in responseObject[@"dataList"]) {
            VolunteerModel *model = [VolunteerModel modelWithDictionary:dic];
            model.isExpand = YES;
            [self.listArray addObject:model];
        }
        [self.tableView reloadData];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.listArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    VolunteerModel *model = self.listArray[section];
    NSLog(@"数量 = %ld", model.childList.count);
    if (model.isExpand) {
        return model.childList.count;
    }else{
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    InfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"InfoTableViewCell" forIndexPath:indexPath];
    VolunteerModel *model = self.listArray[indexPath.section];
    VolModel *volModel = model.childList[indexPath.row];
    cell.info.text = volModel.name;
    [cell.titleImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",volModel.icon]] placeholderImage:[UIImage imageNamed:@"个人资料"]];
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    VolunteerListHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"VolunteerListHeaderView"];
    headerView.delegate = self;
    VolunteerModel *model = self.listArray[section];
    
    if (model.isExpand) {
        [headerView.expandBtn setImage:[UIImage imageNamed:@"arrow_up"] forState:UIControlStateNormal];
    }else{
        [headerView.expandBtn setImage:[UIImage imageNamed:@"icon_arrow_down"] forState:UIControlStateNormal];
    }
    
    if (!model.childList.count) {
        headerView.expandBtn.hidden = YES;
    }else{
        headerView.expandBtn.hidden = NO;
    }
    
    headerView.title.text = model.name;
    return headerView;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 50;
}

- (void)expandSection:(NSInteger)section isExpand:(BOOL)expand{
    VolunteerModel *model = self.listArray[section];
    model.isExpand = !model.isExpand;
    [self.tableView reloadData];
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
