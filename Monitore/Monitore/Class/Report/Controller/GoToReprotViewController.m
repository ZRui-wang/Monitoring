//
//  GoToReprotViewController.m
//  Monitore
//
//  Created by kede on 2017/7/27.
//  Copyright © 2017年 kede. All rights reserved.
//

#import "GoToReprotViewController.h"
#import "GoToReportTableViewCell.h"
#import "TextViewTableViewCell.h"
#import "ReportAddressTableViewCell.h"
#import "ReportImageTableViewCell.h"

@interface GoToReprotViewController ()<UITableViewDataSource, UITableViewDelegate, UITextViewDelegate, textViewDidFinishEidedDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic)UITextView *textView;

@property (strong, nonatomic)NSArray *titleAry;
@property (strong, nonatomic)NSArray *themeAry;

@end

@implementation GoToReprotViewController
{
    CGFloat titleHeigh;
    CGFloat detailHeigh;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self leftCustomBarButton];
    self.title = @"我要举报";
    
    //  支持自适应 cell
//    self.tableView.estimatedRowHeight = 100;
//    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    self.titleAry = @[@"大类", @"小类"];
    self.themeAry = @[@"主题", @"描述"];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"GoToReportTableViewCell" bundle:nil] forCellReuseIdentifier:@"GoToReportTableViewCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"TextViewTableViewCell" bundle:nil] forCellReuseIdentifier:@"TextViewTableViewCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"ReportAddressTableViewCell" bundle:nil] forCellReuseIdentifier:@"ReportAddressTableViewCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"ReportImageTableViewCell" bundle:nil] forCellReuseIdentifier:@"ReportImageTableViewCell"];
    self.tableView.tableFooterView = [UIView new];
    
    titleHeigh = 50;
    detailHeigh = 80;
    
}

- (void)finishEditHeigh:(CGFloat)heigh row:(NSInteger)row{
    if (row == 2) {
        titleHeigh = heigh;
    }else{
        detailHeigh = heigh;
    }
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 6;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row < 2) {
        return 50;
    }
    else if(indexPath.row == 2){
        return titleHeigh;
    }
    else if(indexPath.row == 3){
        return detailHeigh;
    }
    else if(indexPath.row == 4){
        return 50;
    }
    else{
        return 200;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < 2) {
        GoToReportTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GoToReportTableViewCell" forIndexPath:indexPath];
        [cell displayCellTitle:self.titleAry[indexPath.row]];
        return cell;
    }
    else if(indexPath.row < 4){
        TextViewTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TextViewTableViewCell" forIndexPath:indexPath];
        cell.delegate = self;
        cell.cellRow = indexPath.row;
        [cell diaplayCell:self.themeAry[indexPath.row -2]];
        return cell;
    }
    else if(indexPath.row == 4){
        ReportAddressTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ReportAddressTableViewCell" forIndexPath:indexPath];

        return cell;
    }
    else{
        ReportImageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ReportImageTableViewCell" forIndexPath:indexPath];
        return cell;
        
    }
}

- (IBAction)saveButtonAction:(id)sender {
}

- (IBAction)submitButtonAction:(id)sender {
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
