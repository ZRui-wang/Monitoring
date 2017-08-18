//
//  SettingViewController.m
//  Monitore
//
//  Created by kede on 2017/7/27.
//  Copyright © 2017年 kede. All rights reserved.
//

#import "SettingViewController.h"
#import "SettingTableViewCell.h"

@interface SettingViewController ()<UITableViewDelegate, UITableViewDataSource, DLAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic)NSArray *titleAry;
@property (copy, nonatomic)NSString *cacheSize;

@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self leftCustomBarButton];
    self.title = @"设置";
    
    [self.tableView registerNib:[UINib nibWithNibName:@"SettingTableViewCell" bundle:nil] forCellReuseIdentifier:@"SettingTableViewCell"];
    self.tableView.tableFooterView = [UIView new];
    
    NSArray *tempTitleAry = @[@"清空缓存", @"关于我们"];
    self.titleAry = tempTitleAry;
    
    [self getCacheSize];
}

#pragma mark - AlterViewDelegate
- (void)alertView:(DLAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [self deleteAppCache];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }
    else{
        return 1;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SettingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SettingTableViewCell" forIndexPath:indexPath];
    
    if (indexPath.section == 0) {
        cell.title.text = self.titleAry[indexPath.row];
        cell.caseValue.hidden = NO;
        cell.caseValue.text = self.cacheSize;
    }
    else
    {
        cell.title.text = [self.titleAry lastObject];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        DLAlertView *alter = [[DLAlertView alloc]initWithTitle:NSLocalizedString(@"提示", nil)
                                                       message:NSLocalizedString(@"确定要清楚缓存?", nil)
                                                      delegate:self
                                             cancelButtonTitle:NSLocalizedString(@"取消", nil)
                                             otherButtonTitles:NSLocalizedString(@"确定", nil), nil];
        [alter show];

    }
    else{
        
    }
}

#pragma mark -------   缓存处理（缓存大小计算、缓存清除）
- (void)getCacheSize {
    
    NSString *cachesPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    NSFileManager* manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:cachesPath]) return ;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath:cachesPath] objectEnumerator];//从前向后枚举器
        NSString* fileName;
        long long folderSize = 0;
        while ((fileName = [childFilesEnumerator nextObject]) != nil){
            NSString* fileAbsolutePath = [cachesPath stringByAppendingPathComponent:fileName];
            folderSize += [self fileSizeAtPath:fileAbsolutePath];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            self.cacheSize = [NSString stringWithFormat:@"%.2fMB",folderSize/(1024.0*1024.0)];
            [self.tableView reloadData];
        });
    });
}


//计算缓存文件的大小的M
- (long long) fileSizeAtPath:(NSString*) filePath{
    NSFileManager* manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath]){
        if ([filePath containsString:@"com.kede.user"]) {
            if ([filePath containsString:@"GlassModel"]) {
                return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
            }
            else
            {
                return 0;
            }
            
        }
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
    }
    
    return 0;
}
- (void)deleteAppCache {
    
    [[SDImageCache sharedImageCache] clearMemory];
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self showWithStatus:NSLocalizedString(@"清理缓存中...", nil)];
        NSString *cachPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask, YES) objectAtIndex:0];
        NSArray *files = [[NSFileManager defaultManager] subpathsAtPath:cachPath];
        
        for (NSString *p in files) {
            NSError *error;
            NSString *path = [cachPath stringByAppendingPathComponent:p];
            if ([path containsString:@"com.kede.user"]) {
                if ([path containsString:@"GlassModel"]) {
                    if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
                        [[NSFileManager defaultManager] removeItemAtPath:path error:&error];
                    }
                }
                else
                {
                    continue;
                }
            }
            if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
                [[NSFileManager defaultManager] removeItemAtPath:path error:&error];
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self clearCacheSuccess];
        });
    });
}



-(void)clearCacheSuccess
{
    NSLog(@"清理成功");
    //暂延迟0.2s执行，防止在上一个showProgress后popActivity 造成count为0，showSuccess马上消失掉
    [self performSelector:@selector(success) withObject:nil afterDelay:0.2];
    [SVProgressHUD popActivity];
    [self getCacheSize];
}

- (void)success {
    [self showSuccessMessage:NSLocalizedString(@"清理成功！", nil)];
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
