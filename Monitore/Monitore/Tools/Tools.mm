//
//  Tools.m
//  Monitore
//
//  Created by kede on 2017/7/28.
//  Copyright © 2017年 kede. All rights reserved.
//

#import "Tools.h"
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>



@interface Tools ()<CLLocationManagerDelegate, BMKLocationServiceDelegate>


@property (strong, nonatomic)CLLocationManager *locationManager;
@property (copy, nonatomic)NSString *currentAddress;

@property (copy, nonatomic)AddressBlock addressBlock;
@end

@implementation Tools

+ (id)sharedTools
{
    static Tools *sharedAccountManagerInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedAccountManagerInstance = [[self alloc] init];
    });
    return sharedAccountManagerInstance;
}


+ (CGFloat)heightForTextWith:(NSString *)text fontSize:(CGFloat)fontSize width:(CGFloat)width {
    
    NSDictionary *attrbute = @{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]};
    return [text boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:(NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin) attributes:attrbute context:nil].size.height;
}

+ (CGFloat)widthForTextWith:(NSString *)text fontSize:(CGFloat)fontSize height:(CGFloat)height {
    
    NSDictionary *attrbute = @{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]};
    return [text boundingRectWithSize:CGSizeMake(MAXFLOAT, height) options:(NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin) attributes:attrbute context:nil].size.width;
}


- (void)getCurrentAddress:(AddressBlock)addressBlock{
    // 初始化定位管理器
    self.locationManager = [[CLLocationManager alloc]init];
    // 设置代理
    self.locationManager.delegate = self;
    // 设置定位精度到米
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    // 设置过滤器为无
    self.locationManager.distanceFilter = kCLDistanceFilterNone;
    
    [self.locationManager requestAlwaysAuthorization];
    // 开始定位
    [self.locationManager startUpdatingLocation];
    
    NSString *str = @"str";
    
    BMKLocationService *service = [[BMKLocationService alloc]init];
    service.delegate = self;
    [service startUserLocationService];
    
    
    self.addressBlock = ^(NSString *address){
        addressBlock(address);
    };
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
//    //NSLog(@"didUpdateUserLocation lat %f,long %f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
//
    NSLog(@"didUpdateUserLocation lat %f,long %f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
    NSString *lat = [NSString stringWithFormat:@"%f",userLocation.location.coordinate.latitude];
    NSString *lon = [NSString stringWithFormat:@"%f",userLocation.location.coordinate.longitude];

    CLLocationCoordinate2D pt = (CLLocationCoordinate2D){0, 0};
    if (lat!=nil && lon!=nil) {
        pt = (CLLocationCoordinate2D){[lat floatValue], [lon floatValue]};
    }
//    BMKReverseGeoCodeOption *reverseGeocodeSearchOption = [[BMKReverseGeoCodeOption alloc]init];
//    reverseGeocodeSearchOption.reverseGeoPoint = pt;
//    BOOL flag = [_geocodesearch reverseGeoCode:reverseGeocodeSearchOption];
//    if(flag) NSLog(@"反geo检索发送成功");
//    // 获取当前所在的城市名
//    
//    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
//    //根据经纬度反向地理编译出地址信息
//     [geocoder reverseGeocodeLocation:userLocation completionHandler:^(NSArray *array, NSError *error){
//        
//        if (array.count > 0){
//            CLPlacemark *placemark = [array objectAtIndex:0];
//            NSString *administrativeAreaStr = placemark.administrativeArea;
//            NSString *localityStr = placemark.locality;
//            NSString *subLocalityStr = placemark.subLocality;
//            //            self.location.text = [NSString stringWithFormat:@"%@ %@ %@",administrativeAreaStr,localityStr,subLocalityStr];
//            NSLog(@"信息1：%@",placemark.name);
//            
//            //获取城市
//            NSString *city = placemark.locality;
//            if (!city) {
//                //四大直辖市的城市信息无法通过locality获得，只能通过获取省份的方法来获得（如果city为空，则可知为直辖市）
//                city = placemark.administrativeArea;
//            }
//            NSLog(@"city = %@", city);
//            //            _cityLable.text = city;
//            //            [_cityButton setTitle:city forState:UIControlStateNormal];
//            
//        }
//        else if (error == nil && [array count] == 0){
//            NSLog(@"No results were returned.");
//        }
//        else if (error != nil){
//            NSLog(@"An error occurred = %@", error);
//        }
//    }];  completionHandler:^(NSArray *array, NSError *error){
//        
//        if (array.count > 0){
//            CLPlacemark *placemark = [array objectAtIndex:0];
//            NSString *administrativeAreaStr = placemark.administrativeArea;
//            NSString *localityStr = placemark.locality;
//            NSString *subLocalityStr = placemark.subLocality;
//            //            self.location.text = [NSString stringWithFormat:@"%@ %@ %@",administrativeAreaStr,localityStr,subLocalityStr];
//            NSLog(@"信息1：%@",placemark.name);
//            
//            //获取城市
//            NSString *city = placemark.locality;
//            if (!city) {
//                //四大直辖市的城市信息无法通过locality获得，只能通过获取省份的方法来获得（如果city为空，则可知为直辖市）
//                city = placemark.administrativeArea;
//            }
//            NSLog(@"city = %@", city);
//            //            _cityLable.text = city;
//            //            [_cityButton setTitle:city forState:UIControlStateNormal];
//            
//        }
//        else if (error == nil && [array count] == 0){
//            NSLog(@"No results were returned.");
//        }
//        else if (error != nil){
//            NSLog(@"An error occurred = %@", error);
//        }
//    }];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation{
    
    // 获取当前所在的城市名
    
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    //根据经纬度反向地理编译出地址信息
    [geocoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray *array, NSError *error){
        
        if (array.count > 0){
            CLPlacemark *placemark = [array objectAtIndex:0];
            NSString *administrativeAreaStr = placemark.administrativeArea;
            NSString *localityStr = placemark.locality;
            NSString *subLocalityStr = placemark.subLocality;
            //            self.location.text = [NSString stringWithFormat:@"%@ %@ %@",administrativeAreaStr,localityStr,subLocalityStr];
            NSLog(@"信息1：%@",placemark.name);
            
            //获取城市
            NSString *city = placemark.locality;
            if (!city) {
                //四大直辖市的城市信息无法通过locality获得，只能通过获取省份的方法来获得（如果city为空，则可知为直辖市）
                city = placemark.administrativeArea;
            }
            NSLog(@"city = %@", city);
            //            _cityLable.text = city;
            //            [_cityButton setTitle:city forState:UIControlStateNormal];
            
        }
        else if (error == nil && [array count] == 0){
            NSLog(@"No results were returned.");
        }
        else if (error != nil){
            NSLog(@"An error occurred = %@", error);
        }
    }];
    
    //系统会一直更新数据，直到选择停止更新，因为我们只需要获得一次经纬度即可，所以获取之后就停止更新
    
    [manager stopUpdatingLocation];
    
}


//获取经纬度和详细地址

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    
    CLLocation *location = [locations lastObject];
    NSLog(@"latitude === %g  longitude === %g",location.coordinate.latitude, location.coordinate.longitude);
    
    //反向地理编码
    CLGeocoder *clGeoCoder = [[CLGeocoder alloc] init];
    CLLocation *cl = [[CLLocation alloc] initWithLatitude:location.coordinate.latitude longitude:location.coordinate.longitude];
    [clGeoCoder reverseGeocodeLocation:cl completionHandler: ^(NSArray *placemarks,NSError *error) {
        
        for (CLPlacemark *placeMark in placemarks) {
            NSDictionary *addressDic = placeMark.addressDictionary;
            NSString *state=[addressDic objectForKey:@"State"];
            NSString *city=[addressDic objectForKey:@"City"];
            NSString *subLocality=[addressDic objectForKey:@"SubLocality"];
            NSString *street=[addressDic objectForKey:@"Street"];
            NSLog(@"所在城市====%@ %@ %@ %@", state, city, subLocality, street);
            
            self.addressBlock([NSString stringWithFormat:@"%@, %@, %@", city, subLocality, street]);
            
            [_locationManager stopUpdatingLocation];
        }
    }];
}

@end
