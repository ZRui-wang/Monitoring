//
//  DLAlertView.h
//  Dualens
//
//  Created by kede on 2017/2/16.
//  Copyright © 2017年 JK. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DLAlertView;
@protocol DLAlertViewDelegate <NSObject>

@optional
// - 代理方法
-(void)alertView:(DLAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;
-(void)alertViewClosed:(DLAlertView *)alertView;

// - 隐藏实用类弹出键盘
- (void)hideCurrentKeyBoard;

@end
@interface DLAlertView : UIView
@property (nonatomic, weak) id <DLAlertViewDelegate> delegate;
@property (nonatomic, assign) BOOL           isNotCancle;//点击按钮时是否不取消alertView;默认取消
@property (nonatomic, assign) BOOL           isNeedCloseBtn;  // - 左上角带叉叉按钮
@property (nonatomic, strong) NSString       *title;
@property (nonatomic, strong) NSString       *message;
@property (nonatomic, strong) UIView         *backView;
@property (nonatomic, strong) UIView         *titleBackgroundView;
@property (nonatomic, strong) UILabel        *titleLabel;
@property (nonatomic, strong) NSMutableArray *customerViewsToBeAdd;

- (id)initWithTitle:(NSString*)title message:(NSString*)message delegate:(id)delegate cancelButtonTitle:(NSString*)cancelButtonTitle otherButtonTitles:(NSString*)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION;
//- (id)initWithResponseObject:(id)responseObject;
- (void)show ;

// - 在alertview中添加自定义控件
- (void)addCustomerSubview:(UIView *)view;

@end
