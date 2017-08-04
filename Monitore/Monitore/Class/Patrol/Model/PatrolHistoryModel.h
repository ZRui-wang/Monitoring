//
//  PatrolHistoryModel.h
//  Monitore
//
//  Created by kede on 2017/8/4.
//  Copyright © 2017年 kede. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EndPointModel : NSObject

@property (copy, nonatomic) NSString *latitude;
@property (copy, nonatomic) NSString *loc_time;
@property (copy, nonatomic) NSString *longitude;

@end

@interface PointsModel : NSObject

@property (copy, nonatomic) NSString *create_time;
@property (assign, nonatomic) NSInteger direction;
@property (assign, nonatomic) NSInteger height;
@property (copy, nonatomic) NSString *latitude;
@property (copy, nonatomic) NSString *loc_time;
@property (copy, nonatomic) NSString *longitude;
@property (assign, nonatomic) NSInteger radius;
@property (copy, nonatomic) NSString *speed;
@end

@interface PatrolHistoryModel : NSObject

@property (copy, nonatomic) NSString *distance;
@property (strong, nonatomic) EndPointModel *end_point;
@property (strong, nonatomic) NSArray *points;
@property (assign, nonatomic) NSInteger size;
@property (strong, nonatomic) EndPointModel *start_point;

@end


