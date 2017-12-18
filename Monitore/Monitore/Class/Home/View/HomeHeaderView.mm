//
//  HomeHeaderView.m
//  Monitore
//
//  Created by kede on 2017/7/24.
//  Copyright © 2017年 kede. All rights reserved.
//

#import "HomeHeaderView.h"
#import "CarouselFigure.h"

@interface HomeHeaderView ()

@property (weak, nonatomic) IBOutlet UIView *homeHeaderView;
@end

@implementation HomeHeaderView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code

}

- (void)setBannerAry:(NSMutableArray *)bannerAry{
    _bannerAry = bannerAry;
    
    CarouselFigure *figure = [[CarouselFigure alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH*0.75)];
    figure.array = _bannerAry;
    [self.homeHeaderView addSubview:figure];
}


@end
