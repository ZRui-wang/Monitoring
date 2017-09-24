//
//  HomeHeaderView.h
//  Monitore
//
//  Created by kede on 2017/7/24.
//  Copyright © 2017年 kede. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeHeaderView : UICollectionReusableView

@property (weak, nonatomic) IBOutlet UIButton *signInButton;

@property (weak, nonatomic) IBOutlet UIButton *rewardButton;

@property (weak, nonatomic) IBOutlet UIButton *collectButton;

@property (strong, nonatomic) NSMutableArray *bannerAry;

@end
