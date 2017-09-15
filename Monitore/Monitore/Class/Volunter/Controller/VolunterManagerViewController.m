//
//  InfoViewController.m
//  Monitore
//
//  Created by kede on 2017/7/26.
//  Copyright © 2017年 kede. All rights reserved.
//

#import "VolunterManagerViewController.h"
#import "VolunteersListViewController.h"
#import "VolunterMapViewController.h"
#import "InfoTableViewCell.h"

@interface VolunterManagerViewController ()<UIScrollViewDelegate>

@property (strong, nonatomic)VolunteersListViewController *volunteerVc;
@property (strong, nonatomic)VolunterMapViewController *volunteerMapVc;
@property (weak, nonatomic) IBOutlet UIButton *listButton;
@property (weak, nonatomic) IBOutlet UIButton *mapButton;
@property (weak, nonatomic) IBOutlet UIView *listLine;
@property (weak, nonatomic) IBOutlet UIView *rightLine;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end

@implementation VolunterManagerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self leftCustomBarButton];
    self.title = @"志愿者管理";
    
    [self configureScrollView];
    [self.scrollView.panGestureRecognizer requireGestureRecognizerToFail:self.navigationController.interactivePopGestureRecognizer];
}

- (void)configureScrollView
{
    [self.view layoutIfNeeded];
    self.volunteerVc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"VolunteersListViewController"];
    self.volunteerMapVc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"VolunterMapViewController"];
    [self addChildViewController:self.volunteerVc];
    [self addChildViewController:self.volunteerMapVc];
    self.scrollView.contentSize = CGSizeMake(SCREEN_WIDTH*2, 0);
    self.scrollView.pagingEnabled = true;
    self.scrollView.delegate = self;
    _volunteerVc.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-45);
    [self.scrollView addSubview:self.volunteerVc.view];
    self.rightLine.backgroundColor = [UIColor clearColor];
}


- (IBAction)listButtonAction:(UIButton *)sender {
    
    self.rightLine.backgroundColor = [UIColor clearColor];
    self.mapButton.selected = false;
    sender.selected = true;
    self.listLine.backgroundColor = kDefaultGreenColor;
    [self.scrollView setContentOffset:CGPointMake(0, 0) animated:true];
}


- (IBAction)mapButtonAction:(UIButton *)sender {
    
    self.listLine.backgroundColor = [UIColor clearColor];
    self.listButton.selected = false;
    sender.selected = true;
    self.rightLine.backgroundColor = kDefaultGreenColor;
    [self.scrollView setContentOffset:CGPointMake(SCREEN_WIDTH, 0) animated:true];
    
    if (!self.volunteerMapVc.isViewLoaded) {
        self.volunteerMapVc.view.frame = CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT-45);
        [self.scrollView addSubview:self.volunteerMapVc.view];
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.x == 0) {
        [self listButtonAction:self.listButton];
    }else if (scrollView.contentOffset.x == SCREEN_WIDTH){
        [self mapButtonAction:self.mapButton];
    }
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
