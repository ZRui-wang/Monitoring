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
    BMKReverseGeoCodeOption *reverseGeocodeSearchOption = [[BMKReverseGeoCodeOption alloc]init];
    reverseGeocodeSearchOption.reverseGeoPoint = pt;
    
    
    BOOL flag = [_geocodesearch reverseGeoCode:reverseGeocodeSearchOption];
    if(flag) NSLog(@"反geo检索发送成功");

}

// 实现反编码的delegate
-(void) onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error {
    self.currentAddress = [NSString stringWithFormat:@"%@, %@, %@, %@", result.addressDetail.city, result.addressDetail.district, result.addressDetail.streetName, result.addressDetail.streetNumber];
    
    self.addressBlock(self.currentAddress);
    [self.service stopUserLocationService];
    self.service.delegate = nil;
    self.geocodesearch.delegate = nil;
}

@end
