//
//  IGDisplayer.m
//  IGCustom
//
//  Created by iGalactus on 16/1/22.
//  Copyright © 2016年 一斌. All rights reserved.
//

#import "IGDisplayer.h"

@interface IGDisplayer()

@property (nonatomic,strong) UIWindow *overlayWindow;
@property (nonatomic,strong) UIView *buttonsView, *backgroundView;
@property (nonatomic,strong) NSMutableArray *innerButtonsList;

@property (nonatomic) CGFloat topH, contentH, buttonsH;

@end

@implementation IGDisplayer

-(instancetype)init{
    if (self != [super init]) {
        return nil;
    }
    [self initParams];
    return self;
}

-(void)initParams{
    _displayerWidth = 250;
    _buttonHeight = 45;
    _buttonsInset = 0.5f;
    _customViewSize = CGSizeMake(250, 300);
    _titleEdgeInsets = UIEdgeInsetsMake(15, 10, 0, 10);
    _contentEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 10);
    _isHiddenCancelButton = NO;
    _isHiddenDisplayerWhenSelected = YES;
    _isHiddenDisplayerByTouch = NO;
    _isCustomWidthEqualToDisplayer = YES;
    _otherButtonTitleColor = [UIColor colorWithRed:241.0 / 255.0 green:67.0 / 255.0 blue:67.0 / 255.0 alpha:1.0f];
    
    _displayerShowType = IGDisplayerShowTypeBounce;
    _displayerPositionType = IGDisplayerPositionTypeCenter;
}

-(void)initSelfParams{
    _topH = 0;
    _contentH = 0;
    _buttonsH = 0;
    
    _innerButtonsList = nil;
    [self innerButtonsList];
    
    [self.overlayWindow addSubview:self];
    self.frame = self.overlayWindow.bounds;
    [self addSubview:self.backgroundView];
    [self addSubview:self.displayer];
    _displayer.transform = CGAffineTransformIdentity;
    _displayer.alpha = 1.0f;
    
    switch (_displayerPositionType) {
        case IGDisplayerPositionTypeCenter:{
            if (_displayer.layer.cornerRadius == 0.0f) { //设置圆角
                _displayer.layer.cornerRadius = 8.0f;
            }
        }
            break;
        case IGDisplayerPositionTypeBottom:{
            _displayer.layer.cornerRadius = 0.0f;
            _displayerWidth = [UIScreen mainScreen].bounds.size.width;
        }
            break;
            
        default:
            break;
    }
}

///类方法
+(void)showDisplayerWithPositionType:(IGDisplayerPositionType)positionType titleText:(NSString *)title contentText:(NSString *)content cancelButtonTitle:(NSString *)cancelButtonTitle buttonList:(NSArray *)buttons handleActionBlock:(displayerActionBlock)block {
    IGDisplayer *displayer = [[IGDisplayer alloc] init];
    displayer.displayerPositionType = positionType;
    displayer.titleLabel.text = title;
    displayer.textLabel.text = content;
    displayer.otherButtonList = buttons;
    displayer.displayerActionBlock = block;
    if (cancelButtonTitle == nil || cancelButtonTitle.length == 0) {
        displayer.isHiddenCancelButton = YES;
        displayer.isHiddenDisplayerByTouch = YES;
    }
    else{
        [displayer.cancelButton setTitle:cancelButtonTitle forState:0];
    }
    [displayer displayerShow];
}

-(void)displayerShow{
    [self initSelfParams];
    
    [self computeTop];
    [self computeContent];
    [self computeButtons];
    
    [self showAnimation];
}

//计算头部标题控件
-(void)computeTop{
    if (_titleLabel && _titleLabel.text != nil && _titleLabel.text.length > 0) {
        CGFloat titleW = _displayerWidth - _titleEdgeInsets.left - _titleEdgeInsets.right;
        CGFloat titleH = [_titleLabel sizeThatFits:CGSizeMake(titleW, MAXFLOAT)].height;
        _titleLabel.frame = CGRectMake(_titleEdgeInsets.left,
                                       _titleEdgeInsets.top,
                                       titleW,
                                       titleH);
        [_displayer addSubview:_titleLabel];
        _topH = titleH + _titleEdgeInsets.top + _titleEdgeInsets.bottom;
    }
}

//计算内容控件
-(void)computeContent{
    switch (_displayerContentType) {
        case IGDisplayerContentTypeDefault:{
            if (_textLabel && _textLabel.text != nil && _textLabel.text.length > 0) {
                CGFloat textW = _displayerWidth - _contentEdgeInsets.left - _contentEdgeInsets.right;
                CGFloat textH = [_textLabel sizeThatFits:CGSizeMake(textW, MAXFLOAT)].height;
                //设定一个内容控件最小高度
                textH = textH < 50 ? 50 : textH;
                _textLabel.frame = CGRectMake(_contentEdgeInsets.left,
                                              _contentEdgeInsets.top + _topH,
                                              textW,
                                              textH);
                [_displayer addSubview:_textLabel];
                _contentH = _contentEdgeInsets.top + textH + _contentEdgeInsets.bottom;
            }
        }
            break;
        case IGDisplayerContentTypeInputs:{
            
        }
            break;
        case IGDisplayerContentTypeCustom:{
            if (_customView) {
                _customView.frame = CGRectMake(_isCustomWidthEqualToDisplayer ? 0 : (_displayerWidth - _customViewSize.width) / 2,
                                               _contentEdgeInsets.top + _topH,
                                               _isCustomWidthEqualToDisplayer ? _displayerWidth : _customViewSize.width,
                                               _customViewSize.height);
                [_displayer addSubview:_customView];
                _contentH = _contentEdgeInsets.top + _customViewSize.height + _contentEdgeInsets.bottom;
            }
        }
            break;
            
        default:
            break;
    }
}

//计算按钮
-(void)computeButtons{
    _buttonsH = _buttonsInset;
    [_innerButtonsList enumerateObjectsUsingBlock:^(UIButton *obj, NSUInteger idx, BOOL * stop) {
        switch (_displayerPositionType) {
            //根据显示类型进行按钮排列
            case IGDisplayerPositionTypeCenter:{
                if (_innerButtonsList.count == 1) { //只有一个按钮
                    obj.frame = CGRectMake(0,
                                           _buttonsH,
                                           _displayerWidth,
                                           _buttonHeight);
                    _buttonsH = _buttonHeight + _buttonsInset;
                }
                else if (_innerButtonsList.count == 2) {
                    obj.frame = CGRectMake(idx == 0 ? 0 : _displayerWidth / 2 + 0.5f,
                                           _buttonsH,
                                           _displayerWidth / 2,
                                           _buttonHeight);
                    if (idx == 1) {
                        _buttonsH = _buttonHeight + _buttonsInset;
                    }
                }
                else{
                    obj.frame = CGRectMake(0,
                                           _buttonsH,
                                           _displayerWidth,
                                           _buttonHeight);
                    _buttonsH += _buttonHeight + _buttonsInset;
                }
            }
                break;
            case IGDisplayerPositionTypeBottom:{
                obj.frame = CGRectMake(0,
                                       _buttonsH,
                                       _displayerWidth,
                                       _buttonHeight);
                _buttonsH += _buttonHeight + _buttonsInset;
            }
                break;
                
            default:
                break;
        }
        if (idx == _innerButtonsList.count - 1) {
            _buttonsH -= _buttonsInset;
        }
        [self.buttonsView addSubview:obj];
    }];
    
    //设置ButtonsView的尺寸
    if (_innerButtonsList.count > 0) {
        _buttonsView.frame = CGRectMake(0,
                                        _topH + _contentH,
                                        _displayerWidth,
                                        _buttonsH);
        [_displayer addSubview:_buttonsView];
    }
    else{
        _buttonsH = 0;
    }
}

-(NSMutableArray *)innerButtonsList{
    if (!_innerButtonsList) {
        _innerButtonsList = [NSMutableArray array];
        
        if (_otherButtonList && _otherButtonList.count > 0) {
            [_otherButtonList enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL * stop) {
                if ([obj isKindOfClass:[NSString class]]) {
                    UIButton *button = [self customButton];
                    [button setTitle:obj forState:0];
                    [_innerButtonsList addObject:button];
                }
                else if ([obj isKindOfClass:[UIButton class]]){
                    [_innerButtonsList addObject:obj];
                }
            }];
        }
        
        [_innerButtonsList enumerateObjectsUsingBlock:^(UIButton *obj, NSUInteger idx, BOOL * stop) {
            [obj setTag:idx];
            [obj addTarget:self action:@selector(displayerButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        }];
        
        if (!_isHiddenCancelButton) {
            if (_otherButtonList.count == 1 && _displayerPositionType != IGDisplayerPositionTypeBottom) {
                [_innerButtonsList insertObject:self.cancelButton atIndex:0];
            }
            else{
                [_innerButtonsList addObject:self.cancelButton];
            }
        }
    }
    return _innerButtonsList;
}

-(void)displayerButtonAction:(UIButton *)sender{
    if (self.displayerActionBlock && sender.tag != 999) {
        self.displayerActionBlock(self,sender.tag);
    }
    if (_isHiddenDisplayerWhenSelected) {
        [self displayerHidden];
    }
}

-(void)showAnimation{
    CGFloat totalH = _topH + _contentH + _buttonsH;
    switch (_displayerPositionType) {
        case IGDisplayerPositionTypeCenter:{
            self.displayer.frame = CGRectMake(([UIScreen mainScreen].bounds.size.width - _displayerWidth) / 2,
                                              ([UIScreen mainScreen].bounds.size.height - totalH) / 2,
                                              _displayerWidth,
                                              totalH);
        }
            break;
        case IGDisplayerPositionTypeBottom:{
            self.displayer.frame = CGRectMake(0,
                                              [UIScreen mainScreen].bounds.size.height - totalH,
                                              _displayerWidth,
                                              totalH);
        }
            break;
            
        default:
            break;
    }
    
    [self.overlayWindow makeKeyAndVisible];
    switch (_displayerPositionType) {
        case IGDisplayerPositionTypeCenter:{
            switch (_displayerShowType) {
                case IGDisplayerShowTypeBounce:{
                    _displayer.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
                    _displayer.alpha = 0.0f;
                    [UIView animateWithDuration:0.1f animations:^{
                        _displayer.transform = CGAffineTransformMakeScale(1.1f, 1.1f);
                        _displayer.alpha = 1.0f;
                    } completion:^(BOOL finished) {
                        [UIView animateWithDuration:0.1f animations:^{
                            _displayer.transform = CGAffineTransformMakeScale(0.9f, 0.9f);
                        } completion:^(BOOL finished) {
                            [UIView animateWithDuration:0.2f animations:^{
                                _displayer.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
                            } completion:nil];
                        }];
                    }];
                }
                    break;
                case IGDisplayerShowTypeDrawer:{
                    _displayer.alpha = 0.0f;
                    _displayer.transform = CGAffineTransformMakeTranslation(0, 50);
                    [UIView animateWithDuration:0.2f animations:^{
                        _displayer.transform = CGAffineTransformMakeTranslation(0, 0);
                        _displayer.alpha = 1.0f;
                    } completion:nil];
                }
                    break;
                    
                default:
                    break;
            }
        }
            break;
        case IGDisplayerPositionTypeBottom:{
            _displayer.transform = CGAffineTransformMakeTranslation(0, _displayer.frame.size.height);
            [UIView animateWithDuration:0.2f animations:^{
                _displayer.transform = CGAffineTransformMakeTranslation(0, 0);
            } completion:nil];
        }
        default:
            break;
    }
}

-(void)displayerHidden{
    [UIView animateWithDuration:0.15f
                     animations:^{
                         switch (_displayerPositionType) {
                             case IGDisplayerPositionTypeCenter:{
                                 _displayer.transform = CGAffineTransformMakeScale(1.2f, 1.2f);
                                 _displayer.alpha = 0.0f;
                             }
                                 break;
                             case IGDisplayerPositionTypeBottom:{
                                 _displayer.transform = CGAffineTransformMakeTranslation(0, _displayer.frame.size.height);
                             }
                                 break;
                                 
                             default:
                                 break;
                         }
                         _backgroundView.alpha = 0.0f;
                     } completion:^(BOOL finished) {
                         _overlayWindow = nil;
                         [_displayer removeFromSuperview]; _displayer = nil;
                         [_backgroundView removeFromSuperview]; _backgroundView = nil;
                         
                         [[UIApplication sharedApplication].windows enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(UIWindow *window, NSUInteger idx, BOOL *stop) {
                             if ([window isKindOfClass:[UIWindow class]] && window.windowLevel == UIWindowLevelNormal && ![[window class] isEqual:[IGDisplayer class]]) {
                                 [window makeKeyWindow];
                                 *stop = YES;
                             }
                         }];
                     }];
}

-(void)singleTap{
    if (_isHiddenDisplayerByTouch) {
        [self displayerHidden];
    }
}

-(UIWindow *)overlayWindow{
    if (!_overlayWindow) {
        _overlayWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _overlayWindow.backgroundColor = [UIColor clearColor];
        _overlayWindow.windowLevel = UIWindowLevelAlert;
        _overlayWindow.userInteractionEnabled = YES;
    }
    return _overlayWindow;
}

-(UIView *)backgroundView{
    if (!_backgroundView) {
        _backgroundView = [[UIView alloc] initWithFrame:self.bounds];
        _backgroundView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3f];
        _backgroundView.userInteractionEnabled = YES;
        _backgroundView.alpha = 1.0f;
        
        UITapGestureRecognizer *singleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap)];
        [_backgroundView addGestureRecognizer:singleTapGesture];
    }
    return _backgroundView;
}

-(UIView *)displayer{
    if (!_displayer) {
        _displayer = [[UIView alloc] init];
        _displayer.backgroundColor = [UIColor whiteColor];
        _displayer.clipsToBounds = YES;
    }
    return _displayer;
}

-(UIView *)buttonsView{
    if (!_buttonsView) {
        _buttonsView = [[UIView alloc] init];
        _buttonsView.backgroundColor = [UIColor colorWithWhite:0.8f alpha:1.0f];
        _buttonsView.userInteractionEnabled = YES;
    }
    return _buttonsView;
}

-(UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:15];
        _titleLabel.textColor = [[UIColor blackColor] colorWithAlphaComponent:0.9f];
        _titleLabel.numberOfLines = 0;
        _titleLabel.lineBreakMode = NSLineBreakByCharWrapping;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

-(UILabel *)textLabel{
    if (!_textLabel) {
        _textLabel = [[UILabel alloc] init];
        _textLabel.font = [UIFont systemFontOfSize:15];
        _textLabel.textColor = [[UIColor blackColor] colorWithAlphaComponent:0.7f];
        _textLabel.numberOfLines = 0;
        _textLabel.lineBreakMode = NSLineBreakByCharWrapping;
        _textLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _textLabel;
}

-(UIButton *)cancelButton{
    if (!_cancelButton) {
        _cancelButton = [[UIButton alloc] init];
        [_cancelButton setTitle:@"取消" forState:0];
        [_cancelButton setTitleColor:[UIColor colorWithRed:27.0 / 255.0 green:166.0 / 255.0 blue:201.0 / 255.0 alpha:1.0f] forState:0];
        _cancelButton.tag = 999;
        _cancelButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [_cancelButton setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forState:0];
        [_cancelButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithWhite:0.95f alpha:1.0f]]forState:1<<0];
        [_cancelButton addTarget:self action:@selector(displayerButtonAction:) forControlEvents:1<<6];
    }
    return _cancelButton;
}

-(UIButton *)customButton{
    UIButton *button = [[UIButton alloc] init];
    [button setTitleColor:_otherButtonTitleColor forState:0];
    button.titleLabel.font = [UIFont systemFontOfSize:15];
    [button setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forState:0];
    [button setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithWhite:0.95f alpha:1.0f]]forState:1<<0];
    return button;
}

@end
