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

@interface GoToPatrolViewController ()<BMKMapViewDelegate, BMKLocationServiceDelegate, BTKTraceDelegate, BTKTrackDelegate, DLAlertViewDelegate, UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UILabel *patrolAddress;
@property (weak, nonatomic) IBOutlet UILabel *patrolTime;
@property (weak, nonatomic) IBOutlet UIView *mapBagView;
@property (weak, nonatomic) IBOutlet UIButton *startButton;
@property (weak, nonatomic) IBOutlet UITextField *patrolTitle;

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

@property (copy, nonatomic) NSString *address;
@property (copy, nonatomic) NSString *lon;
@property (copy, nonatomic) NSString *lat;
@property (copy, nonatomic) NSString *patrolId;
@property (assign, nonatomic) BOOL isPatroling;

@end

@implementation GoToPatrolViewController{
    NSInteger timerCount;
    NSString *nickName;
    NSDate *resignBackgroundDate;
    BOOL startline;
}

- (void)dealloc{
    [_timer invalidate];
    _timer = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self leftCustomBarButton];
    self.title = @"我要巡逻";

    [self setConfigView];
    [self refreshAddress];
    [self initMapSdk];
    
    startline = NO;
    
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

- (void)registerBackgoundNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(resignActiveToRecordState)
                                                 name:@"appResignActive"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(becomeActiveToRecordState)
                                                 name:@"appBecomeActive"
                                               object:nil];
}



- (void)resignActiveToRecordState
{
    resignBackgroundDate = [NSDate date];
}

- (void)becomeActiveToRecordState
{
    NSTimeInterval timeHasGone = [[NSDate date] timeIntervalSinceDate:resignBackgroundDate];
    timerCount = timeHasGone + timerCount;
}


- (void)setConfigView{
    timerCount = 0;
    
    UserTitle *userTitle = [Tools getPersonData];
    self.model = [[StartPatrolModel alloc]init];
    self.model.userId = userTitle.usersId;
    nickName = userTitle.mobile;
    self.patrolTitle.delegate = self;
}

- (void)refreshAddress{
    __weak GoToPatrolViewController *weakSelf = self;
    [[Tools sharedTools]getCurrentAddress:^(NSString *address) {
        weakSelf.patrolTitle.text = address;
        weakSelf.address = address;
        [weakSelf getGeoCoedAddress:address];
    }];
}

- (void)initMapSdk{
    self.mapView = [[BMKMapView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-60)];
    self.mapView.userTrackingMode = BMKUserTrackingModeFollow;
    // 地图样式
    self.mapView.mapType = MKMapTypeSatellite;
    self.mapView.showsUserLocation = YES;
    [self.mapView setZoomLevel:18];
    self.mapView.maxZoomLevel = 18;
    [self.mapBagView addSubview:self.mapView];
    
    self.locService = [[BMKLocationService alloc]init];
    self.locService.delegate = self;
    // 设置过滤距离， 更新的最小间隔距离
    self.locService.distanceFilter = 20.0f;
    self.locService.desiredAccuracy=kCLLocationAccuracyBest;
    [self.locService startUserLocationService];
    
    // 配置鹰眼基本信息
    BTKServiceOption *sop = [[BTKServiceOption alloc]initWithAK:@"hNEAx1pNsQXZ3F9HPyReVcGD58KhEhep" mcode:@"com.monitor.qunfang" serviceID:155052 keepAlive:YES];
    [[BTKAction sharedInstance] initInfo:sop];
    
    // 定位选项设置
    [[BTKAction sharedInstance]setLocationAttributeWithActivityType:CLActivityTypeOther desiredAccuracy:kCLLocationAccuracyBest distanceFilter:kCLDistanceFilterNone];
    [[BTKAction sharedInstance] changeGatherAndPackIntervals:1 packInterval:10 delegate:self];
    
    // 纠错
    BTKQueryTrackProcessOption *processOption = [[BTKQueryTrackProcessOption alloc] init];
    processOption.denoise = TRUE;
    processOption.vacuate = TRUE;
    processOption.mapMatch = TRUE;
    processOption.radiusThreshold = 30;
    processOption.transportMode = BTK_TRACK_PROCESS_OPTION_SUPPLEMENT_MODE_STRAIGHT;
    
    // 构造请求对象
    BTKQueryTrackLatestPointRequest *request = [[BTKQueryTrackLatestPointRequest alloc] initWithEntityName:nickName processOption: processOption outputCootdType:BTK_COORDTYPE_BD09LL serviceID:155052 tag:13];
    // 发起查询请求
    [[BTKTrackAction sharedInstance] queryTrackLatestPointWith:request delegate:self];
}

- (void)startTrajectory{
    // 开启轨迹服务
    BTKStartServiceOption *op = [[BTKStartServiceOption alloc] initWithEntityName:nickName];
    // 开启服务
    [[BTKAction sharedInstance] startService:op delegate:self];
    
    // 轨迹采集
    [[BTKAction sharedInstance] startGather:self];
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
        if (distance < 10)
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
    if (startline) {
        [self configureRoutes];
    }
    
    
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
        [self configureRoutes];       // 开始画线
        [self startPatrol];
        startline = YES;
    }else{
        [self refreshAddress];
        // 结束
        DLAlertView *alertView = [[DLAlertView alloc]initWithTitle:@"提示" message:@"确定要结束巡逻？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alertView.tag = 101;
        [alertView show];
    }
}

- (void)startPatrol{
    
    if ([Tools checkLimitLocation]) {
        
    }else{
        [self showWarningMessage:@"定位失败，检查是否有定位权限"];
        return;
    }
    
    NSDictionary *dic = @{@"USER_ID":self.model.userId,
                          @"TITLE":self.patrolTitle.text,
                          @"NAME":@"小三",
                          @"START_LONGITUDE":self.lon,
                          @"START_LATITUDE":self.lat,
                          @"START_ADDRESS":self.address};
    
    [[DLAPIClient sharedClient]POST:@"patrol" parameters:dic success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"%@", responseObject);
        if ([responseObject[Kstatus]isEqualToString:Ksuccess]) {
            [self showSuccessMessage:@"开始巡逻"];
            self.isPatroling = YES;
            self.patrolId = [responseObject[@"data"] objectForKey:@"patrolId"];
            
            
            [self.startButton setTitle:@"结束巡逻" forState:UIControlStateNormal];
            self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
            
            self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:@selector(leftBarButtonAction1)];
            
            [self startTrajectory];
            
        }
        else{
            [self showErrorMessage:responseObject[Kinfo]];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self showErrorMessage:@"网络错误，稍后再试"];
    }];
}

- (void)endPatrol{
//    __weak GoToPatrolViewController *weakSelf = self;
//    [[Tools sharedTools]getCurrentAddress:^(NSString *address) {
//        weakSelf.patrolTitle.text = address;
//        weakSelf.address = address;
//        [weakSelf getGeoCoedAddress:address];
//    }];
    
    NSDictionary *dic = @{@"USER_ID":self.model.userId,
                      @"ID":self.patrolId,
                          @"END_LONGITUDE":self.lon,
                          @"END_LATITUDE":self.lat,
                          @"END_ADDRESS":self.address};
    
    [[DLAPIClient sharedClient]POST:@"endPatrol" parameters:dic success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"结束 = %@", responseObject);
        if ([responseObject[Kstatus]isEqualToString:Ksuccess]) {
            [self showSuccessMessage:responseObject[Kinfo]];
            self.isPatroling = NO;
            [self.timer invalidate];
            [self leftBarButtonAction1];
        }else{
            [self showErrorMessage:responseObject[Kinfo]];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self showErrorMessage:@"网络错误"];
    }];
}

- (void)leftBarButtonAction1{
    if (self.isPatroling) {
        DLAlertView *alertView = [[DLAlertView alloc]initWithTitle:@"提示" message:@"确定要结束巡逻？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alertView.tag = 100;
        [alertView show];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }

}

- (void)timerAction{
    timerCount ++;
    self.patrolTime.text = [NSString stringWithFormat:@"已执行：%@", [self timeFormatted:timerCount]];
}

- (NSString *)timeFormatted:(NSInteger)totalSeconds
{    
    int seconds = totalSeconds % 60;
    int minutes = (totalSeconds / 60) % 60;
    int hours = totalSeconds / 3600;
    
    return [NSString stringWithFormat:@"%02d:%02d:%02d",hours, minutes, seconds];
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



- (void)textFieldDidEndEditing:(UITextField *)textField{
    self.patrolTitle.text = textField.text;
}


- (void)mapView:(BMKMapView *)mapView didAddAnnotationViews:(NSArray *)views {
//    [self running];
}


-(void)alertView:(DLAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 100) {
        if (buttonIndex == 1) {
            [self.timer invalidate];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
    
    if (alertView.tag == 101) {
        [self endPatrol];
    }
}

- (void)getGeoCoedAddress:(NSString *)address{
    CLGeocoder *myGeocoder = [[CLGeocoder alloc] init];
    [myGeocoder geocodeAddressString:address completionHandler:^(NSArray *placemarks, NSError *error) {
        if ([placemarks count] > 0 && error == nil) {
            NSLog(@"Found %lu placemark(s).", (unsigned long)[placemarks count]);
            CLPlacemark *firstPlacemark = [placemarks objectAtIndex:0];
            NSLog(@"Longitude = %f", firstPlacemark.location.coordinate.longitude);
            NSLog(@"Latitude = %f", firstPlacemark.location.coordinate.latitude);
            
            self.lon = [NSString stringWithFormat:@"%f", firstPlacemark.location.coordinate.longitude];
            self.lat = [NSString stringWithFormat:@"%f", firstPlacemark.location.coordinate.latitude];
        }
        else if ([placemarks count] == 0 && error == nil) {
            NSLog(@"Found no placemarks.");
        } else if (error != nil) {
            NSLog(@"An error occurred = %@", error);
        }
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
