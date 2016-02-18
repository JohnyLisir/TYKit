//
//  UIView+IGKit.m
//  DramaFans
//
//  Created by iGalactus on 16/1/4.
//  Copyright © 2016年 一斌. All rights reserved.
//

#import "UIView+IGKit.h"
#import <objc/runtime.h>

@interface UIView()

@property (nonatomic,copy) gestureTapedBlock gestureTapBlock;

@end

@implementation UIView (IGKit)
static char tapBlockKey;

-(void)insertTapGestureWithBlock:(gestureTapedBlock)block
{
    self.gestureTapBlock = block;
    self.userInteractionEnabled = YES;
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gestureAction)];
    [self addGestureRecognizer:gesture];
}

-(void)insertTapGestureWithAction:(SEL)action
{
    self.userInteractionEnabled = YES;
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:action];
    [self addGestureRecognizer:gesture];
}

-(void)gestureAction
{
    if (self.gestureTapBlock) {
        self.gestureTapBlock();
    }
}

-(void)setGestureTapBlock:(gestureTapedBlock)gestureTapBlock
{
    objc_setAssociatedObject(self, &tapBlockKey, gestureTapBlock, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(gestureTapedBlock)gestureTapBlock
{
    return objc_getAssociatedObject(self, &tapBlockKey);
}

@end
