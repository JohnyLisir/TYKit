//
//  IGPhotoToolbar.h
//  xiangdemei
//
//  Created by iGalactus on 15/12/29.
//  Copyright © 2015年 一斌. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IGPhotoToolbar : UIView

@property (nonatomic,copy) NSString *indexText;

//保存按钮点击回调
@property (nonatomic,copy) void (^ saveActionBlock)();

//退出按钮点击回调
@property (nonatomic,copy) void (^ exitActionBlock)();

@end
