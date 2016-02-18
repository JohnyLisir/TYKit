//
//  IGFlushTop.h
//  IGCustom
//
//  Created by iGalactus on 16/1/23.
//  Copyright © 2016年 一斌. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IGFlushConfig.h"

@interface IGFlushTop : UIView

-(instancetype)initWithScrollView:(UIScrollView *)scrollView response:(void (^)())block;
//状态
@property (nonatomic) IGFlushStatus flushStatus;
//头部高度 默认为40
@property (nonatomic) CGFloat topFlushHeight;

@end
