//
//  AnnouncementTableViewCell.h
//  Monitore
//
//  Created by kede on 2017/7/27.
//  Copyright © 2017年 kede. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AnnounceListModel.h"

@protocol DelectDelegate <NSObject>

- (void)delectId:(NSString *)userid;
- (void)dianzan:(NSString *)userid isLike:(BOOL)isLike;


@end

@interface AnnouncementTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *delectButton;
@property (assign, nonatomic) id <DelectDelegate> delegate;
- (void)showDetailWithData:(AnnounceModel *)model;

@end
