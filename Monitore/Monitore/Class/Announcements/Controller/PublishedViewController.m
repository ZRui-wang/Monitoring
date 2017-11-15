//
//  PublishedViewController.m
//  Monitore
//
//  Created by kede on 2017/11/3.
//  Copyright © 2017年 kede. All rights reserved.
//

#import "PublishedViewController.h"

@interface PublishedViewController()<UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UITextField *contents;
@property (weak, nonatomic) IBOutlet UIImageView *image1;
@property (weak, nonatomic) IBOutlet UIImageView *image2;
@property (weak, nonatomic) IBOutlet UIImageView *image3;
@property (strong, nonatomic) UIImage *photoImage;
@end

@implementation PublishedViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self leftCustomBarButton];
    
    self.image1.image = [UIImage imageNamed:@"加号"];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
    [self.image1 addGestureRecognizer:tap];
    self.image1.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
    [self.image2 addGestureRecognizer:tap1];
    self.image2.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
    [self.image3 addGestureRecognizer:tap2];
    self.image3.userInteractionEnabled = YES;
}

- (void)tapAction:(UITapGestureRecognizer *)tap{
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"选择图片资源" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
    //创建取消按钮
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alertC addAction:action1];
    
    UIAlertAction *takePhoto = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UIImagePickerController *picker = [[UIImagePickerController alloc]init];
        picker.delegate = self;
        picker.allowsEditing = NO;
        
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:picker animated:YES completion:nil];
    }];
    [alertC addAction:takePhoto];
    
    UIAlertAction *photoLiberary = [UIAlertAction actionWithTitle:@"进入相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self openPhotoLibrary];
    }];
    [alertC addAction:photoLiberary];
    
    //显示
    [self presentViewController:alertC animated:YES completion:nil];
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
        [self presentViewController:imagePicker animated:YES completion:nil];
        //        [self presentViewController:imagePicker animated:YES completion:^{
        //            NSLog(@"打开相册");
        //        }];
    }else{
        NSLog(@"不能打开相册");
    }
}

#pragma mark - UIImagePickerControllerDelegate
// 拍照完成回调
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(nullable NSDictionary<NSString *,id> *)editingInfo NS_DEPRECATED_IOS(2_0, 3_0)
{
    self.image1.image = image;
    self.photoImage = image;
    [self dismissViewControllerAnimated:YES completion:nil];
}

//进入拍摄页面点击取消按钮
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)publishButtonAction:(UIButton *)sender {
    [self uploadInfo];
}

- (void)uploadInfo{
    // 查询条件
        UserTitle *userTitle = [Tools getPersonData];
    NSString *url = [NSString stringWithFormat:@"http://39.108.78.69:3002/mobile/userCircleSave?USER_ID=%@&DETAIL=%@", userTitle.usersId, self.contents.text];
    url = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    // 基于AFN3.0+ 封装的HTPPSession句柄
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer.timeoutInterval = 20;
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain", @"multipart/form-data", @"application/json", @"text/html", @"image/jpeg", @"image/png", @"application/octet-stream", @"text/json", nil];
    // 在parameters里存放照片以外的对象
    [manager POST:url parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        // formData: 专门用于拼接需要上传的数据,在此位置生成一个要上传的数据体
        
//        if (!self.model.icon) {
//            [self showWarningMessage:@"请上传图片"];
//            return;
//        }
//        if (!self.photoImage) {
//            //            [self showWarningMessage:@"请上传图片"];
//            return;
//        }
        
        // 这里的_photoArr是你存放图片的数组
        for (int i = 0; i < 1; i++) {
            NSData *imageData = UIImageJPEGRepresentation(self.photoImage, 0.3);
            
            // 在网络开发中，上传文件时，是文件不允许被覆盖，文件重名
            // 要解决此问题，
            // 可以在上传时使用当前的系统事件作为文件名
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            // 设置时间格式
            [formatter setDateFormat:@"yyyyMMddHHmmss"];
            NSString *dateString = [formatter stringFromDate:[NSDate date]];
            NSString *fileName = [NSString  stringWithFormat:@"%@.png", dateString];
            /*
             *该方法的参数
             1. appendPartWithFileData：要上传的照片[二进制流]
             2. name：对应网站上[upload.php中]处理文件的字段（比如upload）
             3. fileName：要保存在服务器上的文件名
             4. mimeType：上传的文件的类型
             */
            [formData appendPartWithFileData:imageData name:@"upload" fileName:fileName mimeType:@"image/jpeg"]; //
        }
        [self showWithStatus:@"正在提交.."];
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
        NSLog(@"---上传进度--- %@",uploadProgress);
        
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"```上传成功``` %@",responseObject);
        [self showSuccessMessage:@"提交成功"];
        [self.navigationController popViewControllerAnimated:YES];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"xxx上传失败xxx %@", error);
        [self showErrorMessage:@"提交失败"];
        
    }];
}

@end
