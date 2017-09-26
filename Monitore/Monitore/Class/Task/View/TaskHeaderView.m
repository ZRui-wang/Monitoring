//
//  TaskHeaderView.m
//  Monitore
//
//  Created by 小王 on 2017/8/14.
//  Copyright © 2017年 kede. All rights reserved.
//

#import "TaskHeaderView.h"

@interface TaskHeaderView ()


@end
@implementation TaskHeaderView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code

}

- (IBAction)allTypeButtonAction:(id)sender {
    if ([_delegate respondsToSelector:@selector(allTypeAction)]) {
        [_delegate allTypeAction];
    }
}

- (IBAction)startTimeButtonAction:(id)sender {
    if ([_delegate respondsToSelector:@selector(startTimeAction)]) {
        [_delegate startTimeAction];
    }
}

- (IBAction)endTimeButtonAction:(id)sender {
    if ([_delegate respondsToSelector:@selector(endTimeAction)]) {
        [_delegate endTimeAction];
    }
}

- (void)layoutSubviews{
    
}




@end
