//
//  DLAlertView.m
//  Dualens
//
//  Created by kede on 2017/2/16.
//  Copyright © 2017年 JK. All rights reserved.
//

#import "DLAlertView.h"

@interface DLAlertView ()
{
    CGFloat mWidth;
    CGFloat mBtnWidth;
    CGFloat mHeight;
    CGFloat mBtnHeight;
    CGFloat mHeaderHeight;
}
@property (nonatomic, strong) NSString       *cancelButtonTitle;
@property (nonatomic, strong) NSMutableArray *otherButtonTitles;

@end
@implementation DLAlertView
{
    BOOL kAlertState;
}

static const CGFloat mMaxHeight    = 280;

//static const CGFloat mBtnHeight    = 50;
//static const CGFloat mHeaderHeight = 50;


- (NSMutableArray *)customerViewsToBeAdd
{
    if (_customerViewsToBeAdd == nil)
    {
        _customerViewsToBeAdd = [[NSMutableArray alloc] init];
    }
    
    return _customerViewsToBeAdd;
}

- (id)initWithTitle:(NSString*)title message:(NSString*)message delegate:(id)del cancelButtonTitle:(NSString*)cancelBtnTitle otherButtonTitles:(NSString*)otherBtnTitles, ...
{
    self = [super initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT + 20)];
    self.isNotCancle = NO;
    if (self)
    {
        mWidth = MAX(SCREEN_WIDTH * 0.7, 260);
        mBtnWidth = mWidth / 2;
        mHeight = MAX(mWidth * 17 /27 * (SCREEN_WIDTH/414), 170);
        mBtnHeight = MAX(50 * (SCREEN_WIDTH/414), 45);
        
        //        NSLog(@"SCREEN_WIDTH: %.f  SCREEN_HEIGHT:%.f  mHeight:%.f",SCREEN_WIDTH,SCREEN_HEIGHT,mHeight);
        mHeaderHeight = mBtnHeight;
        //        NSLog(@"%f --%f--- %f",mWidth,mHeight,mBtnHeight);
        self.delegate = del;
        self.cancelButtonTitle = cancelBtnTitle;
        self.isNeedCloseBtn = NO;
        
        if (!_otherButtonTitles)
        {
            //            va_list argList;
            if (otherBtnTitles)
            {
                self.otherButtonTitles = [NSMutableArray array];
                [self.otherButtonTitles addObject:otherBtnTitles];
            }
            //            va_start(argList, otherBtnTitles);
            //            id arg;
            //            while ((arg = va_arg(argList, id)))
            //            {
            //                [self.otherButtonTitles addObject:arg];
            //            }
        }
        self.title = title;
        self.message = message;
        
    }
    return self;
}

- (void) layoutSubviews
{
    [super layoutSubviews];
    
    for (UIView *view in [self subviews])
    {
        [view removeFromSuperview];
    }
    
    UIView *bgView = [[UIView alloc] initWithFrame:self.frame];
    [bgView setBackgroundColor:[UIColor blackColor]];
    [bgView setAlpha:0.4];
    [self addSubview:bgView];
    
    if (!_backView)
    {
        _backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, mWidth, mHeight)];
        _backView.backgroundColor     = [UIColor whiteColor];
        _backView.layer.cornerRadius = 8;
    }
    
    // - 设置头部显示区域
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, mWidth, mHeaderHeight)];
    if (self.title && [self.title length] > 0)
    {
        //创建头部区域的横线
        UILabel *upline = [[UILabel alloc] initWithFrame:CGRectMake(0, titleView.bottom - 1, titleView.width, 1)];
        upline.backgroundColor = [UIColor lightGrayColor];
        upline.alpha = 0.3;
        [titleView addSubview:upline];
        
        // - 标题
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, (titleView.height - 20) / 2, titleView.width, 20)];
        titleLabel.text = self.title;
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.font = [UIFont systemFontOfSize:17];
//        titleLabel.textColor = kDefaultGreenColor;
        titleLabel.backgroundColor = [UIColor clearColor];
        self.titleLabel = titleLabel;
        
        [titleView addSubview:titleLabel];
    }
    if (self.isNeedCloseBtn)
    {
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(mWidth-30, (mHeaderHeight - 20)/2, 20,20)];
        btn.backgroundColor = [UIColor clearColor];
#warning 此处设置右上角删除按钮的图片
        [btn setImage:[UIImage imageNamed:@"btn_color_close"] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(closeBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [titleView addSubview:btn];
    }
    
    [_backView addSubview:titleView];
    self.titleBackgroundView = titleView;
    
    // - 设置消息显示区域
    UIScrollView *msgView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, mHeaderHeight, mWidth, (mHeight-mHeaderHeight * 2))];
    
    // - 设置背景颜色
    msgView.backgroundColor = [UIColor whiteColor];
    
    // - 内容
    CGSize messageSize = CGSizeZero;
    if (self.message && [self.message length]>0)
    {
        messageSize = [self.message boundingRectWithSize:CGSizeMake(mWidth-20, MAXFLOAT) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15.0f]} context:nil].size;
        
        if (messageSize.width > 0)
        {
            UILabel *msgLabel = [[UILabel alloc] init];
            msgLabel.font = [UIFont systemFontOfSize:15.0f];
            msgLabel.text = self.message;
            msgLabel.numberOfLines   = 0;
            msgLabel.textAlignment   = NSTextAlignmentCenter;
            msgLabel.backgroundColor = [UIColor clearColor];
            msgLabel.frame = CGRectMake(10, ((mHeight - mHeaderHeight * 2) - messageSize.height) / 2, mWidth-20, messageSize.height + 5);
            if(messageSize.height > mMaxHeight)
            {
                msgView.frame = CGRectMake(msgView.frame.origin.x, msgView.frame.origin.y, msgView.frame.size.width, mMaxHeight + 25);
                _backView.frame = CGRectMake(0, 0, mWidth, mHeaderHeight * 2 + msgView.frame.size.height);
                msgLabel.textAlignment = NSTextAlignmentLeft;
                msgLabel.frame = CGRectMake(10, 10, mWidth - 20, messageSize.height);
                msgView.contentSize = CGSizeMake(msgView.frame.size.width, msgLabel.frame.size.height + 20);
            }
            else if (messageSize.height > (mHeight-mHeaderHeight * 2) - 10)
            {
                msgView.frame = CGRectMake(msgView.frame.origin.x, msgView.frame.origin.y, msgView.frame.size.width, messageSize.height + 25);
                _backView.frame = CGRectMake(0, 0, mWidth, mHeaderHeight * 2 + msgView.frame.size.height);
                msgLabel.frame = CGRectMake(10, 10, mWidth - 20, messageSize.height + 5);
            }
            [msgView addSubview:msgLabel];
            [_backView addSubview:msgView];
        }
    }else{
        if (self.customerViewsToBeAdd && [self.customerViewsToBeAdd count] > 0)
        {
            CGFloat startY = 0;
            for (UIView *subView in self.customerViewsToBeAdd)
            {
                CGRect rect = subView.frame;
                rect.origin.y = startY;
                subView.frame = rect;
                [msgView addSubview:subView];
                startY += rect.size.height;
            }
            msgView.frame = CGRectMake(0, mHeaderHeight, mWidth, startY);
        }
        [_backView addSubview:msgView];
        _backView.frame = CGRectMake(0, 0, mWidth, msgView.frame.size.height + mHeaderHeight * 2 +20);
    }
    
    // - 设置按钮显示区域
    if (_otherButtonTitles != nil || _cancelButtonTitle != nil)
    {
        UIView *btnView = [[UIView alloc] initWithFrame:CGRectMake(0, _backView.frame.size.height-mHeaderHeight, mWidth, mHeaderHeight)];
        
        // - 如果只显示一个按钮,需要计算按钮的显示大小
        if (_otherButtonTitles == nil || _cancelButtonTitle == nil)
        {
            UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, btnView.width, 1)];
            line.backgroundColor = [UIColor lightGrayColor];
            line.alpha = 0.3;
            [btnView addSubview:line];
            
            UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, _backView.frame.size.width, mBtnHeight)];
            btn.titleLabel.font = [UIFont systemFontOfSize:15];
            [btn setTitleColor:kDefaultGrayColor forState:UIControlStateNormal];
            [btn setTitleColor:kDefaultGreenColor forState:UIControlStateHighlighted];
            [btn addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
            if (_otherButtonTitles == nil && _cancelButtonTitle != nil)
            {
                [btn setTitle:_cancelButtonTitle forState:UIControlStateNormal];
            } else
            {
                [btn setTitle:[_otherButtonTitles objectAtIndex:0] forState:UIControlStateNormal];
            }
            btn.tag = 0;
            btn.layer.cornerRadius = 5;
            [btnView addSubview:btn];
        }else if(_otherButtonTitles && [_otherButtonTitles count] == 1)
        {
            //按钮区域顶部的横线
            UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, btnView.width, 1)];
            line.backgroundColor = [UIColor lightGrayColor];
            line.alpha = 0.3;
            [btnView addSubview:line];
            //显示两个按钮时中间的竖线
            
            UILabel *verticalLine = [[UILabel alloc] initWithFrame:CGRectMake(btnView.centerX, 0, 1, btnView.height)];
            verticalLine.backgroundColor = [UIColor lightGrayColor];
            verticalLine.alpha = 0.3;
            [btnView addSubview:verticalLine];
            
            // - 显示两个按钮
            
            
            // - 设置取消按钮的相关属性
            UIButton *cancelBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, mBtnWidth, mBtnHeight)];
            cancelBtn.titleLabel.font = [UIFont systemFontOfSize:15];
            [cancelBtn setTitleColor:kDefaultGrayColor forState:UIControlStateNormal];
            [cancelBtn setTitleColor:kDefaultGreenColor forState:UIControlStateHighlighted];
            [cancelBtn setTitle:_cancelButtonTitle forState:UIControlStateNormal];
            cancelBtn.layer.cornerRadius = 5;
            [cancelBtn addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
            cancelBtn.tag = 0;
            //            NSLog(@"cancelBtn.tag = %ld",cancelBtn.tag);
            [btnView addSubview:cancelBtn];
            
            // - 设置确定按钮的相关属性
            UIButton *otherBtn = [[UIButton alloc]initWithFrame:CGRectMake(mWidth/2,0 , mBtnWidth, mBtnHeight)];
            otherBtn.titleLabel.font = [UIFont systemFontOfSize:15];
            [otherBtn setTitleColor:kDefaultGrayColor forState:UIControlStateNormal];
            [otherBtn setTitleColor:kDefaultGreenColor forState:UIControlStateHighlighted];
            [otherBtn setTitle:[_otherButtonTitles objectAtIndex:0] forState:UIControlStateNormal];
            otherBtn.layer.cornerRadius = 5;
            [otherBtn addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
            otherBtn.tag = 1;
            //            NSLog(@"otherBtn.tag = %ld",otherBtn.tag);
            [btnView addSubview:otherBtn];
        }
        [_backView addSubview: btnView];
    }
    else
    {
        
        UIView *btnView = [[UIView alloc] initWithFrame:CGRectMake(0, _backView.frame.size.height-mHeaderHeight, mWidth, mHeaderHeight)];
        [_backView addSubview: btnView];
        
    }
    
    UIControl *touchView = [[UIControl alloc] initWithFrame:self.frame];
    [touchView addTarget:self action:@selector(touchViewClickDown) forControlEvents:UIControlEventTouchDown];
    touchView.frame = self.frame;
    [self addSubview:touchView];
    _backView.center = self.center;
    
    
    [self addSubview:_backView];
    
}
- (void)touchViewClickDown
{
    if (self.delegate)
    {
        if ([self.delegate respondsToSelector:@selector(hideCurrentKeyBoard)])
        {
            [self.delegate hideCurrentKeyBoard];
        }
    }
}

// - 在消息区域设置自定义控件
- (void)addCustomerSubview:(UIView *)view
{
    [self.customerViewsToBeAdd addObject:view];
}

- (void)buttonClicked:(id)sender
{
    UIButton *btn = (UIButton *) sender;
    if (btn)
    {
        if (self.delegate && [self.delegate respondsToSelector:@selector(alertView:clickedButtonAtIndex:)])
        {
            [self.delegate alertView:self clickedButtonAtIndex:btn.tag];
        }
        if (!self.isNotCancle) {
            [self removeFromSuperview];
            kAlertState = NO;
        }
    }
}

- (void)closeBtnClicked:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(alertViewClosed:)])
    {
        [self.delegate alertViewClosed:self];
    }
    [self removeFromSuperview];
    kAlertState = NO;
}

- (void)show
{
    //    [self layoutSubviews];
    //此处用来防止出现弹出多个提示
    if (kAlertState) {
        return;
    }
    [[[UIApplication sharedApplication].delegate window]  addSubview:self];
    kAlertState = YES;
}

- (void)dealloc
{
    NSLog(@"AlertView销毁");
    self.titleLabel = nil;
    self.titleBackgroundView = nil;
}


@end
