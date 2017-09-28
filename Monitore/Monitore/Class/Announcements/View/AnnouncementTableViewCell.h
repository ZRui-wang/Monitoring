//
//  AnnouncementTableViewCell.h
//  Monitore
//
//  Created by kede on 2017/7/27.
//  Copyright © 2017年 kede. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AnnounceListModel.h"

@interface AnnouncementTableViewCell : UITableViewCell

- (void)showDetailWithData:(AnnounceModel *)model;

@end
