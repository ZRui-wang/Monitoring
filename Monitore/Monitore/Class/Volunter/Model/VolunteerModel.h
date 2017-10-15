//
//  VolunteerModel.h
//  Monitore
//
//  Created by kede on 2017/9/20.
//  Copyright © 2017年 kede. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VolModel : NSObject

@property (copy, nonatomic) NSString *name;
@property (copy, nonatomic) NSString *icon;
@property (copy, nonatomic) NSString *latitude;
@property (copy, nonatomic) NSString *longitude;




@end


@interface VolunteerModel : NSObject

@property (strong, nonatomic) NSArray *childList;
@property (copy, nonatomic) NSString *name;
@property (assign, nonatomic) BOOL isExpand;


@end
