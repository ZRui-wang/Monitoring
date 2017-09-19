//
//  SignInView.m
//  Monitore
//
//  Created by kede on 2017/8/4.
//  Copyright © 2017年 kede. All rights reserved.
//

#import "SignInView.h"
#import <UIKit/UIKit.h>

@interface SignInView ()
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIImageView *signInImageView;

@end

@implementation SignInView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    self.bgView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
    
    UITapGestureRecognizer *tab = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tabAction)];
    [self addGestureRecognizer:tab];
}

- (void)hadSigned{
    [self.signInImageView setImage:[UIImage imageNamed:@"已签到"]];
}

- (void)tabAction{
    [self removeFromSuperview];
}


@end
