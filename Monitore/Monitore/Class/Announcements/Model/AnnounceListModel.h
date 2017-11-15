//
//  AnnounceListModel.h
//  Monitore
//
//  Created by 小王 on 2017/9/11.
//  Copyright © 2017年 kede. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface CategoryModel : NSObject

@property (nonatomic, copy) NSString *img;

@end


@interface AnnounceModel : NSObject
@property (nonatomic, copy) NSString *ckCount;
@property (nonatomic, copy) NSString *createtime;
@property (nonatomic, copy) NSString *detail;
@property (nonatomic, copy) NSString *icon;
@property (nonatomic, strong) NSArray *imgList;
@property (nonatomic, copy) NSString *isDel;
@property (nonatomic, copy) NSString *remark;
@property (nonatomic, copy) NSString *state;
@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *usercircleId;

@end

@interface AnnounceListModel : NSObject

@property (strong, nonatomic) NSArray *dataList;

@property (copy, nonatomic) NSString *status;

@property (strong, nonatomic) NSArray *categoryList;


@end
