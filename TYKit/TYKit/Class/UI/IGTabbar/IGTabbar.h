//
//  IGTabbar.h
//  IGCustom
//
//  Created by iGalactus on 16/1/5.
//  Copyright © 2016年 一斌. All rights reserved.
//

#import <UIKit/UIKit.h>

//该控件不支持自动布局,请手动设置大小
@interface IGTabbar : UIToolbar

//初始选择的序号,会响应 componentSingleTapBlock回调
@property (nonatomic) NSInteger selectedIndex;
//普通状态下的字体颜色 默认颜色为 [UIColor colorWithWhite:0.8f alpha:1.0f]
@property (nonatomic,strong) UIColor *normalTextColor;
//选中状态下的字体颜色 默认颜色为黑色
@property (nonatomic,strong) UIColor *selectedTextColor;
//普通状态下按钮的背景颜色,默认为白色
@property (nonatomic,strong) UIColor *normalComponentBackgroundColor;
//选中状态下按钮的背景颜色,默认为白色
@property (nonatomic,strong) UIColor *selectedComponentBackgroundColor;



//初始化控件 数目由titles控制
-(void)initializeWithTitles:(NSArray *)titles normalImages:(NSArray *)normalImages selectedImages:(NSArray *)selectedImages;
//设置badge
-(void)componentWithBadgeValue:(NSInteger)badgeValues index:(NSInteger)index;
//取消所有badgeValue
-(void)removeAllBadgeValues;
//取消特定的BadgeValue
-(void)removeBadgeValueAtIndex:(NSInteger)index;

//单击事件,会选中
@property (nonatomic,copy) BOOL (^ componentSingleTapBlock) (NSInteger index);
//双击事件,不会选中,如果该按钮不是选中状态下,则会先响应 componentSingleTapBlock 回调,不响应该回调
@property (nonatomic,copy) void (^ componentDoubleTapBlock) (NSInteger index);


@end
