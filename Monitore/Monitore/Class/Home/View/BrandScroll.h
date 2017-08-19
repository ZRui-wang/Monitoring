//
//  BrandScroll.h
//  eShop
//
//  Created by kede1 on 16/8/2.
//  Copyright © 2016年 Keede. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^zanTingBlock)();
typedef void(^jiXuBlock)();

@interface BrandScroll : UIScrollView

@property (nonatomic,copy) zanTingBlock zanTingBlock;
@property (nonatomic,copy) jiXuBlock jiXuBlock;



@end
