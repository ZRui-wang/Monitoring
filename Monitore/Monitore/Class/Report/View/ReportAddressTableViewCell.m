//
//  ReportAddressTableViewCell.m
//  Monitore
//
//  Created by kede on 2017/8/12.
//  Copyright © 2017年 kede. All rights reserved.
//

#import "ReportAddressTableViewCell.h"

@interface ReportAddressTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;

@end

@implementation ReportAddressTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [[Tools sharedTools] getCurrentAddress:^(NSString *address) {
        self.addressLabel.text = address;
    }];
}

- (IBAction)refreshAddressBtnAction:(id)sender {
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
