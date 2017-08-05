//
//  CollectViewController.m
//  Monitore
//
//  Created by kede on 2017/8/4.
//  Copyright © 2017年 kede. All rights reserved.
//

#import "CollectViewController.h"
#import "DIYPickView.h"

@interface CollectViewController ()<UIPickerViewDelegate, UIPickerViewDataSource, UIActionSheetDelegate>
@property (weak, nonatomic) IBOutlet UITextField *number;
@property (weak, nonatomic) IBOutlet UILabel *colour;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;

@property (weak, nonatomic) IBOutlet UILabel *numberTitle;
@property (weak, nonatomic) IBOutlet UILabel *colorTitle;
@property (weak, nonatomic) IBOutlet UILabel *addressTitle;
@property (weak, nonatomic) IBOutlet UIImageView *collectImageView;

@property (strong, nonatomic)DIYPickView *selectColorView;
@property (strong, nonatomic)UIView *pickBgView;
@end

@implementation CollectViewController{
    NSArray *colorAry;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"车辆采集";
    [self leftCustomBarButton];
    [self fuwenbenLabel:self.numberTitle FontNumber:14 AndRange:NSMakeRange(4, 1) AndColor:[UIColor redColor]];
    [self fuwenbenLabel:self.colorTitle FontNumber:14 AndRange:NSMakeRange(4, 1) AndColor:[UIColor redColor]];
    [self fuwenbenLabel:self.addressTitle FontNumber:14 AndRange:NSMakeRange(4, 1) AndColor:[UIColor redColor]];
    
    colorAry = @[@"蓝色", @"黄色", @"绿色", @"黑色", @"白色"];
    
    [[Tools sharedTools]getCurrentAddress:^(NSString *address) {
        self.addressLabel.text = address;
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)selectColourBtnAction:(id)sender {
    [self creatPickerView];
}

- (IBAction)refreshAddressBtnAction:(id)sender {
}

- (IBAction)submitButtonAction:(id)sender {
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
    self.colour.text = colorAry[row];
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
    self.colour.text = colorAry[0];
    
    [self.selectColorView.cancelButton addTarget:self action:@selector(buttonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.selectColorView.confirmButton addTarget:self action:@selector(buttonAction) forControlEvents:UIControlEventTouchUpInside];
}

//设置不同字体颜色
-(void)fuwenbenLabel:(UILabel *)labell FontNumber:(NSInteger)font AndRange:(NSRange)range AndColor:(UIColor *)vaColor
{
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:labell.text];
    //设置字号
    [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:font] range:range];
    //设置文字颜色
    [str addAttribute:NSForegroundColorAttributeName value:vaColor range:range];
    labell.attributedText = str;
}

- (void)buttonAction{
    [self.pickBgView removeFromSuperview];
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
