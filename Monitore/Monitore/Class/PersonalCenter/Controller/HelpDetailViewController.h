//
//  HelpDetailViewController.h
//  Monitore
//
//  Created by kede on 2017/11/8.
//  Copyright © 2017年 kede. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface HelpDetailViewController : BaseViewController
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (assign,nonatomic) NSInteger  helpId;

@end
