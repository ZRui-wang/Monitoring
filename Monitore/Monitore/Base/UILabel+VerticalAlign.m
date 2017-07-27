//
//  UILabel+VerticalAlign.m
//  Dualens
//
//  Created by kede on 2017/7/12.
//  Copyright © 2017年 JK. All rights reserved.
//

#import "UILabel+VerticalAlign.h"

@implementation UILabel (VerticalAlign)

- (void)alignTop
{
//    CGSize fontSize = [self.text sizeWithFont:self.font];
    CGSize fontSize = [self.text sizeWithAttributes:@{NSFontAttributeName:self.font}];
    
    double finalHeight = fontSize.height * self.numberOfLines;
    double finalWidth = self.frame.size.width;    //expected width of label
    
    CGSize theStringSize = [self.text boundingRectWithSize:fontSize options:NSStringDrawingTruncatesLastVisibleLine attributes:@{NSFontAttributeName: self.font} context:nil].size;
//    CGSize theStringSize = [self.text sizeWithFont:self.font constrainedToSize:CGSizeMake(finalWidth, finalHeight) lineBreakMode:self.lineBreakMode];
    
    
    int newLinesToPad = (finalHeight  - theStringSize.height) / fontSize.height;
    
    for(int i=0; i<= newLinesToPad+1; i++)
    {
        self.text = [self.text stringByAppendingString:@" \n"];
    }
}

- (void)alignBottom
{
//    CGSize fontSize = [self.text sizeWithFont:self.font];
    CGSize fontSize = [self.text sizeWithAttributes:@{NSFontAttributeName:self.font}];
    
    double finalHeight = fontSize.height * self.numberOfLines;
    double finalWidth = self.frame.size.width;    //expected width of label
    
    
    CGSize theStringSize = [self.text sizeWithFont:self.font constrainedToSize:CGSizeMake(finalWidth, finalHeight) lineBreakMode:self.lineBreakMode];
    
    
    int newLinesToPad = (finalHeight  - theStringSize.height) / fontSize.height;
    
    for(int i=0; i< newLinesToPad; i++)
    {
        self.text = [NSString stringWithFormat:@" \n%@",self.text];
    }
}

@end
