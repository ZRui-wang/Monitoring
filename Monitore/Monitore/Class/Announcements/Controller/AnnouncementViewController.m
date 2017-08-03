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
#import "PullTableViewCell.h"

@interface AnnouncementViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic)UITableView *pullTableView;

@property (strong, nonatomic)NSArray *pullTableViewTitleAry;

@property (strong, nonatomic)UIView *bgView;


@end

@implementation AnnouncementViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self leftCustomBarButton];
    
    self.bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 55, SCREEN_WIDTH, 0)];
    self.bgView.backgroundColor = [UIColor blackColor];
    self.bgView.alpha = 0.3;
    [self.view addSubview:self.bgView];
    UITapGestureRecognizer *tab = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tabAction)];
    [self.bgView addGestureRecognizer:tab];
    
    
    
    self.pullTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 55, SCREEN_WIDTH, 0) style:UITableViewStylePlain];
    [self.pullTableView registerNib:[UINib nibWithNibName:@"PullTableViewCell" bundle:nil] forCellReuseIdentifier:@"PullTableViewCell"];
    self.pullTableView.delegate = self;
    self.pullTableView.dataSource = self;
    self.pullTableView.tag = 100;
    [self.view addSubview:self.pullTableView];
    NSArray *ary = @[@"全部", @"群防新闻", @"线索征集", @"招募信息", @"培训通知"];
    self.pullTableViewTitleAry = ary;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"AnnouncementTableViewCell" bundle:nil] forCellReuseIdentifier:@"AnnouncementTableViewCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"AnnouncementVcHeaderView" bundle:nil] forHeaderFooterViewReuseIdentifier:@"AnnouncementVcHeaderView"];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView.tag == 100) {
        return 5;
    }
    else{
        return 30;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView.tag == 100) {
        return 40;
    }
    else{
        return 60;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (tableView.tag == 100) {
        return 0.1;
    }
    else{
         return 55;
    }

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView.tag == 100) {
        PullTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PullTableViewCell" forIndexPath:indexPath];
        cell.title.text = self.pullTableViewTitleAry[indexPath.row];
        return cell;
    }
    else{
        AnnouncementTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AnnouncementTableViewCell" forIndexPath:indexPath];
        return cell;
    }

}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    AnnouncementVcHeaderView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"AnnouncementVcHeaderView"];
    
    [view.typeButton addTarget:self action:@selector(typeButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [view.stateButton addTarget:self action:@selector(typeButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    return view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView.tag == 100) {
        if (indexPath.row == 0) {
            // 全部
        }
        else if (indexPath.row == 1){
            // 群防新闻
        }
        else if (indexPath.row == 2){
            // 线索征集
        }
        else if (indexPath.row == 3){
            // 招募信息
        }
        else if (indexPath.row == 4){
            // 培训通知
        }
        [self hidenBgView];
    }
}

- (void)typeButtonAction:(UIButton *)button{
    button.selected = !button.isSelected;
    
    if (button.selected) {
        [UIView animateWithDuration:1 animations:^{
            self.pullTableView.frame = CGRectMake(0, 55, SCREEN_WIDTH, 200);
            self.bgView.frame = CGRectMake(0, 55, SCREEN_WIDTH, SCREEN_HEIGHT-55);
        }];
    }
    else{
        [self hidenBgView];
    }

}

- (void)tabAction{
    [self hidenBgView];
}

- (void)hidenBgView{
    [UIView animateWithDuration:1 animations:^{
        self.pullTableView.frame = CGRectMake(0, 55, SCREEN_WIDTH, 0);
        self.bgView.frame = CGRectMake(0, 55, SCREEN_WIDTH, 0);
    }];
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