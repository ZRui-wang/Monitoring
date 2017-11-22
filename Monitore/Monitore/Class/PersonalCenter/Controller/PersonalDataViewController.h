//
//  PersonalDataViewController.h
//  Monitore
//
//  Created by kede on 2017/7/26.
//  Copyright © 2017年 kede. All rights reserved.
//

#import "BaseViewController.h"
#import "UserModel.h"

@interface PersonalDataViewController : BaseViewController
@property (nonatomic, strong) UserModel *model;
@property (nonatomic, strong) NSArray *addressAry;
@end
