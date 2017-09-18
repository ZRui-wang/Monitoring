//
//  VolunterMapViewController.m
//  Monitore
//
//  Created by kede on 2017/9/15.
//  Copyright © 2017年 kede. All rights reserved.
//

#import "VolunterMapViewController.h"

@interface VolunterMapViewController ()<BMKMapViewDelegate, BMKLocationServiceDelegate>

@property (strong, nonatomic)BMKMapView *mapView;
@property (strong, nonatomic)BMKLocationService *locService;
@end

@implementation VolunterMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    BMKMapView *mapView = [[BMKMapView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    self.mapView = mapView;
    [self.view addSubview:self.mapView];
    self.mapView.mapType = MKMapTypeSatellite;
    self.mapView.showsUserLocation = YES;
    [self.mapView setZoomLevel:18];
    
    self.locService = [[BMKLocationService alloc]init];
    self.locService.delegate = self;
    self.locService.distanceFilter = 6.0f;
    self.locService.desiredAccuracy=kCLLocationAccuracyBest;
    [self.locService startUserLocationService];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    _mapView.delegate = self;
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    self.mapView.delegate = nil;
}

- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation{
    [self.mapView updateLocationData:userLocation];
}

- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation{
    [self.mapView updateLocationData:userLocation];
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
