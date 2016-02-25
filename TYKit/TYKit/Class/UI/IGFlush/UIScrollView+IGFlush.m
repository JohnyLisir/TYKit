//
//  UIScrollView+IGFlush.m
//  IGCustom
//
//  Created by iGalactus on 16/1/23.
//  Copyright © 2016年 一斌. All rights reserved.
//

#import "UIScrollView+IGFlush.h"
#import "IGFlushConfig.h"
#import "IGFlushTop.h"
#import "IGFlushBottom.h"
#import <objc/runtime.h>

@interface UIScrollView()

@property (nonatomic,strong) IGFlushTop *flushTop;
@property (nonatomic,strong) IGFlushBottom *flushBottom;

@end

@implementation UIScrollView (IGFlush)
static char topFlushKey,bottomFlushKey;

-(void)insertTopFlushWithResponse:(flushMovementBlock)block{
    if (!self.flushTop) {
        self.flushTop = [[IGFlushTop alloc] initWithScrollView:self response:block];
        [self addSubview:self.flushTop];
    }
}

-(void)topFlushStopAnimation{
    if (self.flushTop) {
        if (self.flushTop.flushStatus == IGFlushStatusOperation) {
            self.flushTop.flushStatus = IGFlushStatusOriginal;
        }
    }
}

-(void)destoryTopFlush{
    if (self.flushTop) {
        [self.flushTop removeFromSuperview]; self.flushTop = nil;
    }
}

-(void)insertBottomFloshWithReponse:(flushMovementBlock)block{
    if (!self.flushBottom) {
        self.flushBottom = [[IGFlushBottom alloc] initWithScrollView:self response:block];
        [self addSubview:self.flushBottom];
    }
}

-(void)bottomFlushStopAnimation{
    if (self.flushBottom) {
        if (self.flushBottom.flushStatus == IGFlushStatusOperation) {
            self.flushBottom.flushStatus = IGFlushStatusOriginal;
        }
    }
}

-(void)bottomFlushStopAnimationForever{
    if (self.flushBottom) {
        if (self.flushBottom.flushStatus == IGFlushStatusOperation) {
            self.flushBottom.flushStatus = IGFlushStatusHiddenForever;
        }
    }
}

-(void)destoryBottomFlush{
    if (self.flushBottom) {
        [self.flushBottom removeFromSuperview]; self.flushBottom = nil;
    }
}

-(void)setFlushTop:(IGFlushTop *)flushTop{
    objc_setAssociatedObject(self, &topFlushKey, flushTop, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(void)setFlushBottom:(IGFlushBottom *)flushBottom{
    objc_setAssociatedObject(self, &bottomFlushKey, flushBottom, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(IGFlushTop *)flushTop{
    return objc_getAssociatedObject(self, &topFlushKey);
}

-(IGFlushBottom *)flushBottom{
    return objc_getAssociatedObject(self, &bottomFlushKey);
}

@end
