//
//  Tools.m
//  Monitore
//
//  Created by kede on 2017/7/28.
//  Copyright © 2017年 kede. All rights reserved.
//

#import "Tools.h"

@implementation Tools

+ (CGFloat)heightForTextWith:(NSString *)text fontSize:(CGFloat)fontSize width:(CGFloat)width {
    
    NSDictionary *attrbute = @{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]};
    return [text boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:(NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin) attributes:attrbute context:nil].size.height;
}

+ (CGFloat)widthForTextWith:(NSString *)text fontSize:(CGFloat)fontSize height:(CGFloat)height {
    
    NSDictionary *attrbute = @{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]};
    return [text boundingRectWithSize:CGSizeMake(MAXFLOAT, height) options:(NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin) attributes:attrbute context:nil].size.width;
}

@end
