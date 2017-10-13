//
//  GoToReprotViewController.m
//  Monitore
//
//  Created by kede on 2017/7/27.
//  Copyright © 2017年 kede. All rights reserved.
//

#import "GoToReprotViewController.h"
#import "GoToReportTableViewCell.h"
#import "TextViewTableViewCell.h"
#import "ReportAddressTableViewCell.h"
#import "ReportImageTableViewCell.h"
#import "UploadPhotoView.h"
#import "ClassModel.h"
#import "ReportModel.h"
#import "QiniuSDK.h"
#import <AVFoundation/AVFoundation.h>

@interface GoToReprotViewController ()<UITableViewDataSource, UITableViewDelegate, UITextViewDelegate, textViewDidFinishEidedDelegate, TakePhotosDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, AddressDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic)UITextView *textView;

@property (strong, nonatomic)NSArray *titleAry;
@property (strong, nonatomic)NSArray *themeAry;
@property (strong, nonatomic)NSMutableArray *photoArray;
@property (strong, nonatomic)NSMutableArray *classAry;
@property (strong, nonatomic) UIImagePickerController *picker;
@property (strong, nonatomic)UploadPhotoView *uploadPhoto;
@property (strong, nonatomic)ReportModel *model;
@property (copy, nonatomic)NSString *videoUrl;

@property (assign, nonatomic)BOOL isTakeVideo;

@end

@implementation GoToReprotViewController
{
    CGFloat titleHeigh;
    CGFloat detailHeigh;
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self leftCustomBarButton];
    self.title = @"在线监督";
    self.classAry = [NSMutableArray array];
    self.model = [[ReportModel alloc]init];
    
    self.model.userId = self.userTitle.usersId;
    
    [[IQKeyboardManager sharedManager] setEnable:NO];
    
    
    [self.photoArray addObject:[UIImage imageNamed:@"加号"]];
    
    self.titleAry = @[@"分类"];
    self.themeAry = @[@"主题", @"描述"];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"GoToReportTableViewCell" bundle:nil] forCellReuseIdentifier:@"GoToReportTableViewCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"TextViewTableViewCell" bundle:nil] forCellReuseIdentifier:@"TextViewTableViewCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"ReportAddressTableViewCell" bundle:nil] forCellReuseIdentifier:@"ReportAddressTableViewCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"UploadPhotoView" bundle:nil] forHeaderFooterViewReuseIdentifier:@"UploadPhotoView"];

    self.isTakeVideo = YES;
    
    titleHeigh = 50;
    detailHeigh = 80;
    [self getClass];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(drawUnderlin:) name:@"delectPhoto" object:nil];
    
}

- (void)drawUnderlin:(NSNotification *)notification{
    NSInteger rowcell = [[notification.userInfo objectForKey:@"row"] integerValue];
    [self.photoArray removeObjectAtIndex:rowcell];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];

}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [[IQKeyboardManager sharedManager] setEnable:YES];
}

- (void)getClass{
    [[DLAPIClient sharedClient] POST:@"getRepCate" parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"%@", responseObject);
        for (NSDictionary *dic in responseObject[@"dataList"]) {
            ClassModel *model = [ClassModel modelWithDictionary:dic];
            [self.classAry addObject:model];
        }

        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        [self tableView:self.tableView didSelectRowAtIndexPath:indexPath];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}


- (void)takePhotos{
    
    if (self.isTakeVideo) {
        //创建AlertController对象 preferredStyle可以设置是AlertView样式或者ActionSheet样式
        UIAlertController *alertC = [UIAlertController alertControllerWithTitle:nil message:@"证据类型" preferredStyle:UIAlertControllerStyleActionSheet];
        //创建取消按钮
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alertC addAction:action1];
        
        UIAlertAction *photos = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            self.picker.allowsEditing = NO;
            
            self.picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            [self presentViewController:self.picker animated:YES completion:nil];
        }];
        [alertC addAction:photos];
        
        UIAlertAction *video = [UIAlertAction actionWithTitle:@"视频" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            self.picker.delegate = self;
            self.picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            self.picker.mediaTypes = @[(NSString *)kUTTypeMovie];
            self.picker.videoMaximumDuration = 10;
            self.picker.videoQuality = UIImagePickerControllerQualityTypeLow;
            [self presentViewController:self.picker animated:YES completion:nil];
        }];
        [alertC addAction:video];
        
        //显示
        [self presentViewController:alertC animated:YES completion:nil];
        
        UIImagePickerController *picker = [[UIImagePickerController alloc]init];
        picker.delegate = self;
        picker.allowsEditing = NO;
        
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:picker animated:YES completion:nil];
    }else{
        
        self.picker.allowsEditing = NO;
        
        self.picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:self.picker animated:YES completion:nil];
    }
}

- (void)finishEditHeigh:(CGFloat)heigh row:(NSInteger)row{
    if (row == 1) {
        titleHeigh = heigh;
    }else{
        detailHeigh = heigh;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 200;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row < 1) {
        return 50;
    }
    else if(indexPath.row == 1){
        return titleHeigh;
    }
    else if(indexPath.row == 2){
        return detailHeigh;
    }
    else if(indexPath.row == 3){
        return 50;
    }
    else{
        return 200;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < 1) {
        GoToReportTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GoToReportTableViewCell" forIndexPath:indexPath];
        [cell displayCellTitle:self.titleAry[indexPath.row] detail:self.model.firstTitle];
        return cell;
    }
    else if(indexPath.row < 3){
        TextViewTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TextViewTableViewCell" forIndexPath:indexPath];
        cell.delegate = self;
        cell.cellRow = indexPath.row;
        [cell diaplayCell:self.themeAry[indexPath.row -1]];
        return cell;
    }
    else if(indexPath.row == 3){
        ReportAddressTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ReportAddressTableViewCell" forIndexPath:indexPath];
        cell.delegate = self;
        return cell;
    }
    else{
        ReportImageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ReportImageTableViewCell" forIndexPath:indexPath];
        return cell;
        
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UploadPhotoView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"UploadPhotoView"];
    view.delegate = self;
    view.photoArray = self.photoArray;
    [view.collectionView reloadData];
    return view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        //创建AlertController对象 preferredStyle可以设置是AlertView样式或者ActionSheet样式
        UIAlertController *alertC = [UIAlertController alertControllerWithTitle:nil message:@"监督类型" preferredStyle:UIAlertControllerStyleActionSheet];
        //创建取消按钮
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        
        [alertC addAction:action1];
        
        for (int i=0; i<self.classAry.count; i++) {
            ClassModel *model = self.classAry[i];
            UIAlertAction *action2 = [UIAlertAction actionWithTitle:model.name style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                self.model.firstId = model.categoryId;
                self.model.secodeId = model.categoryId;
                self.model.firstTitle = model.name;
                [self.tableView reloadData];
                
                
            }];
            [alertC addAction:action2];
        }
        
        //显示
        [self presentViewController:alertC animated:YES completion:nil];
    }
}

- (void)reportAddress:(NSString *)address longitude:(NSString *)longitude latituded:(NSString *)latitude{
    self.model.address = address;
    self.model.longitude = longitude;
    self.model.latitude = latitude;
}

- (void)reportContent:(NSString *)content row:(NSInteger)row{
    if (row == 1) {
        self.model.title = content;
    }
    
    if (row == 2) {
        self.model.content = content;
    }
    
    [self.tableView reloadData];
}

- (IBAction)saveButtonAction:(id)sender {
}

- (IBAction)submitButtonAction:(id)sender {
    [self uploadInfo];
//    NSDictionary *dic = @{@"USER_ID":self.model.userId,
//                          @"FIRST_ID":self.model.firstId,
//                          @"SECOND_ID":self.model.secodeId,
//                          @"CONTENT":self.model.content,
//                          @"TITLE":self.model.title,
//                          @"ADDRESS":self.model.address,
//                          @"LONGITUDE":self.model.longitude,
//                          @"LATITUDE":self.model.latitude
//                          }; //                          @"REMARK":@""
//    [[DLAPIClient sharedClient]POST:@"report" parameters:dic success:^(NSURLSessionDataTask *task, id responseObject) {
//        if ([responseObject[Kstatus] isEqualToString:Ksuccess]) {
//            [self showErrorMessage:@"提交成功"];
//        }
//        else{
//            [self showErrorMessage:@"操作失败"];
//        }
//    } failure:^(NSURLSessionDataTask *task, NSError *error) {
//        [self showErrorMessage:@"数据错误"];
//    }];
}

- (void)uploadInfo{
    // 查询条件
    NSString *url = [NSString stringWithFormat:@"http://39.108.78.69:3002/mobile/report?USER_ID=%@&FIRST_ID=%@&SECOND_ID=%@&CONTENT=%@&TITLE=%@&ADDRESS=%@&LONGITUDE=%@&LATITUDE=%@&VIDEO_URL=%@", self.model.userId, self.model.firstId, self.model.secodeId, self.model.content, self.model.title, self.model.address, self.model.longitude, self.model.latitude, self.videoUrl];
    url = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    // 基于AFN3.0+ 封装的HTPPSession句柄
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer.timeoutInterval = 20;
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain", @"multipart/form-data", @"application/json", @"text/html", @"image/jpeg", @"image/png", @"application/octet-stream", @"text/json", nil];
    
    if (self.photoArray.count==1) {
        [self showWarningMessage:@"请上传图片"];
        return;
    }
    // 在parameters里存放照片以外的对象
    [manager POST:url parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        // formData: 专门用于拼接需要上传的数据,在此位置生成一个要上传的数据体
        // 这里的_photoArr是你存放图片的数组
        for (int i = 0; i < self.photoArray.count-1; i++) {
            NSData *imageData = UIImageJPEGRepresentation(self.photoArray[i], 0.5);
            
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
            [formData appendPartWithFileData:imageData name:fileName fileName:fileName mimeType:@"image/png"]; //
        }
        [self showWithStatus:@"正在提交.."];
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
        NSLog(@"---上传进度--- %@",uploadProgress);
        
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"```上传成功``` %@",responseObject);
        [self showSuccessMessage:@"提交成功"];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"xxx上传失败xxx %@", error);
        [self showErrorMessage:@"提交失败"];
        
    }];
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
        self.isTakeVideo = NO;
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        [self.photoArray insertObject:image atIndex:self.photoArray.count-1];
        [self.tableView reloadData];
    }
    else if ([mediaType isEqualToString:(NSString *)kUTTypeMovie]){
        NSURL *url = [info objectForKey:UIImagePickerControllerMediaURL];
        NSString *urlStr = [url path];
        
        NSString *token = [[NSUserDefaults standardUserDefaults]objectForKey:@"qntoken"];
        
        QNConfiguration *config = [QNConfiguration build:^(QNConfigurationBuilder *builder) {
            builder.zone = [QNFixedZone zone1];
        }];
        QNUploadManager *upManager = [[QNUploadManager alloc]initWithConfiguration:config];
        
        [upManager putFile:urlStr key:nil token:token complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
            self.videoUrl = resp[@"key"];
        } option:nil];
        
        
        UIImage *image = [self thumbnailImageForVideo:url atTime:1];
        
        [self.photoArray insertObject:image atIndex:self.photoArray.count-1];
        [self.tableView reloadData];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (UIImage*) thumbnailImageForVideo:(NSURL *)videoURL atTime:(NSTimeInterval)time {
    
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:videoURL options:nil];
    NSParameterAssert(asset);
    AVAssetImageGenerator *assetImageGenerator =[[AVAssetImageGenerator alloc] initWithAsset:asset];
    assetImageGenerator.appliesPreferredTrackTransform = YES;
    assetImageGenerator.apertureMode = AVAssetImageGeneratorApertureModeEncodedPixels;
    
    CGImageRef thumbnailImageRef = NULL;
    CFTimeInterval thumbnailImageTime = time;
    NSError *thumbnailImageGenerationError = nil;
    thumbnailImageRef = [assetImageGenerator copyCGImageAtTime:CMTimeMake(thumbnailImageTime, 60)actualTime:NULL error:&thumbnailImageGenerationError];
    
    if(!thumbnailImageRef)
        NSLog(@"thumbnailImageGenerationError %@",thumbnailImageGenerationError);
    
    UIImage*thumbnailImage = thumbnailImageRef ? [[UIImage alloc]initWithCGImage: thumbnailImageRef] : nil;
    
    return thumbnailImage;
}


//进入拍摄页面点击取消按钮

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker

{
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (NSMutableArray *)photoArray{
    if (_photoArray == nil) {
        _photoArray  = [NSMutableArray array];
    }
    return _photoArray;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
