//
//  UIImage+TYKit.h
//  TYKit
//
//  Created by yanyibin on 16/2/25.
//  Copyright © 2016年 yanyibin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (TYKit)

///> Note:
///> 图片是像素点的集合,可以想象成一个二位数组
///> 32位RGBA模式中会将一个颜色存储在32位,或者4个字节中,每一个字节存储一个颜色通道为:R、G、B、A
///> 颜色空间: RGBA、HSV、YUV
///> UIImage和UIView使用的是坐上原点坐标,CoreImage和CoreGraphics使用的是右下原点坐标
///> 

@end
