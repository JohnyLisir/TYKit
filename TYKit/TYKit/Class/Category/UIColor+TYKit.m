//
//  UIColor+TYKit.m
//  TYKit
//
//  Created by yanyibin on 16/2/25.
//  Copyright © 2016年 yanyibin. All rights reserved.
//

#import "UIColor+TYKit.h"

@implementation UIColor (TYKit)

-(UIImage *)image{
    return [self imageWithSize:CGSizeMake(1, 1)];
}

-(UIImage *)imageWithSize:(CGSize)size{
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [self CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end
