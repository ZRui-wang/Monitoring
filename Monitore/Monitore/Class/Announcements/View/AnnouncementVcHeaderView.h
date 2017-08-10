//
//  AnnouncementVcHeaderView.h
//  Monitore
//
//  Created by kede on 2017/7/27.
//  Copyright © 2017年 kede. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^ButtonRefreshBlock)(BOOL, BOOL);

@interface AnnouncementVcHeaderView : UITableViewHeaderFooterView

@property (weak, nonatomic) IBOutlet UIButton *typeButton;
@property (weak, nonatomic) IBOutlet UIButton *stateButton;

@property (copy, nonatomic) ButtonRefreshBlock refreshButtonBlock;

@end
