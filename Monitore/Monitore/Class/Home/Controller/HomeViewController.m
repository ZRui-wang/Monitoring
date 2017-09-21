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
#import "VolunterManagerViewController.h"
#import "PatrolViewController.h"
#import "GoToReprotViewController.h"
#import "AnnouncementViewController.h"
#import "LoginViewController.h"
#import "SignInView.h"
#import "CollectViewController.h"
#import "TaskViewController.h"
#import "TrainViewController.h"
#import "BlackListViewController.h"
#import "AwardViewController.h"
#import "UserTitle.h"

@interface HomeViewController ()<UICollectionViewDelegate, UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *layouT;
@property (strong, nonatomic) NSArray *titleAry;
@property (nonatomic, strong) UserTitle *userTitle;
@end

static NSString *HomeHeaderViewId = @"HomeHeaderView";
static NSString *HomeCollectionViewCellId = @"HomeCollectionViewCell";


@implementation HomeViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    self.collectionView.contentInset=UIEdgeInsetsMake(-64, 0, 0, 0);//上移64
    [self.navigationItem setHidesBackButton:YES];

    self.layouT.headerReferenceSize = CGSizeMake(SCREEN_WIDTH, SCREEN_WIDTH/3.0*2+40);
    self.layouT.itemSize = CGSizeMake((SCREEN_WIDTH-3)/4.0, SCREEN_WIDTH/3.0);
    [self.collectionView registerNib:[UINib nibWithNibName:@"HomeCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:HomeCollectionViewCellId];
    [self.collectionView registerNib:[UINib nibWithNibName:@"HomeHeaderView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:HomeHeaderViewId];
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    self.title = @"群防群治";
    
    NSArray *temptAry = @[@"通知公告", @"群防任务", @"在线监督", @"在线巡逻", @"防骗培训", @"黑名单", @"志愿者管理", @"个人中心"];
    self.titleAry = temptAry;
}

- (void)signInBtnAction:(UIButton *)button{
    // 每日签到
    NSData *myEncodedObject = [[NSUserDefaults standardUserDefaults]objectForKey:@"userTitle"];
    
    NSKeyedUnarchiver *unArchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:myEncodedObject];
    // 解码返回一个对象
    self.userTitle = [unArchiver decodeObjectForKey:@"userTitle"]; // 此时调用反归档方法initWithCoder:
    // 反归档完成
    [unArchiver finishDecoding];
    
    
    NSDictionary *dic = @{@"USER_ID":self.userTitle.usersId};
    
    [[DLAPIClient sharedClient]POST:@"userSign" parameters:dic success:^(NSURLSessionDataTask *task, id responseObject) {
        NSSLog(@"%@", responseObject);
        if ([responseObject[Kstatus]isEqualToString:Ksuccess]) {
            UIView *signView = [SignInView xibView];
            signView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
            [self.view addSubview:signView];
        }else{
            SignInView *signView = [SignInView xibView];
            signView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
            [signView hadSigned];
            [self.view addSubview:signView];
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self showWarningMessage:@"签到失败"];

    }];
}

- (void)rewardBtnAction:(UIButton *)button{
    // 奖励兑换
    AwardViewController *awardVc = [[AwardViewController alloc]init];
    [self.navigationController pushViewController:awardVc animated:YES];
}

- (void)collectionBtnAction:(UIButton *)button{
    // 我要采集
    CollectViewController *collectVc = [[UIStoryboard storyboardWithName:@"Report" bundle:nil] instantiateViewControllerWithIdentifier:@"CollectViewController"];
    [self.navigationController pushViewController:collectVc animated:YES];
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
    
    HomeHeaderView *headView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                                                                            withReuseIdentifier:HomeHeaderViewId
                                                                                   forIndexPath:indexPath];
    [headView.signInButton addTarget:self action:@selector(signInBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [headView.rewardButton addTarget:self action:@selector(rewardBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [headView.collectButton addTarget:self action:@selector(collectionBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    
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
        AnnouncementViewController *announcementVc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"AnnouncementViewController"];
        [self.navigationController pushViewController:announcementVc animated:YES];
    }
    else if (indexPath.item == 1)
    {
        // 群防任务
        TaskViewController *taskVc = [[UIStoryboard storyboardWithName:@"Announcement" bundle:nil]instantiateViewControllerWithIdentifier:@"TaskViewController"];
        [self.navigationController pushViewController:taskVc animated:YES];
    }
    else if (indexPath.item == 2)
    {
        // 在线举报
        GoToReprotViewController *reportVc = [[UIStoryboard storyboardWithName:@"Report" bundle:nil] instantiateViewControllerWithIdentifier:@"GoToReprotViewController"];
        [self.navigationController pushViewController:reportVc animated:YES];
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
        TrainViewController *trainVc = [[TrainViewController alloc]init];
        [self.navigationController pushViewController:trainVc animated:YES];

    }
    else if (indexPath.item == 5)
    {
        // 黑名单
        BlackListViewController *blackListVc = [[BlackListViewController alloc]init];
        [self.navigationController pushViewController:blackListVc animated:YES];
    }
    else if (indexPath.item == 6)
    {
        // 信息中心
        VolunterManagerViewController *infoVc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"VolunterManagerViewController"];
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
