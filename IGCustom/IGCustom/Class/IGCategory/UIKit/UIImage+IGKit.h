//
//  UIImage+IGKit.h
//  DramaFans
//
//  Created by iGalactus on 16/1/4.
//  Copyright © 2016年 一斌. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (IGKit)

//根据颜色返回一个1*1像素的图像
+(UIImage *)imageWithColor:(UIColor *)color;

//返回一个特定尺寸的图像
+(UIImage *)imageWithColor:(UIColor *)color imageSize:(CGSize)imageSize;

@end
