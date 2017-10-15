//
//  VolunterMapViewController.m
//  Monitore
//
//  Created by kede on 2017/9/15.
//  Copyright © 2017年 kede. All rights reserved.
//

#import "VolunterMapViewController.h"
#import "VolunteerModel.h"

@interface VolunterMapViewController ()<BMKMapViewDelegate, BMKLocationServiceDelegate>

@property (strong, nonatomic)BMKMapView *mapView;
@property (strong, nonatomic)BMKLocationService *locService;
@property (copy, nonatomic)NSString *lat;
@property (copy, nonatomic)NSString *lon;
@property (strong, nonatomic)NSMutableArray *listArray;
@end

@implementation VolunterMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.listArray = [NSMutableArray array];
    BMKMapView *mapView = [[BMKMapView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    self.mapView = mapView;
    [self.view addSubview:self.mapView];
    self.mapView.mapType = MKMapTypeSatellite;
    self.mapView.showsUserLocation = YES;
    self.mapView.userTrackingMode = BMKUserTrackingModeFollow;
    [self.mapView setZoomLevel:18];
    
    self.locService = [[BMKLocationService alloc]init];
    self.locService.delegate = self;
    self.locService.distanceFilter = 6.0f;
    self.locService.desiredAccuracy=kCLLocationAccuracyBest;
    [self.locService startUserLocationService];
    
    __block typeof(self) weak = self;
    [[Tools sharedTools]getCurrentAddress:^(NSString *address) {
        [weak getGeoCoedAddress:address];
    }];
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
            [self requestNetData];
        }
        else if ([placemarks count] == 0 && error == nil) {
            NSLog(@"Found no placemarks.");
        } else if (error != nil) {
            NSLog(@"An error occurred = %@", error);
        }
    }];
}


- (void)requestNetData{
    NSDictionary *dic = @{@"LONGITUDE":self.lon, @"LATITUDE":self.lat};
    [[DLAPIClient sharedClient]POST:@"fjList" parameters:dic success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"附近志愿者：%@", responseObject);
        
        for (NSDictionary *dic in responseObject[@"dataList"]) {
            VolModel *model = [VolModel modelWithDictionary:dic];
            [self.listArray addObject:model];
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
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
    
    for (VolModel *model in self.listArray) {
        BMKPointAnnotation *annotation = [[BMKPointAnnotation alloc]init];
        //    annotationV.image = [UIImage imageNamed:@"5ud.png"];//大头针的显示图片
        CLLocationCoordinate2D coor;
        coor.latitude = [model.latitude floatValue];
        coor.longitude = [model.longitude floatValue];
        annotation.coordinate = coor;
        [self.mapView addAnnotation:annotation];
    }
    
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
