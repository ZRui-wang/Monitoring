//
//  GoToPatrolViewController.m
//  Monitore
//
//  Created by kede on 2017/7/27.
//  Copyright © 2017年 kede. All rights reserved.
//

#import "GoToPatrolViewController.h"

@interface GoToPatrolViewController ()<BMKMapViewDelegate, BMKLocationServiceDelegate>
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
    [self.view addSubview:self.mapView];

    
    self.locService = [[BMKLocationService alloc]init];
    self.locService.delegate = self;
    [self.locService startUserLocationService];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.mapView viewWillAppear];
    self.mapView.delegate = self;
}

- (void)viewWillDisappear:(BOOL)animated{
    [self.mapView viewWillDisappear];
    self.mapView.delegate = nil;
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
    //NSLog(@"didUpdateUserLocation lat %f,long %f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
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
