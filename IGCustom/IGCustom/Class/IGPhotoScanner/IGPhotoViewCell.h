//
//  IGPhotoView.h
//  xiangdemei
//
//  Created by iGalactus on 15/12/29.
//  Copyright © 2015年 一斌. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IGPhotoViewCell : UICollectionViewCell

//设置最大/最小的缩放程度
@property (nonatomic) CGFloat maxScale , minScale;

//初始化
-(void)initWithPhotoURL:(NSString *)photoURL placeHolderImage:(UIImage *)placeHolderImage;
-(void)initWithImage:(UIImage *)image;

//点击回调
@property (nonatomic,copy) void (^ singleTapBlock)();

//加载完成后的图片 用于保存
@property (nonatomic,strong) UIImage *saveImage;

@end
