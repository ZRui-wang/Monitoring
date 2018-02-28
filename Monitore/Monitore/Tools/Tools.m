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



@interface Tools ()<CLLocationManagerDelegate, BMKLocationServiceDelegate, BMKGeoCodeSearchDelegate>

@property (copy, nonatomic)NSString *currentAddress;

@property (strong, nonatomic)BMKLocationService *service;
@property (strong, nonatomic)BMKGeoCodeSearch *geocodesearch;

@property (copy, nonatomic)AddressBlock addressBlock;

@property (copy, nonatomic)NSString *lat;
@property (copy, nonatomic)NSString *lon;

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
    
    self.service = [[BMKLocationService alloc]init];
    self.service.delegate = self;
    self.service.desiredAccuracy = kCLLocationAccuracyBest;
    [self.service startUserLocationService];

    self.geocodesearch = [[BMKGeoCodeSearch alloc]init];
    self.geocodesearch.delegate = self;
    
//    //发起反向地理编码检索
//    CLLocationCoordinate2D pt = (CLLocationCoordinate2D){39.915, 116.404};
//    BMKReverseGeoCodeOption *reverseGeoCodeSearchOption = [[BMKReverseGeoCodeOption alloc]init];
//    reverseGeoCodeSearchOption.reverseGeoPoint = pt;
//    BOOL flag = [self.geocodesearch reverseGeoCode:reverseGeoCodeSearchOption];
//    if(flag)
//    {
//        NSLog(@"反geo检索发送成功");
//    }
//    else
//    {
//        NSLog(@"反geo检索发送失败");
//    }

    __block typeof(self) weak = self;
    weak.addressBlock = ^(NSString *address){
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
    self.lat = [NSString stringWithFormat:@"%f",userLocation.location.coordinate.latitude];
    self.lon = [NSString stringWithFormat:@"%f",userLocation.location.coordinate.longitude];
}

- (void)didStopLocatingUser{
    CLLocationCoordinate2D pt = (CLLocationCoordinate2D){0, 0};
    if (self.lat!=nil && self.lon!=nil) {
        pt = (CLLocationCoordinate2D){[self.lat floatValue], [self.lon floatValue]};
    }
    BMKReverseGeoCodeOption *reverseGeocodeSearchOption = [[BMKReverseGeoCodeOption alloc]init];
    reverseGeocodeSearchOption.reverseGeoPoint = pt;
    
    
    BOOL flag = [_geocodesearch reverseGeoCode:reverseGeocodeSearchOption];
    if(flag) NSLog(@"反geo检索发送成功");
}

// 实现反编码的delegate
-(void) onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error {
//    self.currentAddress = [NSString stringWithFormat:@"%@, %@, %@%@", result.addressDetail.city, result.addressDetail.district, result.addressDetail.streetName, result.addressDetail.streetNumber];
    self.currentAddress = result.address;
    
    __block typeof(self) weak = self;
    weak.addressBlock(weak.currentAddress);
    [self.service stopUserLocationService];
    self.service.delegate = nil;
    self.geocodesearch.delegate = nil;
}

// 归档
+ (void)savePersonData:(UserTitle *)userTitle{
    // 创建一个可变data 初始化归档对象
    NSMutableData *data = [NSMutableData data];
    // 创建一个归档对象
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    // 进行归档编码
    [archiver encodeObject:userTitle forKey:@"userTitle"]; //此时调用归档方法encodeWithCoder:
    
    // 编码完成
    [archiver finishEncoding];
    
    
}

+ (UserTitle *)getPersonData{
    
    UserTitle *userTitle = nil;
    
    NSData *myEncodedObject = [[NSUserDefaults standardUserDefaults]objectForKey:@"userTitle"];
    
    NSKeyedUnarchiver *unArchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:myEncodedObject];
    // 解码返回一个对象
    userTitle = [unArchiver decodeObjectForKey:@"userTitle"]; // 此时调用反归档方法initWithCoder:
    // 反归档完成
    [unArchiver finishDecoding];
    
    return userTitle;
}

+ (BOOL)checkLimitLocation{
    if ([CLLocationManager locationServicesEnabled] && ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorized)) {
        
        //定位功能可用
        return YES;
        
    }else if ([CLLocationManager authorizationStatus] ==kCLAuthorizationStatusDenied) {
        
        //定位不能用
        return NO;
        
    }else{
        return NO;
    }
}

@end
