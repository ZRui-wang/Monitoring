//
//  Tools.h
//  Monitore
//
//  Created by kede on 2017/7/28.
//  Copyright © 2017年 kede. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserTitle.h"

@interface Tools : NSObject


typedef void(^AddressBlock)(NSString *);

+ (id)sharedTools;
- (void)getCurrentAddress:(AddressBlock)addressBlock;

+ (CGFloat)heightForTextWith:(NSString *)text fontSize:(CGFloat)fontSize width:(CGFloat)width;
+ (CGFloat)widthForTextWith:(NSString *)text fontSize:(CGFloat)fontSize height:(CGFloat)height;

// 归档
+ (void)savePersonData:(UserTitle *)userTitle;

+ (UserTitle *)getPersonData;

+ (BOOL)checkLimitLocation;
@end
