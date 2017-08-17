//
//  TaskHeaderView.h
//  Monitore
//
//  Created by 小王 on 2017/8/14.
//  Copyright © 2017年 kede. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TaskHeaderViewDelegate <NSObject>

- (void)allTypeAction;

- (void)startTimeAction;

- (void)endTimeAction;

@end

@interface TaskHeaderView : UIView

@property (assign, nonatomic)id <TaskHeaderViewDelegate> delegate;

@end
