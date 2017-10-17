//
//  DetailViewController.m
//  Monitore
//
//  Created by kede on 2017/8/10.
//  Copyright © 2017年 kede. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIView *bgView;

@property (nonatomic, strong)YYTextView *textView;
@property (nonatomic, strong)UIWebView *webView;

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self leftCustomBarButton];
    self.title = @"详情";
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.bgView.frame.size.height)];
    
//    self.textView = [[YYTextView alloc]initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH-20, SCREEN_HEIGHT-125)];
    [self.bgView addSubview:self.webView];
    
    [self getInfoDetail];
    
}

- (void)getInfoDetail{
    NSDictionary *dic = @{@"ID":self.infoId};
    [self showWithStatus:@"加载中..."];
    [[DLAPIClient sharedClient]POST:@"infoDetail" parameters:dic success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([responseObject[Kstatus]isEqualToString:Ksuccess]) {
            [self removeLoadingHUD];
            NSString *htmlStr = [responseObject[@"data"]objectForKey:@"detail"];
            NSAttributedString *atterStr = [[NSAttributedString alloc]initWithData:[htmlStr dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
//            self.textView.attributedText = atterStr;
            [self.webView loadHTMLString:htmlStr baseURL:nil];
            self.titleLabel.text = [responseObject[@"data"]objectForKey:@"title"];
            self.timeLabel.text = [NSString stringWithFormat:@"%@  作者：%@", [responseObject[@"data"]objectForKey:@"createtime"], [responseObject[@"data"]objectForKey:@"author"]];
        }else{
            [self showErrorMessage:responseObject[Kinfo]];
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
