//
//  AnnouncementVcHeaderView.m
//  Monitore
//
//  Created by kede on 2017/7/27.
//  Copyright © 2017年 kede. All rights reserved.
//

#import "AnnouncementVcHeaderView.h"

@implementation AnnouncementVcHeaderView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshButton) name:@"hidenBgView" object:nil];
}

- (void)refreshButton{
    self.typeButton.selected = NO;
    self.stateButton.selected = NO;
}


- (IBAction)typeButtonAction:(UIButton *)sender {
    
    if (sender.isSelected) {
        sender.selected = NO;
    }
    else{
        sender.selected = YES;
        
        if (self.stateButton.isSelected) {
            self.stateButton.selected = NO;
        }
    }
    
    self.refreshButtonBlock(self.typeButton.isSelected, self.stateButton.isSelected);
    
}

- (IBAction)stateButtonAction:(UIButton *)sender {

    if (sender.isSelected) {
        sender.selected = NO;
    }
    else{
        sender.selected = YES;
        
        if (self.typeButton.isSelected) {
            self.typeButton.selected = NO;
        }
    }
    
    self.refreshButtonBlock(self.typeButton.isSelected, self.stateButton.isSelected);
}

@end
