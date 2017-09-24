//
//  GoToPatrolViewController.m
//  Monitore
//
//  Created by kede on 2017/7/27.
//  Copyright © 2017年 kede. All rights reserved.
//

#import "GoToPatrolViewController.h"
#import "StartPatrolModel.h"
#import "UserTitle.h"

@interface GoToPatrolViewController ()<BMKMapViewDelegate, BMKLocationServiceDelegate, BTKTraceDelegate, BTKTrackDelegate, DLAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *patrolAddress;
@property (weak, nonatomic) IBOutlet UILabel *patrolTime;
@property (weak, nonatomic) IBOutlet UIView *mapBagView;
@property (weak, nonatomic) IBOutlet UIButton *startButton;

@property (strong, nonatomic) StartPatrolModel *model;

@property (strong, nonatomic)NSTimer *timer;

//位置管理者
@property (nonatomic, strong) CLLocationManager *localManager;
@property (strong, nonatomic)BMKMapView *mapView;
@property (strong, nonatomic)BMKLocationService *locService;
//存放用户位置的数组
@property (nonatomic, strong) NSMutableArray *locationPoint;

// 绘制折线
@property (nonatomic, strong)BMKPolyline *routeLine;

// 中间变量->location 类型(地理位置)
@property (strong, nonatomic)CLLocation *currentLocation;

@end

@implementation GoToPatrolViewController{
    NSInteger timerCount;
}

- (void)dealloc{
    if ([_timer isValid]) {
        [_timer invalidate];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self leftCustomBarButton];
    self.title = @"我要巡逻";
    
    timerCount = 0;
    
    UserTitle *userTitle = [Tools getPersonData];
    self.model = [[StartPatrolModel alloc]init];
    self.model.userId = userTitle.usersId;
    
    self.mapView = [[BMKMapView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-60)];
    self.mapView.userTrackingMode = BMKUserTrackingModeFollow;
    // 地图样式
    self.mapView.mapType = MKMapTypeSatellite;
    self.mapView.showsUserLocation = YES;
    [self.mapView setZoomLevel:18];
    [self.mapBagView addSubview:self.mapView];

    
    self.locService = [[BMKLocationService alloc]init];
    self.locService.delegate = self;
    // 设置过滤距离， 更新的最小间隔距离
    self.locService.distanceFilter = 6.0f;
    self.locService.desiredAccuracy=kCLLocationAccuracyBest;
    [self.locService startUserLocationService];
    
    // 配置鹰眼基本信息
    BTKServiceOption *sop = [[BTKServiceOption alloc]initWithAK:@"3hYyfdDODjd421keGGoZw2gHLaUBE2zx" mcode:@"com.monitor.optional" serviceID:145266 keepAlive:YES];
    [[BTKAction sharedInstance] initInfo:sop];
    
    // 定位选项设置
    [[BTKAction sharedInstance]setLocationAttributeWithActivityType:CLActivityTypeOther desiredAccuracy:kCLLocationAccuracyBest distanceFilter:kCLDistanceFilterNone];
    [[BTKAction sharedInstance] changeGatherAndPackIntervals:1 packInterval:10 delegate:self];
    
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

- (void)startTrajectory{
    // 开启轨迹服务
    BTKStartServiceOption *op = [[BTKStartServiceOption alloc] initWithEntityName:@"entityB"];
    // 开启服务
    [[BTKAction sharedInstance] startService:op delegate:self];
    
    // 轨迹采集
    [[BTKAction sharedInstance] startGather:self];
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

-(void)alertView:(DLAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        [self.timer invalidate];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

// 开始采集回调
- (void)onStartGather:(BTKGatherErrorCode)error{
    NSLog(@"开始采集轨迹信息=%ld", error);
}

// 停止采集回调
- (void)onStopGather:(BTKGatherErrorCode)error{
    NSLog(@"停止采集轨迹信息=%ld", error);
}

- (void)operationForLocation:(BMKUserLocation *)userLocation
{
    // 1、检查移动的距离，移除不合理的点
    if (self.locationPoint.count > 0) {
        CLLocationDistance distance = [userLocation.location distanceFromLocation:self.currentLocation];
        if (distance < 5)
            return;
    }
    
    // 2、初始化坐标点数组
    if (self.locationPoint == nil) {
        self.locationPoint = [[NSMutableArray alloc] init];
    }
    
    // 3、将合理的点添加到数组
    [self.locationPoint addObject:userLocation.location];
    
    // 4、作为前一个坐标位置辅助操作
    self.currentLocation = userLocation.location;
    
    // 5、开始画线
    [self configureRoutes];
    
    // 6、实时更新用户位子
    [self.mapView updateLocationData:userLocation];
}

#pragma mark - 绘制轨迹
-(void)configureRoutes
{
    // 1、分配内存空间给存储经过点的数组
    BMKMapPoint* pointArray = (BMKMapPoint *)malloc(sizeof(CLLocationCoordinate2D) * self.locationPoint.count);
    
    // 2、创建坐标点并添加到数组中
    for(int idx = 0; idx < self.locationPoint.count; idx++)
    {
        CLLocation *location = [self.locationPoint objectAtIndex:idx];
        CLLocationDegrees latitude  = location.coordinate.latitude;
        CLLocationDegrees longitude = location.coordinate.longitude;
        CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(latitude, longitude);
        BMKMapPoint point = BMKMapPointForCoordinate(coordinate);
        NSLog(@"哈哈哈哈 = %f, %f", point.x, point.y);
        pointArray[idx] = point;
    }
    // 3、防止重复绘制
    if (self.routeLine) {
        //在地图上移除已有的坐标点
        [self.mapView removeOverlay:self.routeLine];
    }
    
    // 4、画线
    self.routeLine = [BMKPolyline polylineWithPoints:pointArray count:self.locationPoint.count];
    
    
    // 5、将折线(覆盖)添加到地图
    if (nil != self.routeLine) {
        [self.mapView addOverlay:self.routeLine];
    }
    
    // 6、清楚分配的内存
    free(pointArray);
}


- (void)setConfig{
    
}

//实现相关delegate 处理位置信息更新
//处理方向变更信息
- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation
{
    [self.mapView updateLocationData:userLocation];
    //NSLog(@"heading is %@",userLocation.heading);
}
//处理位置坐标更新
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    //NSLog(@"didUpdateUserLocation lat %f,long %f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);

    [self.mapView updateLocationData:userLocation];
    // 说明:由于开启了“无限后台”的外挂模式(^-^)所以可以直接写操作代码，然后系统默认在任何情况执行，但是为了已读，规划代码如下
    // 1、活跃状态
    if ([UIApplication sharedApplication].applicationState == UIApplicationStateActive) {
        [self operationForLocation:userLocation];
    }else if([UIApplication sharedApplication].applicationState == UIApplicationStateBackground)
        // 2、后台模式
    {
        [self operationForLocation:userLocation];
    }
    // 3、不活跃模式
    else if ([UIApplication sharedApplication].applicationState == UIApplicationStateInactive)
    {
        [self operationForLocation:userLocation];
    }
}


- (IBAction)finishPatrolButtonAction:(UIButton *)sender {
    sender.selected = !sender.isSelected;
    
    if (sender.selected) {
        // 开始
 //       [self startPatrol];
        return;
        
        [self.startButton setTitle:@"结束巡逻" forState:UIControlStateNormal];
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
        
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:@selector(leftBarButtonAction1)];
        
        [self startTrajectory];
    }else{
        // 结束
        [self endPatrol];
        return;
        DLAlertView *alertView = [[DLAlertView alloc]initWithTitle:@"提示" message:@"确定要结束巡逻？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alertView show];
    }
}

- (void)startPatrol{
    NSDictionary *dic = @{@"USER_ID":self.model.userId,
                          @"TITLE":@"巡逻",
                          @"NAME":@"小三",
                          @"START_LONGITUDE":@"121.444569",
                          @"START_LATITUDE":@"31.252137",
                          @"START_ADDRESS":@"美国"};
    
    [[DLAPIClient sharedClient]POST:@"patrol" parameters:dic success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"%@", responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}

- (void)endPatrol{
    NSDictionary *dic = @{@"USER_ID":self.model.userId,
                      @"ID":@"c7bd7180485a42c8ae8e4866204e5e07",
                          @"END_LONGITUDE":@"121.444569",
                          @"END_LATITUDE":@"31.252137",
                          @"END_ADDRESS":@"美国"};
    
    [[DLAPIClient sharedClient]POST:@"endPatrol" parameters:dic success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"%@", responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}

- (void)leftBarButtonAction1{
    DLAlertView *alertView = [[DLAlertView alloc]initWithTitle:@"提示" message:@"确定要结束巡逻？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alertView show];
}

- (void)timerAction{
    timerCount ++;
    self.patrolTime.text = [NSString stringWithFormat:@"已执行：%lds", timerCount];
}

#pragma mark - BMKMapViewDelegate
- (void)mapViewDidFinishLoading:(BMKMapView *)mapView {
    //    [self start];
}

//根据overlay生成对应的View
- (BMKOverlayView *)mapView:(BMKMapView *)mapView viewForOverlay:(id <BMKOverlay>)overlay
{
    if ([overlay isKindOfClass:[BMKPolyline class]])
    {
        BMKPolylineView *lineview=[[BMKPolylineView alloc] initWithOverlay:overlay];
        lineview.strokeColor=[[UIColor blueColor] colorWithAlphaComponent:0.5];
        lineview.lineWidth=2.0;
        return lineview;    }
    return nil;
}


- (void)mapView:(BMKMapView *)mapView didAddAnnotationViews:(NSArray *)views {
//    [self running];
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
