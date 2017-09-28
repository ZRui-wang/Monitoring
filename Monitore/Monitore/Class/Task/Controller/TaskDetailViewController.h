//
//  TaskDetailViewController.h
//  Monitore
//
//  Created by kede on 2017/9/26.
//  Copyright © 2017年 kede. All rights reserved.
//

#import "BaseViewController.h"

@interface TaskDetailViewController : BaseViewController

@property (copy, nonatomic) NSString *ID;
@property (copy, nonatomic) NSString *lat;
@property (copy, nonatomic) NSString *lon;

@property (assign, nonatomic) BOOL isMyTask;

@end
