//
//  GoToPatrolViewController.m
//  Monitore
//
//  Created by kede on 2017/7/27.
//  Copyright © 2017年 kede. All rights reserved.
//

#import "GoToPatrolViewController.h"

@interface GoToPatrolViewController ()<BMKMapViewDelegate, BMKLocationServiceDelegate, BTKTraceDelegate, BTKTrackDelegate>
@property (weak, nonatomic) IBOutlet UILabel *patrolAddress;
@property (weak, nonatomic) IBOutlet UILabel *patrolTime;
@property (weak, nonatomic) IBOutlet UIView *mapBagView;

@property (strong, nonatomic)BMKMapView *mapView;
@property (strong, nonatomic)BMKLocationService *locService;

@end

@implementation GoToPatrolViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self leftCustomBarButton];
    self.title = @"我要巡逻";
    
    self.mapView = [[BMKMapView alloc]initWithFrame:self.mapBagView.frame];
    self.mapView.userTrackingMode = BMKUserTrackingModeFollowWithHeading;
    [self.mapBagView addSubview:self.mapView];

    
    self.locService = [[BMKLocationService alloc]init];
    self.locService.delegate = self;
    [self.locService startUserLocationService];
    
    // 配置鹰眼基本信息
    BTKServiceOption *sop = [[BTKServiceOption alloc]initWithAK:@"3hYyfdDODjd421keGGoZw2gHLaUBE2zx" mcode:@"com.dualens.optical" serviceID:145266 keepAlive:YES];
    [[BTKAction sharedInstance] initInfo:sop];
    
    // 定位选项设置
    [[BTKAction sharedInstance]setLocationAttributeWithActivityType:CLActivityTypeOther desiredAccuracy:kCLLocationAccuracyBest distanceFilter:kCLDistanceFilterNone];
    [[BTKAction sharedInstance] changeGatherAndPackIntervals:1 packInterval:10 delegate:self];
    
    // 开启轨迹服务
    BTKStartServiceOption *op = [[BTKStartServiceOption alloc] initWithEntityName:@"entityB"];
    // 开启服务
    [[BTKAction sharedInstance] startService:op delegate:self];
    
    // 轨迹采集
    [[BTKAction sharedInstance] startGather:self];
    
    // 纠错
    BTKQueryTrackProcessOption *processOption = [[BTKQueryTrackProcessOption alloc] init];
    processOption.denoise = TRUE;
    processOption.vacuate = TRUE;
    processOption.mapMatch = TRUE;
    processOption.radiusThreshold = 10;
    processOption.transportMode = BTK_TRACK_PROCESS_OPTION_SUPPLEMENT_MODE_STRAIGHT;

    // 构造请求对象
    BTKQueryTrackLatestPointRequest *request = [[BTKQueryTrackLatestPointRequest alloc] initWithEntityName:@"entityB" processOption: processOption outputCootdType:BTK_COORDTYPE_BD09LL serviceID:145266 tag:11];
    // 发起查询请求
    [[BTKTrackAction sharedInstance] queryTrackLatestPointWith:request delegate:self];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.mapView viewWillAppear];
    self.mapView.delegate = self;
}

- (void)viewWillDisappear:(BOOL)animated{
    [self.mapView viewWillDisappear];
    self.mapView.delegate = nil;
    
    [[BTKAction sharedInstance] stopGather:self];
    [[BTKAction sharedInstance] stopService:self];
}

// 开始采集回调
- (void)onStartGather:(BTKGatherErrorCode)error{
    NSLog(@"开始采集轨迹信息=%ld", error);
}

// 停止采集回调
- (void)onStopGather:(BTKGatherErrorCode)error{
    NSLog(@"停止采集轨迹信息=%ld", error);
}


- (void)setConfig{
    
}

//实现相关delegate 处理位置信息更新
//处理方向变更信息
- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation
{
    //NSLog(@"heading is %@",userLocation.heading);
}
//处理位置坐标更新
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    NSLog(@"didUpdateUserLocation lat %f,long %f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
    self.mapView.showsUserLocation = YES;
    [self.mapView updateLocationData:userLocation];
}

- (IBAction)finishPatrolButtonAction:(id)sender {
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
