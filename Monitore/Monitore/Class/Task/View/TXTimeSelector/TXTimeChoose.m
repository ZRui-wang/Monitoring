//
//  TXTimeChoose.m
//  TYSubwaySystem
//
//  Created by mac on 16/7/18.
//  Copyright © 2016年 TXZhongJiaowang. All rights reserved.
//

#import "TXTimeChoose.h"
#import "SDAutoLayout.h"
#import "UIColor+get_FFFFFFcolor.h"

#define kZero 0
#define kFullWidth [UIScreen mainScreen].bounds.size.width
#define kFullHeight [UIScreen mainScreen].bounds.size.height

@interface TXTimeChoose()
@property (nonatomic,strong)UIDatePicker *dateP;
//类型
@property (nonatomic,assign)UIDatePickerMode type;
@end

@implementation TXTimeChoose
- (instancetype)initWithType:(UIDatePickerMode )type{
    if ([super init]) {
        self.type = type;
        [self addSubviews];
        [self subViewsLayout];
    }
    return self;
}
- (void)addSubviews{
    [self addSubview:self.dateP];
    [self addSubview:self.leftBtn];
    [self addSubview:self.rightBtn];
}
- (UIDatePicker *)dateP{
    if (!_dateP) {
        self.dateP = [UIDatePicker new];
        self.dateP.datePickerMode = self.type;
        self.dateP.locale = [[NSLocale alloc]initWithLocaleIdentifier:@"zh_CHS_CN"];
    }
    return _dateP;
}

- (UIButton *)leftBtn{
    if (!_leftBtn) {
        _leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_leftBtn setTitle:@"取消" forState:UIControlStateNormal];
        [_leftBtn setTitleColor:[UIColor colorWithHexString:@"333333"] forState:UIControlStateNormal];
        [_leftBtn addTarget:self action:@selector(handleDateTopViewLeft) forControlEvents:UIControlEventTouchUpInside];
        _leftBtn.layer.borderWidth = 1;
        _leftBtn.layer.borderColor = [UIColor blueColor].CGColor;
    }
    return _leftBtn;
}

- (UIButton *)rightBtn {
    if (!_rightBtn) {
        _rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_rightBtn setTitleColor:[UIColor colorWithHexString:@"333333"] forState:UIControlStateNormal];
        [_rightBtn setTitle:@"确定" forState:UIControlStateNormal];
        [_rightBtn addTarget:self action:@selector(handleDateTopViewRight) forControlEvents:UIControlEventTouchUpInside];
        _rightBtn.layer.borderWidth = 1;
        _rightBtn.layer.borderColor = [UIColor blueColor].CGColor;
    }
    return _rightBtn;
}
- (void)setType:(UIDatePickerMode)type{
    _type = type;
    self.dateP.datePickerMode = type;
}

- (void)setNowTime:(NSString *)nowTime{
    _nowTime = nowTime;
    [self.dateP setDate:[self dateFromString:nowTime] animated:YES];
}

- (void)setMinDate:(NSDate *)minDate{
    self.dateP.minimumDate = minDate;
}

- (void)setMaxDate:(NSDate *)maxDate{
    self.dateP.maximumDate = maxDate;
}

- (void)handleDateTopViewLeft {
    if (self.cancelBlock) {
        self.cancelBlock();
    }
}

- (void)handleDateTopViewRight {
    if (self.timeBlock) {
        self.timeBlock([self stringFromDate:self.dateP.date]);
    }
}

- (void)subViewsLayout{
    self.leftBtn.sd_layout
    .leftSpaceToView(self, 15)
    .topSpaceToView(self.dateP, 0)
    .heightIs(35)
    .widthIs(kFullWidth/3);
    
    self.rightBtn.sd_layout
    .rightSpaceToView(self, 15)
    .topSpaceToView(self.dateP, 0)
    .heightRatioToView(self.leftBtn, 1)
    .leftSpaceToView(self.leftBtn, 30);
    
    self.dateP.sd_layout
    .leftSpaceToView(self, 0)
    .rightSpaceToView(self, 0)
    .topSpaceToView(self, 0)
    .bottomSpaceToView(self, 40);
}

// NSDate --> NSString
- (NSString*)stringFromDate:(NSDate*)date{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    switch (self.type) {
        case UIDatePickerModeTime:
            [dateFormatter setDateFormat:@"HH:mm"];
            break;
         case UIDatePickerModeDate:
            [dateFormatter setDateFormat:@"yyyy-MM-dd"];
            break;
        case UIDatePickerModeDateAndTime:
            [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
            break;
        case UIDatePickerModeCountDownTimer:
            [dateFormatter setDateFormat:@"HH:mm"];
            break;
        default:
            break;
    }
    NSString *destDateString = [dateFormatter stringFromDate:date];
    
    return destDateString;
    
}

//NSDate <-- NSString
- (NSDate*)dateFromString:(NSString*)dateString{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    switch (self.type) {
        case UIDatePickerModeTime:
            [dateFormatter setDateFormat:@"HH:mm"];
            break;
        case UIDatePickerModeDate:
            [dateFormatter setDateFormat:@"yyyy-MM-dd"];
            break;
        case UIDatePickerModeDateAndTime:
            [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
            break;
        case UIDatePickerModeCountDownTimer:
            [dateFormatter setDateFormat:@"HH:mm"];
            break;
        default:
            break;
    }
    NSDate *destDate= [dateFormatter dateFromString:dateString];
    
    return destDate;
}


@end
