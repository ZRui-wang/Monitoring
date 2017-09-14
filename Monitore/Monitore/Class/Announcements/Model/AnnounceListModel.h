//
//  AnnounceListModel.h
//  Monitore
//
//  Created by 小王 on 2017/9/11.
//  Copyright © 2017年 kede. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface CategoryModel : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *categoryId;

@end


@interface AnnounceModel : NSObject

@property (nonatomic, copy) NSString *createtime;
@property (nonatomic, copy) NSString *icon;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *newsId;

@end

@interface AnnounceListModel : NSObject

@property (strong, nonatomic) NSArray *dataList;

@property (copy, nonatomic) NSString *status;

@property (strong, nonatomic) NSArray *categoryList;


@end
