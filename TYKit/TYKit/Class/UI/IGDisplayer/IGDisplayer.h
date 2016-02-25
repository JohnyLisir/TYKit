//
//  IGDisplayer.h
//  IGCustom
//
//  Created by iGalactus on 16/1/22.
//  Copyright © 2016年 一斌. All rights reserved.
//

#import <UIKit/UIKit.h>
@class IGDisplayer;

typedef enum {
    IGDisplayerPositionTypeCenter = 0, //类似AlertView(默认)
    IGDisplayerPositionTypeBottom = 1, //类似ActionSheet
}IGDisplayerPositionType;

typedef enum {
    IGDisplayerContentTypeDefault = 0, //只包含文字(默认)
    IGDisplayerContentTypeInputs  = 1, //输入框(!!暂时还没做)
    IGDisplayerContentTypeCustom  = 2, //自定义视图
}IGDisplayerContentType;

typedef enum {
    IGDisplayerShowTypeBounce  = 0, //弹簧效果(默认) /不支持-> IGDisplayerPositionTypeBottom
    IGDisplayerShowTypeDrawer  = 1, //划出效果
}IGDisplayerShowType;

typedef void (^ displayerActionBlock)(IGDisplayer *displayer , NSInteger index);

@interface IGDisplayer : UIView


//主视图的位置
@property (nonatomic) IGDisplayerPositionType displayerPositionType;
//内容视图
@property (nonatomic) IGDisplayerContentType displayerContentType;
//主视图出现的方式
@property (nonatomic) IGDisplayerShowType displayerShowType;


///视图控件
//主视图
@property (nonatomic,strong) UIView *displayer;
//标题控件
@property (nonatomic,strong) UILabel *titleLabel;
//内容控件
@property (nonatomic,strong) UILabel *textLabel;
//自定义内容控件
@property (nonatomic,strong) UIView *customView;


///按钮
//取消按钮
@property (nonatomic,strong) UIButton *cancelButton;
//是否隐藏'取消按钮'
@property (nonatomic) BOOL isHiddenCancelButton;
//其他按钮列表,可传入'UIButton', 当传入NSString时,按钮为默认样式
@property (nonatomic,strong) NSArray *otherButtonList;
//其他按钮的字体颜色,默认为红色
@property (nonatomic,strong) UIColor *otherButtonTitleColor;
//是否开启触摸背景层以取消视图,默认为否
@property (nonatomic) BOOL isHiddenDisplayerByTouch;
//按钮点击的回调,取消按钮的index为999
@property (nonatomic,copy) displayerActionBlock displayerActionBlock;
//是否点击后不取消视图,默认为NO
@property (nonatomic) BOOL isHiddenDisplayerWhenSelected;


///尺寸
//主视图宽度
//当displayerPositionType为（IGDisplayerPositionTypeBottom）时,该属性无效
@property (nonatomic) CGFloat displayerWidth;
//标题控件与主视图的内边距,默认为(10, 10, 5, 10)
@property (nonatomic) UIEdgeInsets titleEdgeInsets;
//内容视图与主视图的内边距,默认为(0, 10, 0, 10)
@property (nonatomic) UIEdgeInsets contentEdgeInsets;
//自定义内容控件尺寸
//设置该值的时候,contentEdgeInsets的left和right无效
//默认为250*300
@property (nonatomic) CGSize customViewSize;
//是否自定义主视图宽度等于控件宽度,默认为YES
@property (nonatomic) BOOL isCustomWidthEqualToDisplayer;
//按钮之间的间距,默认为0.5
@property (nonatomic) CGFloat buttonsInset;
//按钮的高度 默认为45
@property (nonatomic) CGFloat buttonHeight;


///类方法
+(void)showDisplayerWithPositionType:(IGDisplayerPositionType)positionType titleText:(NSString *)title contentText:(NSString *)content cancelButtonTitle:(NSString *)cancelButtonTitle buttonList:(NSArray *)buttons handleActionBlock:(displayerActionBlock)block;

//展示主视图
-(void)displayerShow;
//隐藏主视图
-(void)displayerHidden;

@end
