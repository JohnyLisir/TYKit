//
//  IGPhotoScanner.h
//  xiangdemei
//
//  Created by iGalactus on 15/12/29.
//  Copyright © 2015年 一斌. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IGPhotoObject.h"

@interface IGPhotoScanner : UIView

////展示顶部的标题栏 默认不显示
@property (nonatomic) BOOL showTopTitleBar;
@property (nonatomic,strong) UILabel *titleLabel;

////展示底部的内容栏 默认不显示
@property (nonatomic) BOOL showBottomContentBar;
@property (nonatomic,strong) UILabel *contentLabel;

////内容集合
@property (nonatomic,strong) NSArray *photoObjectList;
//子集必须为图片的URL的String类型或者UIImage类型
@property (nonatomic,strong) NSArray *photosList;
//显示的序号 默认为0
@property (nonatomic) NSInteger showIndex;

////加载占位图
@property (nonatomic,strong) UIImage *placeHolderImage;

//图片最大/最小伸缩尺寸 默认为3.0 / 1.0
@property (nonatomic) CGFloat maxScale , minScale;

//当总数目为1的时候,默认禁止出现序号Label
@property (nonatomic) BOOL banShowIndexLabel;

////方法
-(void)photoViewShow;
-(void)photoViewDismiss;

////类方法


@end
