//
//  UIViewController+Dialog.h
//  BaiShop
//
//  Created by llj on 2017/2/16.
//  Copyright © 2017年 BaiXiu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (Dialog)

//MARK: - HUD提示

/**
 成功提示

 @param msg 提示语
 */
- (void)showSuccessMessage:(NSString *)msg;

/**
 失败提示

 @param msg 提示语
 */
- (void)showErrorMessage:(NSString *)msg;

/**
 警告提示
 
 @param msg 提示语
 */
- (void)showWarningMessage:(NSString *)msg;

/**
 加载提示

 @param status 提示语
 */
- (void)showWithStatus:(NSString *)status;

/**
 移除加载提示
 */
- (void)removeLoadingHUD;

//MARK: - Toast提示

//MARK: - AlertView提示
- (void)showAlertViewWithMessage:(NSString *)message;

@end
