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
#import "DIYPickView.h"

@interface VolunterManagerViewController ()<UIScrollViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource>

@property (strong, nonatomic)VolunteersListViewController *volunteerVc;
@property (strong, nonatomic)VolunterMapViewController *volunteerMapVc;
@property (weak, nonatomic) IBOutlet UIButton *listButton;
@property (weak, nonatomic) IBOutlet UIButton *mapButton;
@property (weak, nonatomic) IBOutlet UIView *listLine;
@property (weak, nonatomic) IBOutlet UIView *rightLine;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (strong, nonatomic)DIYPickView *selectColorView;
@property (strong, nonatomic)UIView *pickBgView;

@end

@implementation VolunterManagerViewController{
    NSArray *colorAry;
    NSInteger pickFlag;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self leftCustomBarButton];
    self.title = @"志愿者管理";
    
    [self configureScrollView];
    [self.scrollView.panGestureRecognizer requireGestureRecognizerToFail:self.navigationController.interactivePopGestureRecognizer];
    
    colorAry = @[@"尧沟", @"南郝", @"城关", @"朱刘", @"五图", @"红河", @"马宋"];
    pickFlag = 2;
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
    self.scrollView.scrollEnabled = NO;
    self.scrollView.delegate = self;
    _volunteerVc.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-45);
    [self.scrollView addSubview:self.volunteerVc.view];
    self.rightLine.backgroundColor = [UIColor clearColor];
    
    self.listButton.selected = YES;
}


- (IBAction)listButtonAction:(UIButton *)sender {

    pickFlag ++;
    if (pickFlag>2) {
        [self creatPickerView];
    }
    
    self.rightLine.backgroundColor = [UIColor clearColor];
    self.mapButton.selected = false;
    sender.selected = true;
    self.listLine.backgroundColor = kDefaultGreenColor;
    [self.scrollView setContentOffset:CGPointMake(0, 0) animated:true];
    

}


- (IBAction)mapButtonAction:(UIButton *)sender {
    pickFlag = 0;
    [self.pickBgView removeFromSuperview];
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

- (void)creatPickerView{
    self.pickBgView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT-200-64, SCREEN_WIDTH, 200)];
    [self.view addSubview:_pickBgView];
    
    self.selectColorView = [DIYPickView xibView];
    self.selectColorView.size = _pickBgView.size;
    [_pickBgView addSubview: self.selectColorView];
    self.selectColorView.pickerView.delegate = self;
    self.selectColorView.pickerView.dataSource = self;
    [self.selectColorView.pickerView selectRow:0 inComponent:0 animated:YES];
    
    [self.selectColorView.cancelButton addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
    [self.selectColorView.confirmButton addTarget:self action:@selector(confirmAction) forControlEvents:UIControlEventTouchUpInside];
}

- (void)cancelAction{
    [self.pickBgView removeFromSuperview];
}

- (void)confirmAction{
    [self.pickBgView removeFromSuperview];
    
    // 进行数据请求
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return 5;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return colorAry[row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
//    self.colour.text = colorAry[row];
    [self.listButton setTitle:colorAry[row] forState:UIControlStateNormal];
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
