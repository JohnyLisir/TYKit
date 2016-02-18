//
//  UIView+IGKit.h
//  DramaFans
//
//  Created by iGalactus on 16/1/4.
//  Copyright © 2016年 一斌. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^ gestureTapedBlock)();

@interface UIView (IGKit)

//为视图添加一个单击的点击事件,以block回调
-(void)insertTapGestureWithBlock:(gestureTapedBlock)block;
//为视图添加一个单击的点击事件,以SEL回调
-(void)insertTapGestureWithAction:(SEL)action;

@end
