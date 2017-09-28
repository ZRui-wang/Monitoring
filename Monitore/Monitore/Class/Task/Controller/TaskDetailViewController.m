//
//  TaskDetailViewController.m
//  Monitore
//
//  Created by kede on 2017/9/26.
//  Copyright © 2017年 kede. All rights reserved.
//

#import "TaskDetailViewController.h"
#import "TaskDetailModel.h"
#import "UserTitle.h"

@interface TaskDetailViewController ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleDetail;
@property (weak, nonatomic) IBOutlet UILabel *type;
@property (weak, nonatomic) IBOutlet UILabel *content;
@property (weak, nonatomic) IBOutlet UILabel *startAddress;
@property (weak, nonatomic) IBOutlet UILabel *endAddress;
@property (weak, nonatomic) IBOutlet UILabel *taskTime;
@property (weak, nonatomic) IBOutlet UILabel *teamer;
@property (weak, nonatomic) IBOutlet UILabel *getTaskTime;
@property (weak, nonatomic) IBOutlet UILabel *score;
@property (weak, nonatomic) IBOutlet UILabel *number;
@property (weak, nonatomic) IBOutlet UILabel *distance;
@property (weak, nonatomic) IBOutlet UILabel *myAddress;
@property (weak, nonatomic) IBOutlet UILabel *tastAddress1;
@property (weak, nonatomic) IBOutlet UILabel *taskEndAddress1;
@property (weak, nonatomic) IBOutlet UIButton *getButton;

@property (strong, nonatomic) TaskDetailModel *model;
@end

@implementation TaskDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"任务详情";
    [self leftCustomBarButton];
    
    __block typeof(self) weak = self;
    [[Tools sharedTools]getCurrentAddress:^(NSString *address) {
        weak.tastAddress1.text = [NSString stringWithFormat:@"当前位置:%@", address];
    }];
    
    if (_isMyTask) {
        self.getButton.hidden = YES;
    }else{
        self.getButton.hidden = NO;
    }
    
    
    [self getTaskDetail];
}




- (IBAction)getTaskData:(id)sender {
    
    UserTitle *title = [Tools getPersonData];
    
    NSDictionary *dic = @{@"USER_ID":title.usersId, @"LAT":self.lat, @"LNG":self.lon, @"ID":self.ID};
    [[DLAPIClient sharedClient]POST:@"taskAdd" parameters:dic success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([responseObject[Kstatus]isEqualToString:Ksuccess]) {
            [self showSuccessMessage:responseObject[Kinfo]];
        }else{
            [self showErrorMessage:responseObject[Kinfo]];
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self showErrorMessage:@"领取失败"];
    }];
    
}

- (void)getTaskDetail{
    NSDictionary *dic = @{@"ID":self.ID, @"LAT":self.lat, @"LNG":self.lon};
    [[DLAPIClient sharedClient]POST:@"taskDetail" parameters:dic success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([responseObject[Kstatus]isEqualToString:Ksuccess]) {
            self.model = [TaskDetailModel modelWithDictionary:responseObject[@"data"]];
            self.titleLabel.text = self.model.typeName;
            self.titleDetail.text = self.model.title;
            self.type.text = [NSString stringWithFormat:@"类型: %@", self.model.typeName];
            self.content.text = [NSString stringWithFormat:@"描述: %@", self.model.content];
            self.startAddress.text = [NSString stringWithFormat:@"任务开始时间: %@", self.model.startTime];
            self.endAddress.text = [NSString stringWithFormat:@"任务开始地址: %@", self.model.startAddress];
            self.taskTime.text = [NSString stringWithFormat:@"任务结束地址: %@", self.model.endAddress];
            self.teamer.text = [NSString stringWithFormat:@"任务结束时间: %@", self.model.endTime];
            self.getTaskTime.text = [NSString stringWithFormat:@"领队: %@(%@)", self.model.teamloader, self.model.teamMobile];
            self.number.text = [NSString stringWithFormat:@"所需人数: %@", self.model.num];
            self.score.text = [NSString stringWithFormat:@"所得%@积分", self.model.score];
            self.distance.text = [NSString stringWithFormat:@"距我%@", self.model.distance];
            self.myAddress.text = [NSString stringWithFormat:@"任务开始地址:%@", self.model.startAddress];
            self.taskEndAddress1.text = [NSString stringWithFormat:@"任务结束地址:%@", self.model.endAddress];
        }else{
            [self showErrorMessage:responseObject[Kinfo]];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self showErrorMessage:@"数据错误"];
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
