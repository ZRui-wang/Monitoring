//
//  Tools.h
//  Monitore
//
//  Created by kede on 2017/7/28.
//  Copyright © 2017年 kede. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Tools : NSObject

+ (CGFloat)heightForTextWith:(NSString *)text fontSize:(CGFloat)fontSize width:(CGFloat)width;
+ (CGFloat)widthForTextWith:(NSString *)text fontSize:(CGFloat)fontSize height:(CGFloat)height;

@end
