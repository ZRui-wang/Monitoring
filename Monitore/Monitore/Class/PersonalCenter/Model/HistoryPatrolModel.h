//
//  PatrolHistoryModel.h
//  Monitore
//
//  Created by kede on 2017/11/28.
//  Copyright © 2017年 kede. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PatrolDetailModel : NSObject

@property (copy, nonatomic) NSString *startTime;
@property (copy, nonatomic) NSString *remark;

@end



@interface HistoryPatrolModel : NSObject

@property (strong, nonatomic) NSArray *dataList;
@property (copy, nonatomic) NSString *allDistance;
@property (copy, nonatomic) NSString *name;

@end
