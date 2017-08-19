//
//  CarouselFigure.h
//  eShop
//
//  Created by kede on 16/6/20.
//  Copyright © 2016年 Keede. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BrandScroll;
@interface CarouselFigure : UIView

@property (nonatomic,strong)NSArray *array;
@property (nonatomic,strong)NSTimer *timer;
@property (nonatomic,strong)BrandScroll *scrollView;
@property (nonatomic, assign)CGFloat width;

- (void)autoPlay;

- (void)timerStop;

- (void)timerPause;

- (void)timerContinue;

@end


