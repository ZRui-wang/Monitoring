//
//  TrainTableViewCell.h
//  Monitore
//
//  Created by kede on 2017/9/19.
//  Copyright © 2017年 kede. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TrainModel.h"

@interface TrainTableViewCell : UITableViewCell

- (void)showDetailWithData:(TrainModel *)model;

@end
