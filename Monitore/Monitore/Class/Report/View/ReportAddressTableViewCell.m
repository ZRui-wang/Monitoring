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
        
        [self getGeoCoedAddress:address];
        
    }];
}

- (void)getGeoCoedAddress:(NSString *)address{
    CLGeocoder *myGeocoder = [[CLGeocoder alloc] init];
    [myGeocoder geocodeAddressString:address completionHandler:^(NSArray *placemarks, NSError *error) {
        if ([placemarks count] > 0 && error == nil) {
            NSLog(@"Found %lu placemark(s).", (unsigned long)[placemarks count]);
            CLPlacemark *firstPlacemark = [placemarks objectAtIndex:0];
            NSLog(@"Longitude = %f", firstPlacemark.location.coordinate.longitude);
            NSLog(@"Latitude = %f", firstPlacemark.location.coordinate.latitude);
            
            if ([_delegate respondsToSelector:@selector(reportAddress:longitude:latituded:)]) {
                [_delegate reportAddress:address longitude:[NSString stringWithFormat:@"%f", firstPlacemark.location.coordinate.longitude] latituded:[NSString stringWithFormat:@"%f", firstPlacemark.location.coordinate.latitude]];
            }
        }
        else if ([placemarks count] == 0 && error == nil) {
            NSLog(@"Found no placemarks.");
        } else if (error != nil) {
            NSLog(@"An error occurred = %@", error);
        }
    }];
}

- (IBAction)refreshAddressBtnAction:(id)sender {
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
