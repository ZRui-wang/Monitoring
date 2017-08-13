//
//  UploadPhotoCollectionViewCell.m
//  Monitore
//
//  Created by 小王 on 2017/8/13.
//  Copyright © 2017年 kede. All rights reserved.
//

#import "UploadPhotoCollectionViewCell.h"

@interface UploadPhotoCollectionViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *photo;
@property (weak, nonatomic) IBOutlet UIButton *delectBtn;

@end

@implementation UploadPhotoCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)displayCellImage:(UIImage *)photo photoNumb:(NSInteger)numb photoCount:(NSInteger)count{
    
    if (numb == count-1) {
        self.delectBtn.hidden = YES;
    }else{
        self.delectBtn.hidden = NO;
    }
    self.photo.image = photo;
}

- (IBAction)delectBtnAction:(id)sender {
    self.block(self.cellRow);
}


@end
