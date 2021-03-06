//
//  HelpCenterViewController.m
//  Monitore
//
//  Created by 小王 on 2017/8/9.
//  Copyright © 2017年 kede. All rights reserved.
//

#import "HelpCenterViewController.h"
#import "HelpCenterCollectionViewCell.h"
#import "HelpDetailViewController.h"

@interface HelpCenterViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *layout;
@property (strong, nonatomic) NSArray *titleAry;
@property (strong, nonatomic) NSArray *imageAry;

@end

@implementation HelpCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"帮助中心";
    [self leftCustomBarButton];
    
    self.layout.itemSize = CGSizeMake((SCREEN_WIDTH-60)/3.0, (SCREEN_WIDTH-60)/3.0);
    [self.collectionView registerNib:[UINib nibWithNibName:@"HelpCenterCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"HelpCenterCollectionViewCell"];
//
//    self.titleAry = @[@"下载APP", @"账号注册", @"登录激活", @"群防任务", @"线索举报", @"通知公告"];
//    self.imageAry = @[@"下载APP", @"账号注册", @"登录激活", @"任务", @"举报", @"公告"];
    
    self.titleAry = @[@"下载APP", @"账号注册", @"登录激活"];
    self.imageAry = @[@"任务", @"举报", @"公告"];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 3;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    HelpCenterCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HelpCenterCollectionViewCell" forIndexPath:indexPath];
    [cell displayCell:self.titleAry[indexPath.row] image:self.imageAry[indexPath.row]];
    return cell;

}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 10;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 15;
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(10, 15, 10, 15);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{    
    HelpDetailViewController *helpDetailVc = [[UIStoryboard storyboardWithName:@"PersonalCenter" bundle:nil]instantiateViewControllerWithIdentifier:@"HelpDetailViewController"];
    helpDetailVc.helpId = indexPath.row+1;
    [self.navigationController pushViewController:helpDetailVc animated:YES];
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
