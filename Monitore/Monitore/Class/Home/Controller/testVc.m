//
//  testVc.m
//  Monitore
//
//  Created by kede on 2018/4/11.
//  Copyright © 2018年 kede. All rights reserved.
//

#import "testVc.h"

@interface testVc()

@property (nonatomic, strong) dispatch_source_t timer;

@end

@implementation testVc

- (void)viewDidLoad{
    [super viewDidLoad];
    
    // 获取全局队列
    dispatch_queue_t queue = dispatch_get_main_queue();
    
    // 创建定时器
    self.timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    
    // 设置开始时间 1s后开始
    // 区别 dispatch_walltime(NULL, 0)   进入后台也能执行
    dispatch_time_t start = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC));
    
    // 重复间隔
    uint64_t interval = (uint64_t)(1.0 * NSEC_PER_SEC);
    
    // 设置定时器
    dispatch_source_set_timer(self.timer, start, interval, 0);
    
    // 设置需要执行的事件
    dispatch_source_set_event_handler(_timer, ^{
        
    });
    
    // 开启定时器
    dispatch_resume(_timer);
    
    
    // 关闭定时器
    // 完全销毁定时器， 需要开启的话需要重新创建
    // 全局变量， 关闭后需要置为nill
    dispatch_source_cancel(_timer);
    
    
    // 暂停定时器
    // 可使用dispatch_resume(_timer) 再次开启
    // 全局变量， 暂停后不能只为nil， 否则不能重新开启
    dispatch_suspend(_timer);
    
}

@end
