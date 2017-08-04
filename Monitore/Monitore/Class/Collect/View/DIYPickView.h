//
//  DIYPickView.h
//  Monitore
//
//  Created by kede on 2017/8/4.
//  Copyright © 2017年 kede. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DIYPickView : UIView

@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UIButton *confirmButton;

@end
