//
//  UIViewController+Dialog.m
//  BaiShop
//
//  Created by llj on 2017/2/16.
//  Copyright © 2017年 JK. All rights reserved.
//

#import "UIViewController+Dialog.h"
#import "SVProgressHUD.h"

@implementation UIViewController (Dialog)

- (void)showSuccessMessage:(NSString *)msg {
    [SVProgressHUD showSuccessWithStatus:msg];
}

- (void)showErrorMessage:(NSString *)msg {
    [SVProgressHUD showErrorWithStatus:msg];
}

- (void)showWarningMessage:(NSString *)msg {
    [SVProgressHUD showInfoWithStatus:msg];
}

- (void)showWithStatus:(NSString *)status {
    [SVProgressHUD showWithStatus:status];
}

- (void)removeLoadingHUD {
    [SVProgressHUD dismiss];
}


- (void)showAlertViewWithMessage:(NSString *)message {
    DLAlertView *alert = [[DLAlertView alloc] initWithTitle:NSLocalizedString(@"提示", nil) message:message delegate:nil cancelButtonTitle:NSLocalizedString(@"确定", nil) otherButtonTitles:nil, nil];
    [alert show];
}

@end
