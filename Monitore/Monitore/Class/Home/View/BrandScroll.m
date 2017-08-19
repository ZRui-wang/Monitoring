//
//  BrandScroll.m
//  eShop
//
//  Created by kede1 on 16/8/2.
//  Copyright © 2016年 Keede. All rights reserved.
//

#import "BrandScroll.h"

@implementation BrandScroll

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    NSLog(@"轮播暂停");
    if (self.zanTingBlock) {
        self.zanTingBlock();
    }
    //    [self.timer setFireDate:[NSDate distantFuture]];//暂停
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    NSLog(@"轮播继续");
    //    [self.timer setFireDate:[NSDate distantPast]];//继续
    if (self.jiXuBlock) {
        self.jiXuBlock();
    }
}


@end
