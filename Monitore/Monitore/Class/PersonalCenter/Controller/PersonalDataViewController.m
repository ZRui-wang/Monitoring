//
//  PersonalDataViewController.m
//  Monitore
//
//  Created by kede on 2017/7/26.
//  Copyright © 2017年 kede. All rights reserved.
//

#import "PersonalDataViewController.h"
#import "PersonalDataTableViewCell.h"
#import "PersonalPhotoTableViewCell.h"
#import "PersonalDataFooterView.h"
#import "PersonalDataHeaderView.h"
#import "UserTitle.h"
#import "UIImageView+WebCache.h"
#import "SexTableViewCell.h"

@interface PersonalDataViewController ()<UITableViewDelegate, UITableViewDataSource, SaveButtonDelegate, SaveInfoDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, SelectSexDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) UIImage *photoImage;

@end

@implementation PersonalDataViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self leftCustomBarButton];
    self.title = @"个人资料";
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    UserTitle *userTitle = [Tools getPersonData];
    self.model.type = userTitle.type?@"群防力量":@"普通用户";
    self.model.usersId = userTitle.usersId;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"PersonalDataTableViewCell" bundle:nil] forCellReuseIdentifier:@"PersonalDataTableViewCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"PersonalPhotoTableViewCell" bundle:nil] forCellReuseIdentifier:@"PersonalPhotoTableViewCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"SexTableViewCell" bundle:nil] forCellReuseIdentifier:@"SexTableViewCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"PersonalDataFooterView" bundle:nil] forHeaderFooterViewReuseIdentifier:@"PersonalDataFooterView"];
    [self.tableView registerNib:[UINib nibWithNibName:@"PersonalDataHeaderView" bundle:nil] forHeaderFooterViewReuseIdentifier:@"PersonalDataHeaderView"];

//    self.tableView.tableFooterView = [PersonalDataFooterView xibView];
}

#pragma mark - UITableDatasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 10;
    }
    else
    {
        return 2;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0 && indexPath.row == 8) {
        return 200;
    }
    else
    {
        return 40;
    }
}

 - (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 0) {
        return 0.1;
    }
    else
    {
        return 51;
    }

}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section==1) {
        PersonalDataFooterView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"PersonalDataFooterView"];
        view.delegate = self;
        return view;
    }
    return nil;
}

- (void)saveButtonAction{
    NSDictionary *dic = @{
        @"USER_ID":self.model.usersId,
        @"NICKNAME":self.model.nickname,
        @"IDCARD":self.model.idcard,
      @"JOB":self.model.job,
      @"ADDRESS":self.model.address,
        @"SEX":self.model.sex,
        @"REC_MOBILE":self.model.recMobile,
        @"CITY_NAME":self.model.cityName,
        @"COMPANY":self.model.company,
        @"ICON":self.model.icon
        };
    [[DLAPIClient sharedClient] POST:@"updUserInfo" parameters:dic success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"%@", responseObject);
        if ([responseObject[Kstatus] isEqualToString:Ksuccess]) {
            [self showSuccessMessage:@"保存成功"];
        }
        else{
            [self showWithStatus:responseObject[Kinfo]];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self showErrorMessage:error.domain];
    }];
    
//    [self uploadInfo];
}

- (void)uploadInfo{
    // 查询条件
    self.model.nickname = @"";
    NSDictionary *dic = @{
                          @"USER_ID":self.model.usersId,
                          @"NICKNAME":self.model.nickname,
                          @"IDCARD":self.model.idcard,
                          @"JOB":self.model.job,
                          @"ADDRESS":self.model.address,
                          @"SEX":self.model.sex,
                          @"REC_MOBILE":self.model.recMobile,
                          @"CITY_NAME":self.model.cityName,
                          @"COMPANY":self.model.company
                          };
    NSString *url = [NSString stringWithFormat:@"http://39.108.78.69:3002/mobile/updUserInfo?USER_ID=%@?NICKNAME=%@?IDCARD=%@?JOB=%@?ADDRESS=%@?SEX=%@?REC_MOBILE=%@?CITY_NAME=%@?COMPANY=%@", self.model.usersId, self.model.nickname, self.model.idcard, self.model.job, self.model.address, self.model.sex, self.model.recMobile, self.model.cityName, self.model.company ];
//    url = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    // 基于AFN3.0+ 封装的HTPPSession句柄
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer.timeoutInterval = 20;
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain", @"multipart/form-data", @"application/json", @"text/html", @"image/jpeg", @"image/png", @"application/octet-stream", @"text/json", nil];
    // 在parameters里存放照片以外的对象
    [manager POST:url parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        // formData: 专门用于拼接需要上传的数据,在此位置生成一个要上传的数据体
        
        if (!self.photoImage) {
            [self showWarningMessage:@"请上传图片"];
            return;
        }
        
        // 这里的_photoArr是你存放图片的数组
        for (int i = 0; i < 1; i++) {
            NSData *imageData = UIImageJPEGRepresentation(self.photoImage, 0.5);
            
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
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"xxx上传失败xxx %@", error);
        [self showErrorMessage:@"提交失败"];
        
    }];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    PersonalDataHeaderView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"PersonalDataHeaderView"];
    if (section == 0) {
        view.title.text = @"基本信息";
    }
    else{
        view.title.text = @"地址信息";
    }
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0 && indexPath.row == 8) {
        PersonalPhotoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PersonalPhotoTableViewCell" forIndexPath:indexPath];
        if (self.photoImage) {
            if (self.model.icon.length) {
                [cell.photo sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", self.model.icon]]];
                 }else{
                     
                     cell.photo.image = self.photoImage;
                     [cell.photo setContentMode:UIViewContentModeScaleToFill];
                 }
        }
        return cell;
    }
    else if (indexPath.section == 0&&indexPath.row == 2){
        SexTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SexTableViewCell" forIndexPath:indexPath];
        cell.delegate = self;
        
        if ([self.model.sex isEqualToString:@"女"]) {
            cell.manButton.selected = NO;
            cell.womenButton.selected = YES;
        }else{
            cell.manButton.selected = YES;
            cell.womenButton.selected = NO;
        }
        
        return cell;
    }
    else
    {
        PersonalDataTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PersonalDataTableViewCell" forIndexPath:indexPath];
        cell.delegate = self;
        cell.indexPath = indexPath;
        if (indexPath.row == 9) {
            cell.date = self.model.createtime;
        }
        
        else if (indexPath.row == 0) {
            cell.mobile = self.model.mobile;
        }
        else if (indexPath.row == 1){
            cell.titleValue = self.model.nickname;
        }
        else if (indexPath.row == 2){
            cell.titleValue = self.model.sex;
        }
        else if (indexPath.row == 3){
            cell.titleValue = self.model.type;
        }
        else if (indexPath.row == 4){
            cell.titleValue = self.model.idcard;
        }
        else if (indexPath.row == 5){
            cell.titleValue = self.model.job;
        }
        else if (indexPath.row == 6){
            cell.titleValue = self.model.company;
        }
        else if (indexPath.row == 7){
            cell.titleValue = self.model.recMobile;
        }

        
        if (indexPath.section == 1) {
            if (indexPath.row == 0){
                cell.titleValue = self.model.cityName;
            }
            else if (indexPath.row == 1){
                cell.titleValue = self.model.address;
            }
        }
      
        [cell displayCellWithData:nil andIndexpath:indexPath];
        return cell;
    }

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0 && indexPath.row == 8) {
        UIImagePickerController *picker = [[UIImagePickerController alloc]init];
        picker.delegate = self;
        picker.allowsEditing = NO;
        
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:picker animated:YES completion:nil];
    }
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
    }else{
        NSLog(@"不能打开相册");
    }
}

#pragma mark - UIImagePickerControllerDelegate
// 拍照完成回调
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(nullable NSDictionary<NSString *,id> *)editingInfo NS_DEPRECATED_IOS(2_0, 3_0)
{
    self.photoImage = image;
    NSSLog(@"finish..");
//    self.imageData = UIImagePNGRepresentation(image);
    [self.tableView reloadData];
    [self dismissViewControllerAnimated:YES completion:nil];
}

//进入拍摄页面点击取消按钮
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)selectSexIsMan:(BOOL)isMan{
    if (isMan) {
        self.model.sex = @"男";
    }else{
        self.model.sex = @"女";
    }
}

- (void)buildInfoRow:(NSInteger)row info:(NSString *)info{
    switch (row) {
        case 1:
            self.model.nickname = info;
            break;
        case 2:
            self.model.sex = info;
            break;
        case 3:
            
            break;
        case 4:
            self.model.idcard = info;
            break;
        case 5:
            self.model.job = info;
            break;
        case 6:
            self.model.company = info;
            break;
        case 7:
            self.model.recMobile = info;
            break;
        case 8:
            
            break;
        case 9:
            
            break;
        case 10:
            self.model.cityName = info;
            break;
        case 11:
            self.model.address = info;
            break;
        case 12:
            
            break;
            
        default:
            break;
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
