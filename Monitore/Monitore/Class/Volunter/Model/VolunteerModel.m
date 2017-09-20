//
//  VolunteerModel.m
//  Monitore
//
//  Created by kede on 2017/9/20.
//  Copyright © 2017年 kede. All rights reserved.
//

#import "VolunteerModel.h"


@implementation VolModel

@end

@implementation VolunteerModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
             @"volunteer" : [VolModel class]
             };
}

@end
