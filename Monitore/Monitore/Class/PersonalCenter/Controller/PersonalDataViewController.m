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

@interface PersonalDataViewController ()<UITableViewDelegate, UITableViewDataSource, SaveButtonDelegate, SaveInfoDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
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
        [self showWithStatus:error.domain];
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
          cell.photo.image = self.photoImage;
        [cell.photo setContentMode:UIViewContentModeScaleToFill];
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
    NSData *data = UIImagePNGRepresentation(image);
//    self.model.icon = [[NSString alloc]initWithData:data encoding:kCFStringEncodingUTF8];
    self.model.icon = data;
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
