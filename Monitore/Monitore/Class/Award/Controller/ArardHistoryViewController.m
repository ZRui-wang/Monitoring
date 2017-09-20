//
//  ArardHistoryViewController.m
//  Monitore
//
//  Created by kede on 2017/9/20.
//  Copyright © 2017年 kede. All rights reserved.
//

#import "ArardHistoryViewController.h"

@interface ArardHistoryViewController ()

@end

@implementation ArardHistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"兑换记录";
    [self leftCustomBarButton];
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
