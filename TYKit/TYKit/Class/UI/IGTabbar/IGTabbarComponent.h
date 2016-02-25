//
//  IGTabbarComponent.h
//  IGCustom
//
//  Created by iGalactus on 16/1/5.
//  Copyright © 2016年 一斌. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IGTabbarComponent : UIButton

//单元标题
@property (nonatomic,strong) UILabel *contentLabel;
//Badge
@property (nonatomic) int badgeValue;
//普通状态的图片
@property (nonatomic,strong) UIImage *normalImage;
//选中状态下的图片
@property (nonatomic,strong) UIImage *selectedImage;
//普通状态下的字体颜色
@property (nonatomic,strong) UIColor *normalTextColor;
//选中状态下的字体颜色
@property (nonatomic,strong) UIColor *selectedTextColor;
//普通状态下按钮的背景颜色,默认为白色
@property (nonatomic,strong) UIColor *normalComponentBackgroundColor;
//选中状态下按钮的背景颜色,默认为白色
@property (nonatomic,strong) UIColor *selectedComponentBackgroundColor;

@end
