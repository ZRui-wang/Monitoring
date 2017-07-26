//
//  PatrolTableHeaderView.m
//  Monitore
//
//  Created by kede on 2017/7/26.
//  Copyright © 2017年 kede. All rights reserved.
//

#import "PatrolTableHeaderView.h"

@interface PatrolTableHeaderView ()
@property (weak, nonatomic) IBOutlet CustomeLabel *title;

@end

@implementation PatrolTableHeaderView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    self.title.textInsets = UIEdgeInsetsMake(0, 15, 0, 15);
}


@end
