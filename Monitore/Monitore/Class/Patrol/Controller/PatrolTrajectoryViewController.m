//
//  PatrolTrajectoryViewController.m
//  Monitore
//
//  Created by kede on 2017/7/27.
//  Copyright © 2017年 kede. All rights reserved.
//

#import "PatrolTrajectoryViewController.h"

@interface PatrolTrajectoryViewController ()<BTKTrackDelegate>
@property (weak, nonatomic) IBOutlet UILabel *address;
@property (weak, nonatomic) IBOutlet UILabel *patrolTime;
@property (weak, nonatomic) IBOutlet UILabel *patrolLength;
@property (weak, nonatomic) IBOutlet UILabel *startAddress;
@property (weak, nonatomic) IBOutlet UILabel *startTime;
@property (weak, nonatomic) IBOutlet UILabel *endAddress;
@property (weak, nonatomic) IBOutlet UILabel *endTime;
@property (weak, nonatomic) IBOutlet UIView *mapBgView;

@property (strong, nonatomic)BMKMapView *mapView;

@end

@implementation PatrolTrajectoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self leftCustomBarButton];
    self.title = @"巡逻轨迹";
    
    self.mapView = [[BMKMapView alloc]initWithFrame:self.mapBgView.frame];
    self.mapView.userTrackingMode = BMKUserTrackingModeFollowWithHeading;
    
    self.mapBgView = self.mapView;
//    [self.mapBgView addSubview:self.mapView];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    // 构造请求对象
    NSUInteger endTime = [[NSDate date] timeIntervalSince1970];
    BTKQueryHistoryTrackRequest *request = [[BTKQueryHistoryTrackRequest alloc] initWithEntityName:@"entityB" startTime:endTime - 84400 endTime:endTime isProcessed:TRUE processOption:nil supplementMode:BTK_TRACK_PROCESS_OPTION_SUPPLEMENT_MODE_WALKING outputCoordType:BTK_COORDTYPE_BD09LL sortType:BTK_TRACK_SORT_TYPE_DESC pageIndex:1 pageSize:10 serviceID:145266 tag:13];
    // 发起查询请求
    [[BTKTrackAction sharedInstance] queryHistoryTrackWith:request delegate:self];
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
