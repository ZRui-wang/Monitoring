//
//  CollectViewController.m
//  Monitore
//
//  Created by kede on 2017/8/4.
//  Copyright © 2017年 kede. All rights reserved.
//

#import "CollectViewController.h"
#import "DIYPickView.h"

@interface CollectViewController ()<UIPickerViewDelegate, UIPickerViewDataSource, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *colour;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;

@property (weak, nonatomic) IBOutlet UILabel *colorTitle;
@property (weak, nonatomic) IBOutlet UILabel *addressTitle;
@property (weak, nonatomic) IBOutlet UIImageView *collectImageView;
@property (weak, nonatomic) IBOutlet UIButton *takePhotoButton;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textViewHeigh;

@property (strong, nonatomic)DIYPickView *selectColorView;
@property (strong, nonatomic)UIView *pickBgView;
@end

@implementation CollectViewController{
    NSArray *colorAry;
}

- (void)dealloc{
    NSLog(@"销毁啦哈哈");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"我要救援";
    [self leftCustomBarButton];

    [self fuwenbenLabel:self.colorTitle FontNumber:14 AndRange:NSMakeRange(2, 1) AndColor:[UIColor redColor]];
    [self fuwenbenLabel:self.addressTitle FontNumber:14 AndRange:NSMakeRange(4, 1) AndColor:[UIColor redColor]];
    
    colorAry = @[@"蓝色", @"黄色", @"绿色", @"黑色", @"白色"];
    
    __block typeof(self) weak = self;
    [[Tools sharedTools]getCurrentAddress:^(NSString *address) {
        weak.addressLabel.text = address;
    }];

    self.textView.delegate = self;
    self.textView.scrollEnabled = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)selectColourBtnAction:(id)sender {
    [self creatPickerView];
}

- (IBAction)refreshAddressBtnAction:(id)sender {
    
    __block typeof(self) weak = self;
    [[Tools sharedTools]getCurrentAddress:^(NSString *address) {
        weak.addressLabel.text = address;
    }];
}

- (IBAction)submitButtonAction:(id)sender {
}

- (IBAction)takePhotoButtonAction:(UIButton *)sender {
    UIImagePickerController *picker = [[UIImagePickerController alloc]init];
    picker.delegate = self;
    picker.allowsEditing = NO;
    
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    [self presentViewController:picker animated:YES completion:nil];
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

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];//按回车取消第一相应者
    }
    return YES;
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{//将要停止编辑(不是第一响应者时)
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView
{
    CGRect bounds = textView.bounds;
    // 计算 text view 的高度
    CGSize maxSize = CGSizeMake(bounds.size.width, CGFLOAT_MAX);
    CGSize newSize = [textView sizeThatFits:maxSize];
    bounds.size = newSize;
    textView.bounds = bounds;
    self.textViewHeigh.constant = textView.bounds.size.height;
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

/***打开相册*/
-(void)openPhotoLibrary{
    // 进入相册
    
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
        
    {
        
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc]init];
        
        imagePicker.allowsEditing = YES;
        
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        
        imagePicker.delegate = self;
        
        [self presentViewController:imagePicker animated:YES completion:^{
            
            NSLog(@"打开相册");
            
        }];
        
    }
    
    else
        
    {
        
        NSLog(@"不能打开相册");
        
    }
    
}



#pragma mark - UIImagePickerControllerDelegate

// 拍照完成回调

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(nullable NSDictionary<NSString *,id> *)editingInfo NS_DEPRECATED_IOS(2_0, 3_0)

{
    
    NSSLog(@"finish..");
    
    self.collectImageView.image = image;
    
//    if(picker.sourceType == UIImagePickerControllerSourceTypeCamera)
//        
//    {
//        
//        //图片存入相册
//        
//        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
//        
//    }
    
    
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

//进入拍摄页面点击取消按钮

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker

{
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
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
