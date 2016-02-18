//
//  UIImage+IGKit.m
//  DramaFans
//
//  Created by iGalactus on 16/1/4.
//  Copyright © 2016年 一斌. All rights reserved.
//

#import "UIImage+IGKit.h"

@implementation UIImage (IGKit)

+(UIImage *)imageWithColor:(UIColor *)color
{
    return [self imageWithColor:color imageSize:CGSizeMake(1, 1)];
}

+(UIImage *)imageWithColor:(UIColor *)color imageSize:(CGSize)imageSize
{
    CGRect rect = CGRectMake(0, 0, imageSize.width, imageSize.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end
