//
//  CarouselFigure.m
//  eShop
//
//  Created by kede on 16/6/20.
//  Copyright © 2016年 Keede. All rights reserved.
//

#import "CarouselFigure.h"
#import "UIImageView+WebCache.h"
#import "BrandScroll.h"
#import "BannerModel.h"

@interface CarouselFigure()<UIScrollViewDelegate,UIGestureRecognizerDelegate>

@property (nonatomic,strong)UIPageControl *pageControl;
@property (nonatomic,strong)UILabel *text;
@property (nonatomic,strong)NSMutableArray *curArray;

@end

@implementation CarouselFigure
{
//    CGFloat width;
    CGFloat height;
    NSInteger curPage;
    NSInteger timeCount;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        _width = frame.size.width;
        height = frame.size.height;
        self.curArray = [NSMutableArray arrayWithCapacity:3];
        
        [self initScrollView];
        
        // 轮播图文本
        [self initTextView];
        [self initPageControl];
        [self.curArray addObject:@"轮播图1"];
        [self.curArray addObject:@"轮播图2"];
        [self.curArray addObject:@"轮播图3"];
//        self.array = self.curArray;
//        self.array = @[@"轮播图1", @"轮播图2", @"轮播图3"];
    }
    return self;
}

// 初始化滚动视图
- (void)initScrollView{
    self.scrollView = [[BrandScroll alloc]initWithFrame:self.bounds];
    self.scrollView.contentSize = CGSizeMake(_width *3, height);
    self.scrollView.contentOffset = CGPointMake(_width, 0);
    self.scrollView.delegate = self;
    self.scrollView.pagingEnabled = YES;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    [self creatCarouseFigureView];
    __weak typeof(*&self) weakSelf = self;
    self.scrollView.zanTingBlock = ^{
        [weakSelf.timer setFireDate:[NSDate distantFuture]];//暂停
    };
    
    self.scrollView.jiXuBlock = ^ {
        [weakSelf.timer setFireDate:[NSDate distantPast]];//继续
    };
    [self addSubview:self.scrollView];
    
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(btnAction:)];
    tap.delegate = self;
    [self.scrollView addGestureRecognizer:tap];
}



// 点击事件
- (void)btnAction:(UITapGestureRecognizer *)btn
{
    if (curPage < self.array.count) {
    NSLog(@"第几张图：%ld", curPage);
    }
}

// 创建三个视图到轮播上
- (void)creatCarouseFigureView{
    for (int i = 0; i < 3; i++) {
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(_width *i, 0, _width, height)];
        imageView.contentMode = UIViewContentModeScaleToFill;
        [self.scrollView addSubview:imageView];
    }
}
// 初始化文本视图
- (void)initTextView
{
    self.text = [[UILabel alloc]initWithFrame:CGRectMake((_width-80)/2, 0, 80, 30)];
    self.text.textColor = [UIColor redColor];
    [self addSubview:self.text];
}

// 初始化pageControl视图
- (void)initPageControl
{
    self.pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake((_width - 200)/2, height - 30, 200, 30)];
    self.pageControl.pageIndicatorTintColor = [UIColor whiteColor];
    [self addSubview:self.pageControl];
}

// 更新当前的视图对应的索引
- (NSInteger)updatePage:(NSInteger)page
{
    NSInteger count = self.array.count;
    return  (count + page)%count;
}

// 更新当前对应的视图
- (void)updateCurrentViewWithCurPage:(NSInteger)page
{
    if (!self.array.count) {
        return;
    }
    NSInteger pre = [self updatePage:page - 1];
    curPage = [self updatePage:page];
    NSInteger last = [self updatePage:page + 1];
    [self.curArray removeAllObjects];
    
    [self.curArray addObject:self.array[pre]];
    [self.curArray addObject:self.array[curPage]];
    [self.curArray addObject:self.array[last]];
    
    
    NSArray *subArray = self.scrollView.subviews;
    for (int i = 0; i < MIN(self.array.count, 3); i++) {
        UIImageView *imageView = subArray[i];

        BannerModel *model = self.curArray[i];
        // 从网络上请求数据
        [imageView sd_setImageWithURL:[NSURL URLWithString:model.img]];
    }
    
//    NSLog(@"=====%@", self.curArray[1]);
    self.scrollView.contentOffset = CGPointMake(_width, 0);
    self.pageControl.currentPage = curPage;
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat x = scrollView.contentOffset.x;
    if (x >= _width *2)
    {
        [self updateCurrentViewWithCurPage:curPage+1];
    }
    else if ( x <= 0 )
    {
        [self updateCurrentViewWithCurPage:curPage - 1];
    }
}

- (void)setArray:(NSArray *)array
{
    _array = array;
    if (!_array.count) {
        return;
    }
    self.pageControl.numberOfPages = array.count;
    [self updateCurrentViewWithCurPage:0];
    if (self.timer)
    {
        [self.timer invalidate];
        self.timer = nil;
    }
    self.scrollView.scrollEnabled = NO;
    if (array.count > 1) {
        self.scrollView.scrollEnabled = YES;
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(autoPlay) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];//添加到runloop中
    }
}

- (void)autoPlay
{
    timeCount++;
    if (timeCount == 3)
    {
        timeCount = 0;
        [self.scrollView setContentOffset:CGPointMake(_width * 2,0) animated:YES];
    }

}

-(void)timerStop
{
    if ([_timer isValid]) {
        [_timer invalidate];
        _timer = nil;
    }
}

- (void)timerPause
{
    [self.timer setFireDate:[NSDate distantFuture]];//暂停
    timeCount = 0;
}

- (void)timerContinue
{
    [self.timer setFireDate:[NSDate distantPast]];//继续
    timeCount = 0;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.timer setFireDate:[NSDate distantFuture]];//暂停
    timeCount = 0;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self.timer setFireDate:[NSDate distantPast]];//继续
    timeCount = 0;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end


