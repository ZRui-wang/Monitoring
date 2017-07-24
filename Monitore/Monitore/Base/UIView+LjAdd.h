//
//  UIView+LjAdd.h
//  Monitore
//
//  Created by kede on 2017/7/24.
//  Copyright © 2017年 kede. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (LjAdd)

- (void)beautifyViewWithBorderColor:(UIColor *)color borderWidth:(CGFloat)width radius:(CGFloat)radius;

+ (id)xibView;
@end
