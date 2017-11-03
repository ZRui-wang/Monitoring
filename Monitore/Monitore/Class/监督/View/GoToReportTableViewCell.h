//
//  GoToReportTableViewCell.h
//  Monitore
//
//  Created by kede on 2017/7/28.
//  Copyright © 2017年 kede. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BuildReportDicDelegare <NSObject>

- (void)buildInfoRow:(NSInteger)row info:(NSString *)info;

@end

@interface GoToReportTableViewCell : UITableViewCell

@property (assign,nonatomic) id<BuildReportDicDelegare> delegate;

- (void)displayCellTitle:(NSString *)title detail:(NSString *)detail;

@end
