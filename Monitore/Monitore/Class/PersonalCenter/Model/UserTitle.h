//
//  userTitle.h
//  Monitore
//
//  Created by kede on 2017/9/11.
//  Copyright © 2017年 kede. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserTitle : NSObject<NSCoding>

@property (copy, nonatomic) NSString *pcs;
@property (copy, nonatomic) NSString *nickname;
@property (assign, nonatomic) NSInteger stars;
@property (assign, nonatomic) NSInteger score;
@property (copy, nonatomic) NSString *usersId;
@property (copy, nonatomic) NSString *mobile;

@end
