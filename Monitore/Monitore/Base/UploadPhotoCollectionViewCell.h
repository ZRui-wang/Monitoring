//
//  UploadPhotoCollectionViewCell.h
//  Monitore
//
//  Created by 小王 on 2017/8/13.
//  Copyright © 2017年 kede. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^DelectPhotoBlock)(NSInteger);

@interface UploadPhotoCollectionViewCell : UICollectionViewCell

- (void)displayCellImage:(UIImage *)photo photoNumb:(NSInteger)numb photoCount:(NSInteger)count;
@property (assign, nonatomic) NSInteger cellRow;
@property (copy, nonatomic) DelectPhotoBlock block;
@end
