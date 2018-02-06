//
//  AreaPickview.h
//  pickview
//
//  Created by 甄翰宏 on 16/3/14.
//  Copyright © 2016年 甄翰宏. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Header.h"
typedef void(^BLOCK)(NSString *province,NSString *pid,  NSString *city,NSString *cid,  NSString *district,NSString *did,  NSString *town, NSString *tid);


@interface AreaPickview : UIView<UIPickerViewDataSource, UIPickerViewDelegate>{
    UIWindow *currentWindow;
    UIWindow *resignWindow;
    UIView *bottomView;
    UIView *naviView;
    UIPickerView *pickview;

}
@property(nonatomic, copy)BLOCK block;

@end
