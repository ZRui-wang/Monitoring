//
//  AnnounceListModel.m
//  Monitore
//
//  Created by 小王 on 2017/9/11.
//  Copyright © 2017年 kede. All rights reserved.
//

#import "AnnounceListModel.h"


@implementation CategoryModel

@end

@implementation AnnounceModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
             @"imgList" : [CategoryModel class]
             };
}

@end

@implementation AnnounceListModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
             @"dataList" : [AnnounceModel class],
             @"categoryList" : [CategoryModel class]
             };
}

@end
