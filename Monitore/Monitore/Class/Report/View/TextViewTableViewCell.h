//
//  TextViewTableViewCell.h
//  Monitore
//
//  Created by kede on 2017/7/28.
//  Copyright © 2017年 kede. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol textViewDidFinishEidedDelegate <NSObject>

- (void)finishEdit;

@end

@interface TextViewTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UILabel *plaseholdLabel;

@property (assign, nonatomic) id<textViewDidFinishEidedDelegate> delegate;
@end
