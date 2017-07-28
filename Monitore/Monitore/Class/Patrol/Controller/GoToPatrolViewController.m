//
//  GoToPatrolViewController.m
//  Monitore
//
//  Created by kede on 2017/7/27.
//  Copyright © 2017年 kede. All rights reserved.
//

#import "GoToPatrolViewController.h"

@interface GoToPatrolViewController ()
@property (weak, nonatomic) IBOutlet UILabel *patrolAddress;
@property (weak, nonatomic) IBOutlet UILabel *patrolTime;
@property (weak, nonatomic) IBOutlet UIView *mapBagView;

@end

@implementation GoToPatrolViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self leftCustomBarButton];
    self.title = @"我要巡逻";
}
- (IBAction)finishPatrolButtonAction:(id)sender {
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
