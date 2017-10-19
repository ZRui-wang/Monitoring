//
//  PatrolTrajectoryViewController.h
//  Monitore
//
//  Created by kede on 2017/7/27.
//  Copyright © 2017年 kede. All rights reserved.
//

#import "BaseViewController.h"

@interface PatrolTrajectoryViewController : BaseViewController

@property (copy, nonatomic) NSString *patrolID;
@property (copy, nonatomic) NSString *startTime;
@property (copy, nonatomic) NSString *endTime;
@property (copy, nonatomic) NSString *startAddr;
@property (copy, nonatomic) NSString *endAddr;
@property (copy, nonatomic) NSString *patrolTitle;
@property (copy, nonatomic) NSString *name;

@end
