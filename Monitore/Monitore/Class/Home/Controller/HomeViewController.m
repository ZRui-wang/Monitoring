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
#import "BannerModel.h"

@interface HomeViewController ()<UICollectionViewDelegate, UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *layouT;
@property (strong, nonatomic) NSArray *titleAry;
@property (nonatomic, strong) NSMutableArray *bannerAry;
@property (copy, nonatomic)NSString *lat;
@property (copy, nonatomic)NSString *lon;
@end

static NSString *HomeHeaderViewId = @"HomeHeaderView";
static NSString *HomeCollectionViewCellId = @"HomeCollectionViewCell";


@implementation HomeViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    self.collectionView.contentInset=UIEdgeInsetsMake(-64, 0, 0, 0);//上移64
    [self.navigationItem setHidesBackButton:YES];
    
    self.title = @"共建 共治 共享";
    self.bannerAry = [NSMutableArray array];
    
    NSArray *temptAry = @[@"邻里守望", @"志愿者活动", @"自媒体监督", @"义务巡防", @"志愿者学习", @"维稳黑名单", @"身边志愿者", @"个人中心"];
    self.titleAry = temptAry;

    [self creatCollectionView];
    
    [self checkVersion];
    
    __block typeof(self) weak = self;
    [[Tools sharedTools]getCurrentAddress:^(NSString *address) {
        [weak getGeoCoedAddress:address];
    }];
}



- (void)getGeoCoedAddress:(NSString *)address{
    CLGeocoder *myGeocoder = [[CLGeocoder alloc] init];
    __block typeof(self) weak = self;
    [myGeocoder geocodeAddressString:address completionHandler:^(NSArray *placemarks, NSError *error) {
        if ([placemarks count] > 0 && error == nil) {
            NSLog(@"Found %lu placemark(s).", (unsigned long)[placemarks count]);
            CLPlacemark *firstPlacemark = [placemarks objectAtIndex:0];
            NSLog(@"Longitude = %f", firstPlacemark.location.coordinate.longitude);
            NSLog(@"Latitude = %f", firstPlacemark.location.coordinate.latitude);
            
            weak.lon = [NSString stringWithFormat:@"%f", firstPlacemark.location.coordinate.longitude];
            weak.lat = [NSString stringWithFormat:@"%f", firstPlacemark.location.coordinate.latitude];
            
            [[NSUserDefaults standardUserDefaults]setObject:weak.lon forKey:@"lon"];
            [[NSUserDefaults standardUserDefaults]setObject:weak.lat forKey:@"lat"];
            
        }
        else if ([placemarks count] == 0 && error == nil) {
            NSLog(@"Found no placemarks.");
        } else if (error != nil) {
            NSLog(@"An error occurred = %@", error);
        }
    }];
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
        
    [self bannerUrl];
    
    UserTitle *userTitle = [Tools getPersonData];
    if (userTitle == nil) {
        LoginViewController *login = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"LoginViewController"];
        [self presentViewController:login animated:NO completion:nil];
    }else{
        
        [self getQNToken];
    }

}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

-(void)checkVersion
{
    NSString *newVersion;
    NSURL *url = [NSURL URLWithString:@"http://itunes.apple.com/cn/lookup?id=1321712040"];//这个URL地址是该app在iTunes connect里面的相关配置信息。其中id是该app在app store唯一的ID编号。
    NSString *jsonResponseString = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
    NSLog(@"通过appStore获取的数据信息：%@",jsonResponseString);
    
    if (jsonResponseString.length==0) {
        return;
    }
    
    NSData *data = [jsonResponseString dataUsingEncoding:NSUTF8StringEncoding];
    
    //    解析json数据
    
    id json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    
    NSArray *array = json[@"results"];
    
    for (NSDictionary *dic in array) {
        
        
        newVersion = [dic valueForKey:@"version"];
        
    }
    
    if (!newVersion) {
        return;
    }
        
    //获取本地软件的版本号
    NSString *localVersion;
    localVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    
    NSLog(@"通过appStore获取的版本号是：%f %f",[newVersion doubleValue], [localVersion doubleValue]);
    
    NSString *msg = [NSString stringWithFormat:@"你当前的版本是V%@，发现新版本V%@，是否下载新版本？",localVersion,newVersion];
    NSLog(@"通过appStore获取的版本号是：%@",msg);
    
    //对比发现的新版本和本地的版本
    if (![newVersion isEqualToString:localVersion] )
    {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"升级提示"message:msg preferredStyle:UIAlertControllerStyleAlert];
        
        [self presentViewController:alert animated:YES completion:nil];
        
        [alert addAction:[UIAlertAction actionWithTitle:@"现在升级" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/us/app/%E7%BE%A4%E9%98%B2%E5%BF%97%E6%84%BF%E8%80%85/id1321712040?l=zh&ls=1&mt=8"]];//这里写的URL地址是该app在app store里面的下载链接地址，其中ID是该app在app store对应的唯一的ID编号。
            NSLog(@"点击现在升级按钮");
        }]];
        
        [alert addAction:[UIAlertAction actionWithTitle:@"下次再说" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSLog(@"点击下次再说按钮");
        }]];
    }else{
        NSLog(@"版本好医院啊啊啊啊啊啊啊啊啊啊");
    }
}

- (void)creatCollectionView{
    self.layouT.headerReferenceSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT/2.0);
    self.layouT.itemSize = CGSizeMake((SCREEN_WIDTH-3)/4.0, SCREEN_WIDTH/3.0);
    [self.collectionView registerNib:[UINib nibWithNibName:@"HomeCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:HomeCollectionViewCellId];
    [self.collectionView registerNib:[UINib nibWithNibName:@"HomeHeaderView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:HomeHeaderViewId];
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
}

- (void)bannerUrl{
    [[DLAPIClient sharedClient]POST:@"init" parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"轮播图 = %@", responseObject);
        if ([responseObject[Kstatus]isEqualToString:Ksuccess]) {
            for (NSDictionary *dic in responseObject[@"dataList"]) {
                BannerModel *bannerModel = [BannerModel modelWithDictionary:dic];
                [self.bannerAry addObject:bannerModel];
            }
            [self.collectionView reloadData];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self showErrorMessage:@"网络错误"];
    }];
}

- (void)signInBtnAction:(UIButton *)button{
    
    UserTitle *userTitle = [Tools getPersonData];
    // 每日签到
    NSDictionary *dic = @{@"USER_ID":userTitle.usersId};
    
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
    [cell displayCellWithData:[self.titleAry objectOrNilAtIndex:indexPath.item]];
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView
           viewForSupplementaryElementOfKind:(NSString *)kind
                                 atIndexPath:(NSIndexPath *)indexPath {
    
    HomeHeaderView *headView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                                                                            withReuseIdentifier:HomeHeaderViewId
                                                                                   forIndexPath:indexPath];
    if (self.bannerAry.count) {
       headView.bannerAry = self.bannerAry;
    }
    
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

- (void)getQNToken{
    UserTitle *title = [Tools getPersonData];
    NSDictionary *dic = @{@"USER_ID":title.usersId};
    [[DLAPIClient sharedClient]POST:@"getQiNiuToken" parameters:dic success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([responseObject[Kstatus]isEqualToString:Ksuccess]) {
            
            NSDictionary *dic = responseObject[@"data"];
            
            [[NSUserDefaults standardUserDefaults]setObject:dic[@"token"] forKey:@"qntoken"];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self showErrorMessage:@"网络错误"];
    }];
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
