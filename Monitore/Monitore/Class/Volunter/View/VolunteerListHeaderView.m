//
//  VolunteerListHeaderView.m
//  Monitore
//
//  Created by kede on 2017/9/20.
//  Copyright © 2017年 kede. All rights reserved.
//

#import "VolunteerListHeaderView.h"

@interface VolunteerListHeaderView ()


@end

@implementation VolunteerListHeaderView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    self.backgroundColor = [UIColor whiteColor];
}

- (IBAction)expandButtonAction:(id)sender {
    
    if ([_delegate respondsToSelector:@selector(expandSection:isExpand:)]) {
        [_delegate expandSection:self.headerSecction isExpand:YES];
    }
}

@end
