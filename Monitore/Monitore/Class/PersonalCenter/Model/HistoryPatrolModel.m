//
//  PatrolHistoryModel.m
//  Monitore
//
//  Created by kede on 2017/11/28.
//  Copyright © 2017年 kede. All rights reserved.
//

#import "HistoryPatrolModel.h"

@implementation PatrolDetailModel

@end

@implementation HistoryPatrolModel


+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
             @"dataList" : [PatrolDetailModel class]
             };
}

@end
