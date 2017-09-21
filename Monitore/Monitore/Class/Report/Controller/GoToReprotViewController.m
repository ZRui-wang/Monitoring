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

@interface GoToReprotViewController ()<UITableViewDataSource, UITableViewDelegate, UITextViewDelegate, textViewDidFinishEidedDelegate, TakePhotosDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic)UITextView *textView;

@property (strong, nonatomic)NSArray *titleAry;
@property (strong, nonatomic)NSArray *themeAry;
@property (strong, nonatomic)NSMutableArray *photoArray;

@property (strong, nonatomic)UploadPhotoView *uploadPhoto;

@end

@implementation GoToReprotViewController
{
    CGFloat titleHeigh;
    CGFloat detailHeigh;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self leftCustomBarButton];
    self.title = @"我要举报";
    
    [[IQKeyboardManager sharedManager] setEnable:NO];
    
    
    [self.photoArray addObject:[UIImage imageNamed:@"加号"]];
    
    //  支持自适应 cell
//    self.tableView.estimatedRowHeight = 100;
//    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    self.titleAry = @[@"分类"];
    self.themeAry = @[@"主题", @"描述"];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"GoToReportTableViewCell" bundle:nil] forCellReuseIdentifier:@"GoToReportTableViewCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"TextViewTableViewCell" bundle:nil] forCellReuseIdentifier:@"TextViewTableViewCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"ReportAddressTableViewCell" bundle:nil] forCellReuseIdentifier:@"ReportAddressTableViewCell"];
//    [self.tableView registerNib:[UINib nibWithNibName:@"ReportImageTableViewCell" bundle:nil] forCellReuseIdentifier:@"ReportImageTableViewCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"UploadPhotoView" bundle:nil] forHeaderFooterViewReuseIdentifier:@"UploadPhotoView"];
    
    titleHeigh = 50;
    detailHeigh = 80;
    [self getClass];
}

- (void)getClass{
    [[DLAPIClient sharedClient] POST:@"getRepCate" parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"%@", responseObject);
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [[IQKeyboardManager sharedManager] setEnable:YES];
}
- (void)takePhotos{
    UIImagePickerController *picker = [[UIImagePickerController alloc]init];
    picker.delegate = self;
    picker.allowsEditing = NO;
    
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    [self presentViewController:picker animated:YES completion:nil];
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
        [cell displayCellTitle:self.titleAry[indexPath.row]];
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
        UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"分类" message:@"举报类型" preferredStyle:UIAlertControllerStyleActionSheet];
        //创建取消按钮
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"违法违规" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        UIAlertAction *action3 = [UIAlertAction actionWithTitle:@"消防隐患" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        UIAlertAction *action4 = [UIAlertAction actionWithTitle:@"违法车辆" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        UIAlertAction *action5 = [UIAlertAction actionWithTitle:@"防诈骗打假" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        UIAlertAction *action6 = [UIAlertAction actionWithTitle:@"邻里矛盾" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        UIAlertAction *action7 = [UIAlertAction actionWithTitle:@"特殊人群维稳" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        UIAlertAction *action8 = [UIAlertAction actionWithTitle:@"爱心求助" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];

        //添加按钮
        [alertC addAction:action1];
        [alertC addAction:action2];
        [alertC addAction:action3];
        [alertC addAction:action4];
        [alertC addAction:action5];
        [alertC addAction:action6];
        [alertC addAction:action7];
        [alertC addAction:action8];
        
        //显示
        [self presentViewController:alertC animated:YES completion:nil];
    }
}

- (IBAction)saveButtonAction:(id)sender {
}

- (IBAction)submitButtonAction:(id)sender {
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
    [self.photoArray insertObject:image atIndex:self.photoArray.count-1];
    [self.tableView reloadData];
    
//    self.collectImageView.image = image;
    
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
