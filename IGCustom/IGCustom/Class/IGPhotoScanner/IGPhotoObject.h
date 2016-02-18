//
//  IGPhotoObject.h
//  xiangdemei
//
//  Created by iGalactus on 15/12/29.
//  Copyright © 2015年 一斌. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IGPhotoObject : NSObject

@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *content;
@property (nonatomic,copy) NSString *imageURL;
//用于加载直接的图片,如果有该属性,则最先展示这些图片
@property (nonatomic,strong) UIImage *photo;

@end
