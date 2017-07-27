//
//  HomeViewController.m
//  Monitore
//
//  Created by kede on 2017/7/24.
//  Copyright © 2017年 kede. All rights reserved.
//

#import "HomeViewController.h"
#import "HomeHeaderView.h"
#import "HomeCollectionViewCell.h"
#import "PersonalCenterVc.h"
#import "InfoViewController.h"
#import "PatrolViewController.h"

@interface HomeViewController ()<UICollectionViewDelegate, UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *layouT;
@property (strong, nonatomic) NSArray *titleAry;

@end

static NSString *HomeHeaderViewId = @"HomeHeaderView";
static NSString *HomeCollectionViewCellId = @"HomeCollectionViewCell";


@implementation HomeViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    self.collectionView.contentInset=UIEdgeInsetsMake(-64, 0, 0, 0);//上移64

    self.layouT.headerReferenceSize = CGSizeMake(SCREEN_WIDTH, SCREEN_WIDTH/3.0*2+16);
    self.layouT.itemSize = CGSizeMake((SCREEN_WIDTH-3)/4.0, SCREEN_WIDTH/3.0);
    [self.collectionView registerNib:[UINib nibWithNibName:@"HomeCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:HomeCollectionViewCellId];
    [self.collectionView registerNib:[UINib nibWithNibName:@"HomeHeaderView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:HomeHeaderViewId];
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    self.title = @"群防群治";
    
    NSArray *temptAry = @[@"通知公告", @"群防任务", @"在线举报", @"在线巡逻", @"学习培训", @"黑名单", @"信息中心", @"个人中心"];
    self.titleAry = temptAry;
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 8;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    HomeCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:HomeCollectionViewCellId forIndexPath:indexPath];
    [cell displayCellWithData:[self.titleAry objectAtIndexCheck:indexPath.item]];
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView
           viewForSupplementaryElementOfKind:(NSString *)kind
                                 atIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionReusableView *headView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                                                                            withReuseIdentifier:HomeHeaderViewId
                                                                                   forIndexPath:indexPath];
    return headView;
}

- (UIEdgeInsets)collectionView:
(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(16, 0, 0, 0);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 1;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 1;
}

#pragma mark - UICollectionViewDelegat
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.item == 0) {
        // 通知公告
    }
    else if (indexPath.item == 1)
    {
        // 群防任务
    }
    else if (indexPath.item == 2)
    {
        // 在线举报
    }
    else if (indexPath.item == 3)
    {
        // 在线巡逻
        PatrolViewController *patrolVc = [[UIStoryboard storyboardWithName:@"Patrol" bundle:nil] instantiateViewControllerWithIdentifier:@"PatrolViewController"];
        [self.navigationController pushViewController:patrolVc animated:YES];
        
    }
    else if (indexPath.item == 4)
    {
        // 学习培训
    }
    else if (indexPath.item == 5)
    {
        // 黑名单
    }
    else if (indexPath.item == 6)
    {
        // 信息中心
        InfoViewController *infoVc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"InfoViewController"];
        [self.navigationController pushViewController:infoVc animated:YES];
    }
    else// if (indexPath.item == 7)
    {
        // 个人中心
        PersonalCenterVc *personalCenterVc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"PersonalCenterVc"];
        [self.navigationController pushViewController:personalCenterVc animated:YES];
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
