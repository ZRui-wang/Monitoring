//
//  PersonalPhotoTableViewCell.h
//  Monitore
//
//  Created by kede on 2017/7/26.
//  Copyright © 2017年 kede. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SaveInfoDelegate <NSObject>

- (void)buildInfoRow:(NSInteger)row info:(NSString *)info;

@end

@interface PersonalPhotoTableViewCell : UITableViewCell

@property (nonatomic, assign) id<SaveInfoDelegate> delegate;

@end
