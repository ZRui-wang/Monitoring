//
//  HelpDetailViewController.m
//  Monitore
//
//  Created by kede on 2017/11/8.
//  Copyright © 2017年 kede. All rights reserved.
//

#import "HelpDetailViewController.h"



@implementation HelpDetailViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    [self leftCustomBarButton];
    
    [self requestData];

}

- (void)requestData{
    [[DLAPIClient sharedClient]POST:[NSString stringWithFormat:@"helpDetail?ID=00%ld", self.helpId] parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSString *htmlStr = [responseObject[@"data"]objectForKey:@"detail"];
        [self.webView loadHTMLString:htmlStr baseURL:nil];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self showErrorMessage:@"网络错误"];
    }];
}



@end
