//
//  SexTableViewCell.h
//  Monitore
//
//  Created by kede on 2017/9/25.
//  Copyright © 2017年 kede. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SelectSexDelegate <NSObject>

- (void)selectSexIsMan:(BOOL)isMan;

@end

@interface SexTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *womenButton;

@property (weak, nonatomic) IBOutlet UIButton *manButton;

@property (assign,nonatomic) id<SelectSexDelegate> delegate;

@end
