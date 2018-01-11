//
//  CollectViewController.m
//  Monitore
//
//  Created by kede on 2017/8/4.
//  Copyright © 2017年 kede. All rights reserved.
//

#import "CollectViewController.h"
#import "DIYPickView.h"
#import "AddContactViewController.h"
#import "LinkerModel.h"
#import "VolunterManagerViewController.h"
//#import "QNUploadManager.h"
//#import "QNConfiguration.h"
#import "QiniuSDK.h"

@interface CollectViewController ()<UIPickerViewDelegate, UIPickerViewDataSource, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *colour;
@property (strong, nonatomic) UILabel *addressLabel;

@property (weak, nonatomic) IBOutlet UILabel *colorTitle;
@property (weak, nonatomic) IBOutlet UIImageView *collectImageView;
@property (weak, nonatomic) IBOutlet UIButton *takePhotoButton;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textViewHeigh;
@property (weak, nonatomic) IBOutlet UILabel *addressTitle;

@property (strong, nonatomic) UIImagePickerController *picker;

@property (strong, nonatomic)DIYPickView *selectColorView;
@property (strong, nonatomic)UIView *pickBgView;

@property (strong, nonatomic) LinkerModel *linkerModel;

@property (copy, nonatomic)NSString *lat;
@property (copy, nonatomic)NSString *lon;
@property (strong, nonatomic)NSData *imageData;
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
    [self rightCustomBarButton];
    
    self.addressLabel = [[UILabel alloc]init];

//    [self fuwenbenLabel:self.colorTitle FontNumber:14 AndRange:NSMakeRange(2, 1) AndColor:[UIColor redColor]];
//    [self fuwenbenLabel:self.addressTitle FontNumber:14 AndRange:NSMakeRange(4, 1) AndColor:[UIColor redColor]];
    
    colorAry = @[@"蓝色", @"黄色", @"绿色", @"黑色", @"白色"];
    
    __block typeof(self) weak = self;
    [[Tools sharedTools]getCurrentAddress:^(NSString *address) {
        weak.addressLabel.text = address;
        weak.addressTitle.text = [NSString stringWithFormat:@"救援地址:%@", address];
        [weak getGeoCoedAddress:address];
    }];

    self.textView.delegate = self;
    self.textView.scrollEnabled = NO;
    
    self.userTitle = [Tools getPersonData];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self getUngentLink];
}

- (void)getUngentLink{
    
    UserTitle *userTitle = [Tools getPersonData];
    
    NSDictionary *dic = @{@"ID":userTitle.usersId};
    
    __block typeof(self) weak = self;
    [[DLAPIClient sharedClient]POST:@"getUngentLink" parameters:dic success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSLog(@"紧急联系人=%@", responseObject);
        
        if ([responseObject[Kstatus]isEqualToString:Ksuccess]) {
            weak.linkerModel = [LinkerModel modelWithDictionary:responseObject[@"user"]];
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self showErrorMessage:@"网络错误"];
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
    
    __block typeof(self) weak = self;
    [[Tools sharedTools]getCurrentAddress:^(NSString *address) {
        weak.addressLabel.text = address;
        [weak getGeoCoedAddress:address];
    }];
}

- (void)getGeoCoedAddress:(NSString *)address{
    CLGeocoder *myGeocoder = [[CLGeocoder alloc] init];
    [myGeocoder geocodeAddressString:address completionHandler:^(NSArray *placemarks, NSError *error) {
        if ([placemarks count] > 0 && error == nil) {
            NSLog(@"Found %lu placemark(s).", (unsigned long)[placemarks count]);
            CLPlacemark *firstPlacemark = [placemarks objectAtIndex:0];
            NSLog(@"Longitude = %f", firstPlacemark.location.coordinate.longitude);
            NSLog(@"Latitude = %f", firstPlacemark.location.coordinate.latitude);
            
            self.lon = [NSString stringWithFormat:@"%f", firstPlacemark.location.coordinate.longitude];
            self.lat = [NSString stringWithFormat:@"%f", firstPlacemark.location.coordinate.latitude];
            
        }
        else if ([placemarks count] == 0 && error == nil) {
            NSLog(@"Found no placemarks.");
        } else if (error != nil) {
            NSLog(@"An error occurred = %@", error);
        }
    }];
}

- (IBAction)submitButtonAction:(id)sender {
    
    if ([Tools checkLimitLocation]) {
        
    }else{
        [self showWarningMessage:@"定位失败，检查是否有定位权限"];
        return;
    }
    
    if (!self.linkerModel.urgentMobile) {
        [self showWarningMessage:@"请添加紧急联系人"];
        return;
    }
    
    //创建AlertController对象 preferredStyle可以设置是AlertView样式或者ActionSheet样式
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:nil message:@"请上传救援现场的视频" preferredStyle:UIAlertControllerStyleActionSheet];
    //创建取消按钮
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alertC addAction:action1];
    
    __block typeof(self) weak = self;
    UIAlertAction *photos = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        weak.picker.allowsEditing = NO;
        
        weak.picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [weak presentViewController:self.picker animated:YES completion:nil];
    }];
//    [alertC addAction:photos];
    
    UIAlertAction *video = [UIAlertAction actionWithTitle:@"视频" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        weak.picker.delegate = self;
        weak.picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        weak.picker.mediaTypes = @[(NSString *)kUTTypeMovie];
        weak.picker.videoMaximumDuration = 10;
        weak.picker.videoQuality = UIImagePickerControllerQualityTypeMedium;
        [weak presentViewController:self.picker animated:YES completion:nil];
    }];
    [alertC addAction:video];
    
    //显示
    [self presentViewController:alertC animated:YES completion:nil];
    
    
    return;
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

////设置不同字体颜色
//-(void)fuwenbenLabel:(UILabel *)labell FontNumber:(NSInteger)font AndRange:(NSRange)range AndColor:(UIColor *)vaColor
//{
//    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:labell.text];
//    //设置字号
//    [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:font] range:range];
//    //设置文字颜色
//    [str addAttribute:NSForegroundColorAttributeName value:vaColor range:range];
//    labell.attributedText = str;
//}

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
    else{
        NSLog(@"不能打开相册");
    }
}



#pragma mark - UIImagePickerControllerDelegate

// 拍照完成回调

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage]){
        
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        self.collectImageView.image = image;
        NSSLog(@"finish..");
        
        self.imageData = UIImagePNGRepresentation(image);
    }
    else if ([mediaType isEqualToString:(NSString *)kUTTypeMovie]){
        [self showWithStatus:@"正在上传视频..."];
        NSURL *url = [info objectForKey:UIImagePickerControllerMediaURL];
        NSString *urlStr = [url path];
        
        NSString *token = [[NSUserDefaults standardUserDefaults]objectForKey:@"qntoken"];
        
        QNConfiguration *config = [QNConfiguration build:^(QNConfigurationBuilder *builder) {
            builder.zone = [QNFixedZone zone1];
        }];
        QNUploadManager *upManager = [[QNUploadManager alloc]initWithConfiguration:config];

        [upManager putFile:urlStr key:nil token:token complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
            
            NSLog(@"七牛回调-%@", info);
            NSLog(@"七牛-%@", resp);
            
            NSDictionary *dic = @{@"USER_ID":self.userTitle.usersId,
                                  @"LONGITUDE":self.lon,
                                  @"LATITUDE":self.lat,
                                  @"ADDRESS":self.addressLabel.text,
                                  @"VIDEO_URL":resp[@"key"]
                                  };
            [[DLAPIClient sharedClient]POST:@"gather" parameters:dic success:^(NSURLSessionDataTask *task, id responseObject) {
                if ([responseObject[Kstatus]isEqualToString:Ksuccess]) {
                    [self showSuccessMessage:responseObject[info]];
                    
                    NSMutableString *str=[[NSMutableString alloc] initWithFormat:@"tel:%@",self.linkerModel.urgentMobile];
                    UIWebView *callWebview = [[UIWebView alloc] init];
                    [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
                    [self.view addSubview:callWebview];
                }else
                {
                    [self showErrorMessage:responseObject[Kinfo]];
                }
            } failure:^(NSURLSessionDataTask *task, NSError *error) {
                [self showErrorMessage:@"数据错误"];
                NSLog(@"%@", error);
            }];
        } option:nil];
    }
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


- (void)rightCustomBarButton{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"+紧急联系人" style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButtonAction)];
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor whiteColor];
}

- (void)rightBarButtonAction{
    
    AddContactViewController *goToReprotVc = [[UIStoryboard storyboardWithName:@"Report" bundle:nil]instantiateViewControllerWithIdentifier:@"AddContactViewController"];
    goToReprotVc.linkerModel = self.linkerModel;
    [self.navigationController pushViewController:goToReprotVc animated:YES];
}

- (UIImagePickerController *)picker{
    if (_picker == nil) {
        _picker = [[UIImagePickerController alloc]init];
        _picker.delegate = self;
    }
    return _picker;
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
