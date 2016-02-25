//
//  UIColor+TYKit.h
//  TYKit
//
//  Created by yanyibin on 16/2/25.
//  Copyright © 2016年 yanyibin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface UIColor (TYKit)

///> 返回该颜色一个1*1大小的UIImage
-(UIImage *)image;

///> 返回一个特定大小的UIImage
-(UIImage *)imageWithSize:(CGSize)size;

@end
