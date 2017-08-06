//
//  GoToPatrolViewController.m
//  Monitore
//
//  Created by kede on 2017/7/27.
//  Copyright © 2017年 kede. All rights reserved.
//

#import "GoToPatrolViewController.h"

// 运动结点信息类
@interface BMKSportNode : NSObject

//经纬度
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
//方向（角度）
@property (nonatomic, assign) CGFloat angle;
//距离
@property (nonatomic, assign) CGFloat distance;
//速度
@property (nonatomic, assign) CGFloat speed;

@end

@implementation BMKSportNode

@synthesize coordinate = _coordinate;
@synthesize angle = _angle;
@synthesize distance = _distance;
@synthesize speed = _speed;

@end


@interface GoToPatrolViewController ()<BMKMapViewDelegate, BMKLocationServiceDelegate, BTKTraceDelegate, BTKTrackDelegate>
@property (weak, nonatomic) IBOutlet UILabel *patrolAddress;
@property (weak, nonatomic) IBOutlet UILabel *patrolTime;
@property (weak, nonatomic) IBOutlet UIView *mapBagView;

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

@implementation GoToPatrolViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self leftCustomBarButton];
    self.title = @"我要巡逻";
    
    self.mapView = [[BMKMapView alloc]initWithFrame:self.mapBagView.frame];
    // 用户位置追踪
    self.mapView.userTrackingMode = BMKUserTrackingModeFollowWithHeading;
    // 地图样式
    self.mapView.mapType = MKMapTypeStandard;
    self.mapView.showsUserLocation = YES;
    [self.mapBagView addSubview:self.mapView];


    self.locService = [[BMKLocationService alloc]init];
    self.locService.delegate = self;
    // 设置过滤距离， 更新的最小间隔距离
    self.locService.distanceFilter = 6.0f;
    self.locService.desiredAccuracy=kCLLocationAccuracyBest;
    [self.locService startUserLocationService];
    
    // 配置鹰眼基本信息
    BTKServiceOption *sop = [[BTKServiceOption alloc]initWithAK:@"3hYyfdDODjd421keGGoZw2gHLaUBE2zx" mcode:@"com.dualens.optical" serviceID:145266 keepAlive:YES];
    [[BTKAction sharedInstance] initInfo:sop];
    
    // 定位选项设置
    [[BTKAction sharedInstance]setLocationAttributeWithActivityType:CLActivityTypeOther desiredAccuracy:kCLLocationAccuracyBest distanceFilter:6.0f];
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
//        BMKMapPoint point = BMKMapPointForCoordinate(coordinate);
//        pointArray[idx] = point;
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
    NSLog(@"didUpdateUserLocation lat %f,long %f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);

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

- (IBAction)finishPatrolButtonAction:(id)sender {
}


//开始
- (void)start {
//    CLLocationCoordinate2D paths[sportNodes.count];
//    for (NSInteger i = 0; i < sportNodes.count; i++) {
//        BMKSportNode *node = sportNodes[i];
//        paths[i] = node.coordinate;
//    }
//    
//    pathPloygon = [BMKPolygon polygonWithCoordinates:paths count:sportNodes.count];
//    [self.mapView addOverlay:pathPloygon];
//    
//    sportAnnotation = [[BMKPointAnnotation alloc]init];
//    sportAnnotation.coordinate = paths[0];
//    sportAnnotation.title = @"test";
//    [_mapView addAnnotation:sportAnnotation];
//    currentIndex = 0;
}

//runing
- (void)running {
//    BMKSportNode *node = [sportNodes objectAtIndex:currentIndex % sportNodeNum];
//    sportAnnotationView.imageView.transform = CGAffineTransformMakeRotation(node.angle);
//    [UIView animateWithDuration:1 animations:^{
//        currentIndex++;
//        BMKSportNode *node = [sportNodes objectAtIndex:currentIndex % sportNodeNum];
//        sportAnnotation.coordinate = node.coordinate;
//    } completion:^(BOOL finished) {
//        [self running];
//    }];
}

#pragma mark - BMKMapViewDelegate

- (void)mapViewDidFinishLoading:(BMKMapView *)mapView {
    //    [self start];
}

//根据overlay生成对应的View
- (BMKOverlayView *)mapView:(BMKMapView *)mapView viewForOverlay:(id <BMKOverlay>)overlay
{
    if ([overlay isKindOfClass:[BMKPolygon class]])
    {
        BMKPolygonView* polygonView = [[BMKPolygonView alloc] initWithOverlay:overlay];
        polygonView.strokeColor = [[UIColor alloc] initWithRed:0.0 green:0.5 blue:0.0 alpha:0.6];
        polygonView.lineWidth = 3.0;
        return polygonView;
    }
    return nil;
}


- (void)mapView:(BMKMapView *)mapView didAddAnnotationViews:(NSArray *)views {
    [self running];
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
