//
//  VolunteerListHeaderView.h
//  Monitore
//
//  Created by kede on 2017/9/20.
//  Copyright © 2017年 kede. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ExpandSectionDelegate <NSObject>

- (void)expandSection:(NSInteger)section isExpand:(BOOL)expand;

@end

@interface VolunteerListHeaderView : UITableViewHeaderFooterView

@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UIButton *expandBtn;

@property (assign, nonatomic) NSInteger headerSecction;

@property (assign, nonatomic) id<ExpandSectionDelegate> delegate;

@end
