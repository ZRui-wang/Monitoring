//
//  Point.h
//  Monitore
//
//  Created by kede on 2017/12/11.
//  Copyright © 2017年 kede. All rights reserved.
//

//#import <BaiduMapAPI_Map/BaiduMapAPI_Map.h>
#import "VolunteerModel.h"

@interface AddressPoint : BMKPointAnnotation

@property (strong, nonatomic) VolModel *pointModel;

@end
