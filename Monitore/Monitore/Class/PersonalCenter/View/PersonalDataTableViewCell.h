//
//  PersonalDataTableViewCell.h
//  Monitore
//
//  Created by kede on 2017/7/26.
//  Copyright © 2017年 kede. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol SaveInfoDelegate <NSObject>

- (void)buildInfoRow:(NSInteger)row info:(NSString *)info;

@end

@interface PersonalDataTableViewCell : UITableViewCell

@property (nonatomic, strong)NSIndexPath *indexPath;
@property (nonatomic, copy)NSString *date;
@property (nonatomic, copy)NSString *mobile;
@property (nonatomic, assign) id<SaveInfoDelegate> delegate;

- (void)displayCellWithData:(NSDictionary *)dic andIndexpath:(NSIndexPath *)indexPath;

@end
