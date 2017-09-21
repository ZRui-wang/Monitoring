//
//  PersonalDataFooterView.h
//  Monitore
//
//  Created by kede on 2017/7/26.
//  Copyright © 2017年 kede. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SaveButtonDelegate <NSObject>

- (void)saveButtonAction;

@end

@interface PersonalDataFooterView : UITableViewHeaderFooterView

@property (nonatomic, assign) id<SaveButtonDelegate> delegate;

@end
