//
//  TextViewTableViewCell.h
//  Monitore
//
//  Created by kede on 2017/7/28.
//  Copyright © 2017年 kede. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol textViewDidFinishEidedDelegate <NSObject>

- (void)finishEditHeigh:(CGFloat)heigh row:(NSInteger)row;

@end

@interface TextViewTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UILabel *plaseholdLabel;
@property (assign,nonatomic) NSInteger cellRow;

@property (assign, nonatomic) id<textViewDidFinishEidedDelegate> delegate;

- (void)diaplayCell:(NSString *)title;
@end
