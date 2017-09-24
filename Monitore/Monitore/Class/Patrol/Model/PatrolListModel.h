//
//  PatrolListModel.h
//  Monitore
//
//  Created by 小王 on 2017/9/23.
//  Copyright © 2017年 kede. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PatrolListModel : NSObject

@property (nonatomic, copy) NSString *startAddress;
@property (nonatomic, copy) NSString *startTime;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *state;
@property (nonatomic, copy) NSString *patrolId;

@end
