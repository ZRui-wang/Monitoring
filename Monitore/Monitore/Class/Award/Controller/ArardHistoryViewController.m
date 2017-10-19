//
//  ArardHistoryViewController.m
//  Monitore
//
//  Created by kede on 2017/9/20.
//  Copyright © 2017年 kede. All rights reserved.
//

#import "ArardHistoryViewController.h"
#import "HistoryModel.h"
#import "AwardHistoryTableViewCell.h"

@interface ArardHistoryViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIButton *waitButton;
@property (weak, nonatomic) IBOutlet UIButton *finishButton;
@property (weak, nonatomic) IBOutlet UIButton *invalidButton;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *modelArray;
@end

@implementation ArardHistoryViewController{
    NSInteger state;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"兑换记录";
    [self leftCustomBarButton];
    self.view.backgroundColor = [UIColor whiteColor];
    self.modelArray = [NSMutableArray array];
    
    state = 1;
    [self requestDats];
    self.finishButton.selected = YES;
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"AwardHistoryTableViewCell" bundle:nil] forCellReuseIdentifier:@"AwardHistoryTableViewCell"];
    self.tableView.tableFooterView = [UIView new];
}

- (void)requestDats{
    UserTitle *title = [Tools getPersonData];
    NSString *url = [NSString stringWithFormat:@"userGiftList?USER_ID=%@&STATE=%ld", title.usersId, state];
    [[DLAPIClient sharedClient]POST:url parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"%@", responseObject);
        if ([responseObject[Kstatus]isEqualToString:Ksuccess]) {
            for (NSDictionary *dic in responseObject[@"dataList"]) {
                HistoryModel *model = [HistoryModel modelWithDictionary:dic];
                [self.modelArray addObject:model];
            }
            [self.tableView reloadData];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.modelArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    AwardHistoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AwardHistoryTableViewCell" forIndexPath:indexPath];
    HistoryModel *model = self.modelArray[indexPath.row];
    [cell showDetailWithModel:model];
    return cell;
}

- (IBAction)waitButtonAction:(UIButton *)sender {
    sender.selected = !sender.isSelected;
    self.finishButton.selected = NO;
    self.invalidButton.selected = NO;
    state = 0;
    [self.modelArray removeAllObjects];
    [self requestDats];
}

- (IBAction)finishButton:(UIButton *)sender {
    sender.selected = !sender.isSelected;
    self.waitButton.selected = NO;
    self.invalidButton.selected = NO;
    state = 1;
    [self.modelArray removeAllObjects];
    [self requestDats];
}
- (IBAction)invalidButton:(UIButton *)sender {
    sender.selected = !sender.isSelected;
    self.waitButton.selected = NO;
    self.finishButton.selected = NO;
    state = 2;
    [self.modelArray removeAllObjects];
    [self requestDats];
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
