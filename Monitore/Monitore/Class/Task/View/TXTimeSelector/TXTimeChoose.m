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
        self.leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.leftBtn setTitle:@"取消" forState:UIControlStateNormal];
        [self.leftBtn setTitleColor:[UIColor colorWithHexString:@"333333"] forState:UIControlStateNormal];
        [self.leftBtn addTarget:self action:@selector(handleDateTopViewLeft) forControlEvents:UIControlEventTouchUpInside];
    }
    return _leftBtn;
}

- (UIButton *)rightBtn {
    if (!_rightBtn) {
        self.rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.rightBtn setTitleColor:[UIColor colorWithHexString:@"333333"] forState:UIControlStateNormal];
        [self.rightBtn setTitle:@"确定" forState:UIControlStateNormal];
        [self.rightBtn addTarget:self action:@selector(handleDateTopViewRight) forControlEvents:UIControlEventTouchUpInside];
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
    .leftSpaceToView(self, 8)
    .topSpaceToView(self, 8)
    .heightIs(35)
    .widthIs(kFullWidth/3);
    
    self.rightBtn.sd_layout
    .rightSpaceToView(self, 8)
    .topSpaceToView(self, 8)
    .heightRatioToView(self.leftBtn, 1)
    .widthRatioToView(self.leftBtn, 1);
    
    self.dateP.sd_layout
    .leftSpaceToView(self, 20)
    .rightSpaceToView(self, 20)
    .topSpaceToView(self.leftBtn, 8)
    .bottomSpaceToView(self, 8);
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
