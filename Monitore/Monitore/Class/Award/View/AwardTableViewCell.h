//
//  AwardTableViewCell.h
//  Monitore
//
//  Created by kede on 2017/9/19.
//  Copyright © 2017年 kede. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GiftListModel.h"

@interface AwardTableViewCell : UITableViewCell

- (void)showDetailWithData:(GiftListModel *)model;

@end
