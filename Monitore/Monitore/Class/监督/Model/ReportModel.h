//
//  ReportModel.h
//  Monitore
//
//  Created by kede on 2017/9/22.
//  Copyright © 2017年 kede. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ReportModel : NSObject

@property (copy, nonatomic) NSString *userId;
@property (copy, nonatomic) NSString *firstId;
@property (copy, nonatomic) NSString *firstTitle;
@property (copy, nonatomic) NSString *secodeId;
@property (copy, nonatomic) NSString *content;
@property (copy, nonatomic) NSString *title;
@property (copy, nonatomic) NSString *address;
@property (copy, nonatomic) NSString *longitude;
@property (copy, nonatomic) NSString *latitude;
@property (copy, nonatomic) NSString *remark;

@end
