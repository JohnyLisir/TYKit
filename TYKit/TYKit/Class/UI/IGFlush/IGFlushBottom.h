//
//  IGFlushBottom.h
//  IGCustom
//
//  Created by iGalactus on 16/1/23.
//  Copyright © 2016年 一斌. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IGFlushConfig.h"

@interface IGFlushBottom : UIView

-(instancetype)initWithScrollView:(UIScrollView *)scrollView response:(void (^)())block;
//状态
@property (nonatomic) IGFlushStatus flushStatus;
//尾部高度
@property (nonatomic) CGFloat bottomFlushHeight;

@end
