//
//  TaskListModel.h
//  Monitore
//
//  Created by kede on 2017/9/26.
//  Copyright © 2017年 kede. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TaskListModel : NSObject

@property (copy, nonatomic) NSString *startTime;
@property (copy, nonatomic) NSString *startAddress;
@property (copy, nonatomic) NSString *content;
@property (copy, nonatomic) NSString *typeName;
@property (copy, nonatomic) NSString *taskId;
@property (copy, nonatomic) NSString *distance;
@property (copy, nonatomic) NSString *num;
@property (copy, nonatomic) NSString *title;
@property (copy, nonatomic) NSString *endTime;
@property (copy, nonatomic) NSString *endAddress;
@property (copy, nonatomic) NSString *typeId;
@end
