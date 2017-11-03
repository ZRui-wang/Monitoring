//
//  ReportAddressTableViewCell.h
//  Monitore
//
//  Created by kede on 2017/8/12.
//  Copyright © 2017年 kede. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AddressDelegate <NSObject>

- (void)reportAddress:(NSString *)address longitude:(NSString *)longitude latituded:(NSString *)latitude;


@end

@interface ReportAddressTableViewCell : UITableViewCell

@property (assign,nonatomic) id<AddressDelegate> delegate;

@end
