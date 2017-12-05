//
//  uploadPhotoView.h
//  Monitore
//
//  Created by 小王 on 2017/8/13.
//  Copyright © 2017年 kede. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TakePhotosDelegate <NSObject>

- (void)takePhotos;

@end

@interface UploadPhotoView : UITableViewHeaderFooterView

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (assign, nonatomic) BOOL isTakeVideo;
@property (strong, nonatomic)NSMutableArray *photoArray;
@property (assign, nonatomic) id<TakePhotosDelegate> delegate;

@end
