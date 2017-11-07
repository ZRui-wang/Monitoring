//
//  PatrolTrajectoryViewController.m
//  Monitore
//
//  Created by kede on 2017/7/27.
//  Copyright © 2017年 kede. All rights reserved.
//

#import "PatrolTrajectoryViewController.h"
#import "JSONKit.h"
#import "PatrolHistoryModel.h"
#import "UserTitle.h"

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

@interface PatrolTrajectoryViewController ()<BTKTrackDelegate, BMKLocationServiceDelegate, BTKTraceDelegate, BMKMapViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *address;
@property (weak, nonatomic) IBOutlet UILabel *patrolTime;
@property (weak, nonatomic) IBOutlet UILabel *patrolLength;
@property (weak, nonatomic) IBOutlet UILabel *startAddress;
@property (weak, nonatomic) IBOutlet UILabel *startTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *endAddress;
@property (weak, nonatomic) IBOutlet UILabel *endTimeLabel;
@property (weak, nonatomic) IBOutlet UIView *mapBgView;

@property (strong, nonatomic)BMKMapView *mapView;
@property (strong, nonatomic)BMKLocationService *locService;

@property (strong, nonatomic)NSData *patrolData;

@property (strong, nonatomic)PatrolHistoryModel *model;

@end

// 自定义BMKAnnotationView，用于显示运动者
@interface SportAnnotationView : BMKAnnotationView

@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation SportAnnotationView

@synthesize imageView = _imageView;

- (id)initWithAnnotation:(id<BMKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setBounds:CGRectMake(0.f, 0.f, 22.f, 22.f)];
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.f, 0.f, 22.f, 22.f)];
        _imageView.image = [UIImage imageNamed:@"sportarrow.png"];
        [self addSubview:_imageView];
    }
    return self;
}

@end

@implementation PatrolTrajectoryViewController{
    BMKPolygon *pathPloygon;
    BMKPointAnnotation *sportAnnotation;
    SportAnnotationView *sportAnnotationView;
    
    NSMutableArray *sportNodes;//轨迹点
    NSInteger sportNodeNum;//轨迹点数
    NSInteger currentIndex;//当前结点
}

- (void)dealloc{
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self leftCustomBarButton];
    self.title = @"巡逻轨迹";
    
    self.mapView = [[BMKMapView alloc]initWithFrame:self.mapBgView.frame];
    self.mapView.userTrackingMode = BMKUserTrackingModeFollowWithHeading;
    self.mapView.userTrackingMode = BMKUserTrackingModeFollowWithHeading;
    self.mapView.zoomLevel = 15;
    
    [self.view addSubview:self.mapView];
    
    self.locService = [[BMKLocationService alloc]init];
    self.locService.delegate = self;
    [self.locService startUserLocationService];
    
    // 配置鹰眼基本信息
    BTKServiceOption *sop = [[BTKServiceOption alloc]initWithAK:@"3hYyfdDODjd421keGGoZw2gHLaUBE2zx" mcode:@"com.monitor.optional" serviceID:145266 keepAlive:YES];
    [[BTKAction sharedInstance] initInfo:sop];
    
    // 定位选项设置
    [[BTKAction sharedInstance]setLocationAttributeWithActivityType:CLActivityTypeOther desiredAccuracy:kCLLocationAccuracyBest distanceFilter:kCLDistanceFilterNone];
    [[BTKAction sharedInstance] changeGatherAndPackIntervals:1 packInterval:10 delegate:self];
    
    [self getPatrolDetail];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.mapView viewWillAppear];
    self.mapView.delegate = self;
    
    self.endTimeLabel.text = [NSString stringWithFormat:@"结束时间：%@", self.endTime];
    self.startTimeLabel.text = [NSString stringWithFormat:@"开始时间：%@", self.startTime];
    self.endAddress.text = [NSString stringWithFormat:@"结束地址：%@", self.startAddr];
    self.startAddress.text = [NSString stringWithFormat:@"开始地址：%@", self.startAddr];//
}

- (void)viewWillDisappear:(BOOL)animated{
    [self.mapView viewWillDisappear];
    self.mapView.delegate = nil;
    
    [[BTKAction sharedInstance] stopGather:self];
    [[BTKAction sharedInstance] stopService:self];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    // 设置纠偏选项
    BTKQueryTrackProcessOption *option = [[BTKQueryTrackProcessOption alloc] init];
    option.denoise = TRUE;
    option.mapMatch = YES;
    option.vacuate = YES;
    option.radiusThreshold = 20;
    
    // 构造请求对象
    NSUInteger endTime =[self changeTimeToTimeSp:self.endTime];
        NSUInteger startTime =[self changeTimeToTimeSp:self.startTime];
    
    self.patrolTime.text = [NSString stringWithFormat:@"巡逻时长：%@", [self timeFormatted:(endTime-startTime)]];
    
    UserTitle *userTitle = [Tools getPersonData];
    // userTitle.mobile
    BTKQueryHistoryTrackRequest *request = [[BTKQueryHistoryTrackRequest alloc] initWithEntityName:@"entityB" startTime:startTime endTime:endTime isProcessed:TRUE processOption:nil supplementMode:BTK_TRACK_PROCESS_OPTION_SUPPLEMENT_MODE_WALKING outputCoordType:BTK_COORDTYPE_BD09LL sortType:BTK_TRACK_SORT_TYPE_DESC pageIndex:1 pageSize:5000 serviceID:145266 tag:13];
    // 发起查询请求
    [[BTKTrackAction sharedInstance] queryHistoryTrackWith:request delegate:self];
}

- (NSString *)timeFormatted:(NSInteger)totalSeconds
{
    int seconds = totalSeconds % 60;
    int minutes = (totalSeconds / 60) % 60;
    int hours = totalSeconds / 3600;
    
    return [NSString stringWithFormat:@"%02d:%02d:%02d",hours, minutes, seconds];
}

-(long)changeTimeToTimeSp:(NSString *)timeStr
{
    long time;
    NSDateFormatter *format=[[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *fromdate=[format dateFromString:timeStr];
    time= (long)[fromdate timeIntervalSince1970];
    NSLog(@"%ld",time);
    return time;
}

- (void)getPatrolDetail{
    UserTitle *title = [Tools getPersonData];
    NSDictionary *dic = @{@"ID":self.patrolID, @"USER_ID":title.usersId};
    [[DLAPIClient sharedClient]POST:@"patrolDetail" parameters:dic success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"轨迹=%@", responseObject);
        if ([responseObject[Kstatus]isEqualToString:Ksuccess]) {
            NSDictionary *dic = responseObject[@"data"];
            self.address.text = [NSString stringWithFormat:@"标题：%@", dic[@"title"]];
        }else{
            
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}

//初始化轨迹点
- (void)initSportNodes {
    sportNodes = [[NSMutableArray alloc] init];
    if (!self.model.points.count) {
        [self showErrorMessage:@"没有查到轨迹"];
        return;
    }

    if (self.patrolData) {
        
        for (PointsModel *model in self.model.points) {
            BMKSportNode *sportNode = [[BMKSportNode alloc] init];
            sportNode.coordinate = CLLocationCoordinate2DMake([model.latitude doubleValue], [model.longitude doubleValue]);
            sportNode.angle = model.direction;
//            sportNode.distance = [dic[@"distance"] doubleValue];
            sportNode.speed = [model.speed doubleValue];
            [sportNodes insertObject:sportNode atIndex:0];

        }
    }
    sportNodeNum = sportNodes.count;
}

//
- (void)onQueryHistoryTrack:(NSData *)response{
    
    self.patrolData = response;
    
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingAllowFragments error:nil];
    
    if ([[dict objectForKey:@"status"] intValue]==2) {
        return;
    }
    
    self.model = [PatrolHistoryModel modelWithDictionary:dict];
    
    self.patrolLength.text = [NSString stringWithFormat:@"巡逻距离：%.2f米", [self.model.distance floatValue]];
    
    self.mapView.centerCoordinate = CLLocationCoordinate2DMake([self.model.start_point.latitude doubleValue], [self.model.start_point.longitude doubleValue]);
    
    //初始化轨迹点
    [self initSportNodes];
    
    [self start];
    
}

//开始
- (void)start {
    
    CLLocationCoordinate2D paths[sportNodes.count];

    for (NSInteger i = 0; i < sportNodes.count; i++) {
        BMKSportNode *node = sportNodes[i];
        paths[i] = node.coordinate;
    }
    
    // 轨迹线
    pathPloygon = [BMKPolygon polygonWithCoordinates:paths count:sportNodes.count];
    [self.mapView addOverlay:pathPloygon];
    
    // 定位圆圈
    sportAnnotation = [[BMKPointAnnotation alloc]init];
    sportAnnotation.coordinate = paths[0];
    sportAnnotation.title = @"test";
    [_mapView addAnnotation:sportAnnotation];
    currentIndex = 0;
}

//runing
- (void)running {
    if (!sportNodes.count) {
        [self showErrorMessage:@"没有查到轨迹"];
        return;
    }
    BMKSportNode *node = [sportNodes objectAtIndex:currentIndex % sportNodeNum];
    sportAnnotationView.imageView.transform = CGAffineTransformMakeRotation(node.angle);
    [UIView animateWithDuration:1 animations:^{
        currentIndex++;
        BMKSportNode *node = [sportNodes objectAtIndex:currentIndex % sportNodeNum];
        sportAnnotation.coordinate = node.coordinate;
    } completion:^(BOOL finished) {
        [self running];
        
        if (currentIndex>=sportNodeNum) {
            [self.view.layer removeAllAnimations];
        }
    }];

}

#pragma mark - BMKMapViewDelegate

- (void)mapViewDidFinishLoading:(BMKMapView *)mapView {
//po    [self start];
}

//根据overlay生成对应的View
- (BMKOverlayView *)mapView:(BMKMapView *)mapView viewForOverlay:(id <BMKOverlay>)overlay
{
    if ([overlay isKindOfClass:[BMKPolygon class]])
    {
        BMKPolygonView *polygonView = [[BMKPolygonView alloc] initWithOverlay:overlay];
        polygonView.strokeColor = [[UIColor alloc] initWithRed:0.0 green:0.5 blue:0.0 alpha:0.6];
        polygonView.lineWidth = 5.0;
        return polygonView;
    }
    return nil;
}


// 根据anntation生成对应的View
- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation
{
    if (sportAnnotationView == nil) {
        sportAnnotationView = [[SportAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"sportsAnnotation"];
        sportAnnotationView.draggable = NO;
        BMKSportNode *node = [sportNodes firstObject];
        sportAnnotationView.imageView.transform = CGAffineTransformMakeRotation(node.angle);
    }
    return sportAnnotationView;
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
