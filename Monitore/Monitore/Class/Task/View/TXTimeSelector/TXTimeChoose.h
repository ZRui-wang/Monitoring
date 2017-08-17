//
//  TXTimeChoose.h
//  TYSubwaySystem
//
//  Created by mac on 16/7/18.
//  Copyright © 2016年 TXZhongJiaowang. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^timePass) (NSString *timeValue);
typedef void(^timeCancel)();
@interface TXTimeChoose : UIView

- (instancetype)initWithType:(UIDatePickerMode )type;

//取消
@property (nonatomic,strong)UIButton *leftBtn;
//确定
@property (nonatomic,strong)UIButton *rightBtn;
//初始时间(格式与设定type保持一致)
@property (nonatomic,copy)NSString *nowTime;
//确定
@property (nonatomic,copy)timePass timeBlock;
//取消
@property (nonatomic,copy)timeCancel cancelBlock;
//最小时间
@property (nonatomic,strong)NSDate *minDate;
//最大时间
@property (nonatomic,strong)NSDate *maxDate;

@end
