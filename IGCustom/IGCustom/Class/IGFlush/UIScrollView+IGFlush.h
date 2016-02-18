//
//  UIScrollView+IGFlush.h
//  IGCustom
//
//  Created by iGalactus on 16/1/23.
//  Copyright © 2016年 一斌. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^ flushMovementBlock)();

@interface UIScrollView (IGFlush)

//添加头部刷新控件,并设置回调
-(void)insertTopFlushWithResponse:(flushMovementBlock)block;
//添加尾部刷新控件,并设置回调
-(void)insertBottomFloshWithReponse:(flushMovementBlock)block;
//头部停止刷新
-(void)topFlushStopAnimation;
//尾部停止刷新
-(void)bottomFlushStopAnimation;
//尾部停止刷新,并且设置文字为'空数据'
-(void)bottomFlushStopAnimationForever;
//移除头部控件
-(void)destoryTopFlush;
//移除尾部控件
-(void)destoryBottomFlush;

@end
