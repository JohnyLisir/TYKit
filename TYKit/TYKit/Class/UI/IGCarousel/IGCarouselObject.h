//
//  IGCarouselObject.h
//  IGCustom
//
//  Created by iGalactus on 15/12/30.
//  Copyright © 2015年 一斌. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IGCarouselObject : NSObject

@property (nonatomic,copy) NSString *carouselId;
@property (nonatomic,copy) NSString *imageURL;
@property (nonatomic,copy) NSString *content;
@property (nonatomic,copy) NSString *pushURL; //链接的地址

@end
