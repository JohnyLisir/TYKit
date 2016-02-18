//
//  IGMasker.h
//  IGCustom
//
//  Created by iGalactus on 16/1/21.
//  Copyright © 2016年 一斌. All rights reserved.
//

#import <UIKit/UIKit.h>
///IGMasker如果父视图为空,则默认添加到当前Window上
//在一个View中默认只存在一个,如果想要添加多个,请直接用实例创建,不要用类方法

typedef enum {
    IGMaskerTypeNone    = 0, //无状态(默认)
    IGMaskerTypeSucceed = 1, //正确
    IGMaskerTypeError   = 2, //错误
    IGMaskerTypeWarning = 3, //提醒
    IGMaskerTypeWaiting = 4, //等待框
    IGMaskerTypeCustom  = 5, //自定义控件
}IGMaskerType;

typedef enum {
    IGMaskerAnimationTypeNone   = 0, //无状态
    IGMaskerAnimationTypeBounce = 1, //弹簧效果(默认)
    IGMaskerAnimationTypeDrawer = 2, //从下面淡出
}IGMaskerAnimationType;

typedef void (^ maskerDidCompleteBlock)();

@interface IGMasker : UIView



///显示类型
//显示的头部Icon类型,默认为不显示
//如果只有一个单一的icon控件,则默认该控件会占满整个masker
@property (nonatomic) IGMaskerType maskerType;
//弹出的方式,默认为没有效果
@property (nonatomic) IGMaskerAnimationType maskerShowType;
//消失的方式,默认为没有效果
@property (nonatomic) IGMaskerAnimationType maskerHiddenType;



///视图相关
//是否禁止用户点击
//有该属性的时候,默认背景层为带有alpha为0.4的黑色背景层
@property (nonatomic) BOOL isUserDisallowedTouch;
//背景色,是指Masker这个弹出层下的背景色,比如禁止用户点击时,需要有一个黑色背景的遮罩层
@property (nonatomic,strong) UIColor *maskerBackgroundColor;
//头部Icon的边框,线段颜色,默认为白色
//如果是等待框,则设置等待框颜色
@property (nonatomic,strong) UIColor *iconTintColor;
//文字控件
//字体大小默认为15
@property (nonatomic,strong) UILabel *contentLabel;
//背景控件
//默认cornerRadius = 8.f,bartintColor为黑色
@property (nonatomic,strong) UIToolbar *masker;
//自动消失的时间
//如果不设置该值,则不消失
//默认为0秒
@property (nonatomic) NSTimeInterval autoHiddenTimeInterval;



///控件自定义
//自定义Masker的尺寸
//默认为100*100,宽度最小不建议小于50,高度最小不建议小于50
@property (nonatomic) CGSize maskerCustomizedSize;
//contentLabel距离上下左右的距离
//默认为10
@property (nonatomic) CGFloat contentLabelPadding;
//icon距离masker的顶部的距离
//默认为15
@property (nonatomic) CGFloat iconTopPadding;
//icon的尺寸
//默认为35*35
@property (nonatomic) CGSize maskerIconSize;
//自定义的头部控件
@property (nonatomic,strong) UIView *maskerHeader;



///类方法
//默认如果没有delayTime该参数,则默认不消失
//view可为空,则添加与当前window上
+(void)maskerShowWithStatus:(NSString *)status; //只显示文字,默认两秒消失
+(void)maskerShowDisallowInteractionWithStatus:(NSString *)status showInView:(UIView *)view; //有背景层的等待框
+(void)maskerShowWithType:(IGMaskerType)type showInView:(UIView *)view;
+(void)maskerShowWithType:(IGMaskerType)type status:(NSString *)status showInView:(UIView *)view;
+(void)maskerShowWithType:(IGMaskerType)type status:(NSString *)status delayTime:(NSTimeInterval)delayTime showInView:(UIView *)view;
+(void)maskerShowWithType:(IGMaskerType)type status:(NSString *)status delayTime:(NSTimeInterval)delayTime showInView:(UIView *)view maskerCompleteBlock:(maskerDidCompleteBlock)block;
+(void)maskerHiddenInView:(UIView *)view;



//展示Masker控件
-(void)maskerShow;
//隐藏Masker控件
-(void)maskerHidden;
//如果有自动消失定时器,结束后的回调
@property (nonatomic,copy) maskerDidCompleteBlock block;

@end
