//
//  uploadPhotoView.m
//  Monitore
//
//  Created by 小王 on 2017/8/13.
//  Copyright © 2017年 kede. All rights reserved.
//

#import "UploadPhotoView.h"
#import "UploadPhotoCollectionViewCell.h"

@interface UploadPhotoView ()<UICollectionViewDelegate, UICollectionViewDataSource, UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *layout;

@end

@implementation UploadPhotoView
{
    NSInteger photoNumb;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    photoNumb = 1;
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.collectionView registerNib:[UINib nibWithNibName:@"UploadPhotoCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"UploadPhotoCollectionViewCell"];
    
    self.layout.itemSize = CGSizeMake(SCREEN_WIDTH/3.0-20, SCREEN_WIDTH/3.0-20);
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.photoArray.count<4 ? self.photoArray.count : 3;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UploadPhotoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"UploadPhotoCollectionViewCell" forIndexPath:indexPath];
    cell.cellRow = indexPath.row;
    
    __weak __typeof__(self) weakSelf = self;
    cell.block = ^(NSInteger cellRow){
        [weakSelf.photoArray removeObjectAtIndex:cellRow];
        [weakSelf.collectionView reloadData];
        
        NSDictionary *dic = @{@"row":[NSNumber numberWithInteger:cellRow]};
        
        [[NSNotificationCenter defaultCenter]postNotificationName:@"delectPhoto" object:nil userInfo:dic];
    };
    
    if (self.photoArray.count) {
        [cell displayCellImage:self.photoArray[indexPath.item] photoNumb:indexPath.row photoCount:self.photoArray.count];
    }
    
    return cell;
}

- (UIEdgeInsets)collectionView:
(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 15, 0, 15);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 15;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.photoArray.count-1 == indexPath.row) {
        if ([_delegate respondsToSelector:@selector(takePhotos)]) {
            [_delegate takePhotos];
        }
    }

}



//- (NSMutableArray *)photoArray{
//    if (_photoArray == nil) {
//        _photoArray = [NSMutableArray array];
//    }
//    return _photoArray;
//}


@end
