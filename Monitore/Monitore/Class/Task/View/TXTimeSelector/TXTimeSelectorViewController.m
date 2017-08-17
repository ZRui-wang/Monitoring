//
//  TXTimeSelectorViewController.m
//  Time selector
//
//  Created by mac on 2017/7/19.
//  Copyright © 2017年 TXZhongJiaowang. All rights reserved.
//

#import "TXTimeSelectorViewController.h"
#import "TXTimeChoose.h"
#import "SDAutoLayout.h"

@interface TXTimeSelectorViewController ()

@end

@implementation TXTimeSelectorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setTime];
}

- (void)setTime{
    TXTimeChoose *timeView = [[TXTimeChoose alloc]initWithType:self.mode];
    timeView.maxDate = [NSDate date];
    
    [self.view addSubview:timeView];
    
    timeView.sd_layout.spaceToSuperView(UIEdgeInsetsZero);
    
    
    timeView.cancelBlock = ^{
        [self dismissViewControllerAnimated:YES completion:nil];
    };
    timeView.timeBlock = ^(NSString *timeValue) {
        self.callback(timeValue);
        [self dismissViewControllerAnimated:YES completion:nil];
    };
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
