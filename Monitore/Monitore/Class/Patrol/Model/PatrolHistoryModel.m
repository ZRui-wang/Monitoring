//
//  PatrolHistoryModel.m
//  Monitore
//
//  Created by kede on 2017/8/4.
//  Copyright © 2017年 kede. All rights reserved.
//

#import "PatrolHistoryModel.h"

@implementation EndPointModel

@end

@implementation PointsModel

@end

@implementation PatrolHistoryModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
             @"points": [PointsModel class]
             };
}
@end




