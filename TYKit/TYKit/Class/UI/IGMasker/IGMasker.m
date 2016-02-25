//
//  IGMasker.m
//  IGCustom
//
//  Created by iGalactus on 16/1/21.
//  Copyright © 2016年 一斌. All rights reserved.
//

#import "IGMasker.h"

static CGFloat MASKER_SIZE = 100; //主控件的尺寸

static int HEADER_ICON_TOP = 15; //Icon距离头部的距离
static int ICON_SIZE = 35;  //图片的大小
static int MASKER_LABEL_DISTANCE = 15; //文字控件与Masker的距离

@interface IGMasker()

@property (nonatomic,strong) UIActivityIndicatorView *indicatorView;
@property (nonatomic,strong) CAShapeLayer *iconLayer;
@property (nonatomic,strong) NSTimer *overtimeTimer;

@property (nonatomic) CGFloat topH , contentH;

@end

@implementation IGMasker

-(instancetype)init{
    if (self != [super init]) {
        return nil;
    }
    
    [self initParams];
    [self initUI];
    
    return self;
}

///类方法
+(void)maskerShowWithStatus:(NSString *)status{
    [self maskerShowWithType:IGMaskerTypeNone status:status delayTime:2.0f showInView:nil];
}

+(void)maskerShowWithType:(IGMaskerType)type showInView:(UIView *)view{
    [self maskerShowWithType:type status:nil showInView:view];
}

+(void)maskerShowWithType:(IGMaskerType)type status:(NSString *)status showInView:(UIView *)view{
    [self maskerShowWithType:type status:status delayTime:MAXFLOAT showInView:view];
}

+(void)maskerShowWithType:(IGMaskerType)type status:(NSString *)status delayTime:(NSTimeInterval)delayTime showInView:(UIView *)view{
    [self maskerShowWithType:type status:status delayTime:delayTime showInView:view maskerCompleteBlock:nil];
}

+(void)maskerShowDisallowInteractionWithStatus:(NSString *)status showInView:(UIView *)view{
    [self maskerShowWithType:IGMaskerTypeWaiting status:status delayTime:MAXFLOAT showInView:view allowTouch:NO maskerCompleteBlock:nil];
}

+(void)maskerShowWithType:(IGMaskerType)type status:(NSString *)status delayTime:(NSTimeInterval)delayTime showInView:(UIView *)view maskerCompleteBlock:(maskerDidCompleteBlock)block{
    [self maskerShowWithType:type status:status delayTime:delayTime showInView:view allowTouch:YES maskerCompleteBlock:block];
}

+(void)maskerShowWithType:(IGMaskerType)type status:(NSString *)status delayTime:(NSTimeInterval)delayTime showInView:(UIView *)view allowTouch:(BOOL)allowTouch maskerCompleteBlock:(maskerDidCompleteBlock)block{
    IGMasker *masker = [self selfClassInSuperView:view];
    masker.contentLabel.text = status;
    masker.maskerType = type;
    masker.maskerShowType = IGMaskerAnimationTypeBounce;
    masker.autoHiddenTimeInterval = delayTime;
    masker.isUserDisallowedTouch = !allowTouch;
    masker.block = block;
    if (view) {
        [view addSubview:masker];
    }
    [masker maskerShow];
}

+(void)maskerHiddenInView:(UIView *)view{
    IGMasker *masker = [self selfClassInSuperView:view];
    [masker maskerHidden];
}

+(IGMasker *)selfClassInSuperView:(UIView *)view{
    __block IGMasker *masker;
    if (view == nil) {
        view = [UIApplication sharedApplication].keyWindow;
    }
    [view.subviews enumerateObjectsUsingBlock:^(UIView * class, NSUInteger idx, BOOL *stop) {
        if ([class isKindOfClass:[IGMasker class]]) {
            masker = (IGMasker *)class;
            *stop = YES;
        }
    }];
    if (masker == nil) { //没找到
        masker = [[IGMasker alloc] init];
    }
    return masker;
}

-(void)initParams{
    _maskerType = 0;
    _maskerShowType = 0;
    _maskerHiddenType = 0;
    _autoHiddenTimeInterval = 0;
    _iconTopPadding = HEADER_ICON_TOP;
    _isUserDisallowedTouch = NO;
    _maskerBackgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4f];
    _maskerCustomizedSize = CGSizeMake(MASKER_SIZE, MASKER_SIZE);
    _contentLabelPadding = MASKER_LABEL_DISTANCE;
    _maskerIconSize = CGSizeMake(ICON_SIZE, ICON_SIZE);
}

-(void)initSelfParams{
    _topH = 0;
    _contentH = 0;
    _masker.transform = CGAffineTransformIdentity;
    if (_indicatorView && _indicatorView.isAnimating) {
        [_indicatorView stopAnimating];
    }
    if (_iconLayer) {
        [_iconLayer removeFromSuperlayer];
    }
    if (_maskerHeader) {
        [_maskerHeader removeFromSuperview];
    }
    if (_overtimeTimer) {
        [_overtimeTimer invalidate]; _overtimeTimer = nil;
    }
}

-(void)initUI{
    if (!_masker) {
        _masker = [[UIToolbar alloc] init];
        _masker.clipsToBounds = YES;
        _masker.layer.cornerRadius = 8.f;
        _masker.barTintColor = [UIColor blackColor];
        [self addSubview:_masker];
    }
}

//展示视图
-(void)maskerShow{
    if (!self.superview) {
        NSLog(@"IGMasker:还未添加进一个视图当中! 默认添加至当前Window!");
        [[UIApplication sharedApplication].keyWindow addSubview:self];
        self.frame = [UIScreen mainScreen].bounds;
    }
    else{
        self.frame = self.superview.bounds;
    }
    [self initSelfParams];
    
    if (_maskerType != 0) { //有状态
        _topH += _maskerIconSize.height + _iconTopPadding;
        if (_maskerType == 4) { //是等待框
            [_masker addSubview:self.indicatorView];
            _indicatorView.frame = [self headerIconFrame];
            [_indicatorView startAnimating];
        }
        else if (_maskerType == 5){ //是自定义控件
            [_masker addSubview:self.maskerHeader];
            _maskerHeader.frame = [self headerIconFrame];
        }
        else{
            [_masker.layer addSublayer:self.iconLayer];
            _iconLayer.frame = [self headerIconFrame];
            switch (_maskerType) {
                case IGMaskerTypeNone:{
                    
                }
                    break;
                case IGMaskerTypeSucceed:{
                    _iconLayer.path = [self bezierPathForCheckSymbolWithLayerRect:_iconLayer.frame andLineW:5.f].CGPath;
                }
                    break;
                case IGMaskerTypeWarning:{
                    _iconLayer.path = [self bezierPathForWarnSymbolWithLayerRect:_iconLayer.frame andLineW:4.f].CGPath;
                }
                    break;
                case IGMaskerTypeError:{
                    _iconLayer.path = [self bezierPathForWrongSymbolWithLayerRect:_iconLayer.frame andLineW:3.f].CGPath;
                }
                    break;
                    
                default:
                    break;
            }
        }
    }
    if (_contentLabel.text != nil && _contentLabel.text.length > 0) { //有文字
        [_masker addSubview:self.contentLabel];
        _contentLabel.frame = [self textLabelFrame];
    }
    
    [self resizeSelfFrame];
    [self showAnimation];
    [self schduleTimer];
}

-(void)showAnimation{
    switch (_maskerShowType) {
        case IGMaskerAnimationTypeNone:{
            
        }
            break;
        case IGMaskerAnimationTypeBounce:{
            _masker.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
            _masker.alpha = 0.0f;
            [UIView animateWithDuration:0.1f animations:^{
                _masker.transform = CGAffineTransformMakeScale(1.1f, 1.1f);
                _masker.alpha = 1.0f;
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:0.1f animations:^{
                    _masker.transform = CGAffineTransformMakeScale(0.85f, 0.85f);
                } completion:^(BOOL finished) {
                    [UIView animateWithDuration:0.2f animations:^{
                        _masker.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
                    } completion:nil];
                }];
            }];
        }
            break;
        case IGMaskerAnimationTypeDrawer:{
            _masker.alpha = 0.0f;
            _masker.transform = CGAffineTransformMakeTranslation(0, 50);
            [UIView animateWithDuration:0.2f animations:^{
                _masker.transform = CGAffineTransformMakeTranslation(0, 0);
                _masker.alpha = 1.0f;
            } completion:nil];
        }
            break;
            
        default:
            break;
    }
}

//隐藏视图
-(void)maskerHidden{
    switch (_maskerShowType) {
        case IGMaskerAnimationTypeNone:{
            
        }
            break;
        case IGMaskerAnimationTypeBounce:{
            _masker.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
            _masker.alpha = 1.0f;
            [UIView animateWithDuration:0.2f animations:^{
                _masker.transform = CGAffineTransformMakeScale(0.1f, 0.1f);
                _masker.alpha = 0.0f;
            } completion:^(BOOL finished) {
                _masker.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
                [self removeFromSuperview];
                [self maskerFinishAction];
            }];
        }
            break;
        case IGMaskerAnimationTypeDrawer:{
            _masker.alpha = 1.0f;
            _masker.transform = CGAffineTransformMakeTranslation(0, 0);
            [UIView animateWithDuration:0.2f animations:^{
                _masker.transform = CGAffineTransformMakeTranslation(0, -50);
                _masker.alpha = 0.0f;
            } completion:^(BOOL finished) {
                _masker.transform = CGAffineTransformMakeTranslation(0, 0);
                [self removeFromSuperview];
                [self maskerFinishAction];
            }];
        }
            break;
            
        default:
            break;
    }
}

-(void)maskerFinishAction{
    if (_indicatorView) {
        [_indicatorView stopAnimating];
    }
    
    if (self.block) {
        self.block();
    }
}

-(void)schduleTimer{
    if (_autoHiddenTimeInterval == 0.0f) {
        return;
    }
    _overtimeTimer = [NSTimer scheduledTimerWithTimeInterval:_autoHiddenTimeInterval target:self selector:@selector(overtimeTimerAction) userInfo:nil repeats:NO];
}

-(void)overtimeTimerAction{
    [_overtimeTimer invalidate]; _overtimeTimer = nil;
    [self maskerHidden];
}

//重设自己的尺寸
-(void)resizeSelfFrame{
    _masker.frame = [self maskerFrame];
    if (_isUserDisallowedTouch) {
        self.backgroundColor = _maskerBackgroundColor;
    }
    else{
        self.backgroundColor = [UIColor clearColor];
        self.frame = _masker.frame;
        _masker.frame = self.bounds;
    }
}

//头部尺寸
-(CGRect)headerIconFrame{
    if (_contentLabel.text != nil && _contentLabel.text.length > 0) { //有文字
        return CGRectMake((_maskerCustomizedSize.width - _maskerIconSize.width) / 2,
                          _iconTopPadding,
                          _maskerIconSize.width,
                          _maskerIconSize.height);
    }
    else{ //没有文字,则默认占满整个masker
        _topH = _maskerCustomizedSize.height - _contentLabelPadding;
        return CGRectMake((_maskerCustomizedSize.width - _maskerIconSize.width) / 2,
                          (_maskerCustomizedSize.height - _maskerIconSize.height) / 2,
                          _maskerIconSize.width,
                          _maskerIconSize.height);
    }
}

//文字尺寸
-(CGRect)textLabelFrame{
    _contentH = [_contentLabel sizeThatFits:CGSizeMake(_maskerCustomizedSize.width - 2 * _contentLabelPadding, MAXFLOAT)].height;
    if (_contentH + 2 * _contentLabelPadding + _topH < _maskerCustomizedSize.height) { //如果文字高度加上边距加上头部控件高度 小于Masker高度
        _contentH = _maskerCustomizedSize.height - _topH - _contentLabelPadding;
    }
    else{
        _contentH += _contentLabelPadding;
    }
    
    return CGRectMake(_contentLabelPadding,
                      _topH + _contentLabelPadding,
                      _maskerCustomizedSize.width - 2 * _contentLabelPadding,
                      _contentH);
}

//主控件的尺寸
-(CGRect)maskerFrame{
    CGFloat maskerH = _topH + _contentH + _contentLabelPadding; //控件的高度
    return CGRectMake((self.bounds.size.width - _maskerCustomizedSize.width) / 2,
                      (self.bounds.size.height - maskerH) / 2,
                      _maskerCustomizedSize.width,
                      maskerH);
}

//头部Icon

//正确状态
-(UIBezierPath *)bezierPathForCheckSymbolWithLayerRect:(CGRect)layerRect andLineW:(CGFloat)lineW{
    CGSize symbolSize = CGSizeMake(22, 28);
    
    CGFloat oriX = (layerRect.size.width - symbolSize.width) / 2;
    CGFloat oriY = (layerRect.size.height - symbolSize.height) / 2;
    
    UIBezierPath *bezierPath = [UIBezierPath bezierPath];
    
    [bezierPath moveToPoint:CGPointMake(oriX, oriY + 16)];
    [bezierPath addLineToPoint:CGPointMake(oriX + 7, oriY + 23)];
    [bezierPath addLineToPoint:CGPointMake(oriX + 21, oriY + 9)];
    [bezierPath addLineToPoint:CGPointMake(oriX + 21 - lineW / 2, oriY + 9 - lineW / 2)];
    [bezierPath addLineToPoint:CGPointMake(oriX + 7, oriY + 23 - lineW)];
    [bezierPath addLineToPoint:CGPointMake(oriX + lineW / 2, oriY + 16 - lineW / 2)];
    [bezierPath closePath];
    
    return bezierPath;
}

//错误状态
-(UIBezierPath *)bezierPathForWrongSymbolWithLayerRect:(CGRect)layerRect andLineW:(CGFloat)lineW{
    CGSize symbolSize = CGSizeMake(16, 16);
    
    CGFloat oriX = (layerRect.size.width - symbolSize.width) / 2;
    CGFloat oriY = (layerRect.size.height - symbolSize.height) / 2;
    
    CGFloat marginX = lineW / sqrt(2.0);
    CGFloat marginY = marginX;
    
    UIBezierPath *bezierPath = [UIBezierPath bezierPath];
    
    [bezierPath moveToPoint:CGPointMake(oriX, oriY + marginY)];
    [bezierPath addLineToPoint:CGPointMake(oriX + marginX, oriY)];
    [bezierPath addLineToPoint:CGPointMake(oriX + symbolSize.width / 2, oriY + symbolSize.height / 2 - marginY)];
    [bezierPath addLineToPoint:CGPointMake(oriX + symbolSize.width - marginX, oriY)];
    [bezierPath addLineToPoint:CGPointMake(oriX + symbolSize.width, oriY + marginY)];
    [bezierPath addLineToPoint:CGPointMake(oriX + symbolSize.width / 2 + marginX, oriY + symbolSize.height / 2)];
    [bezierPath addLineToPoint:CGPointMake(oriX + symbolSize.width, oriY + symbolSize.height - marginY)];
    [bezierPath addLineToPoint:CGPointMake(oriX + symbolSize.width - marginX, oriY + symbolSize.height)];
    [bezierPath addLineToPoint:CGPointMake(oriX + symbolSize.width / 2, oriY + symbolSize.height / 2 + marginY)];
    [bezierPath addLineToPoint:CGPointMake(oriX + marginX, oriY + symbolSize.height)];
    [bezierPath addLineToPoint:CGPointMake(oriX, oriY + symbolSize.height - marginY)];
    [bezierPath addLineToPoint:CGPointMake(oriX + symbolSize.width / 2 - marginX, oriY + symbolSize.height / 2)];
    [bezierPath closePath];
    
    return bezierPath;
}

//警示状态
-(UIBezierPath *)bezierPathForWarnSymbolWithLayerRect:(CGRect)layerRect andLineW:(CGFloat)lineW{
    CGSize symbolSize = CGSizeMake(25, 30);
    
    CGFloat oriX = (layerRect.size.width - symbolSize.width) / 2;
    CGFloat oriY = (layerRect.size.height - symbolSize.height) / 2;
    
    UIBezierPath *bezierPath = [UIBezierPath bezierPath];
    
    [bezierPath moveToPoint:CGPointMake(oriX + symbolSize.width / 2, oriY)];
    [bezierPath addArcWithCenter:CGPointMake(oriX + symbolSize.width / 2, oriY + 6) radius:lineW - 1.5f startAngle:0 endAngle:M_PI * 2 clockwise:YES];
    
    [bezierPath moveToPoint:CGPointMake(oriX + symbolSize.width / 2 - lineW / 2, oriY + 13)];
    [bezierPath addLineToPoint:CGPointMake(oriX + symbolSize.width / 2 + lineW / 2, oriY + 13)];
    [bezierPath addLineToPoint:CGPointMake(oriX + symbolSize.width / 2 + lineW / 2, oriY + 13 + 13)];
    [bezierPath addLineToPoint:CGPointMake(oriX + symbolSize.width / 2 - lineW / 2, oriY + 13 + 13)];
    [bezierPath closePath];
    
    return bezierPath;
}

-(void)setIconTintColor:(UIColor *)iconTintColor{
    _iconTintColor = iconTintColor;
    self.iconLayer.fillColor = iconTintColor.CGColor;
    self.iconLayer.borderColor = iconTintColor.CGColor;
}

//懒加载
-(UIActivityIndicatorView *)indicatorView{
    if (!_indicatorView) {
        _indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    }
    return _indicatorView;
}

-(CAShapeLayer *)iconLayer{
    if (!_iconLayer) {
        _iconLayer = [CAShapeLayer layer];
        _iconLayer.borderWidth = 3.0f;
        _iconLayer.fillColor = [UIColor whiteColor].CGColor;
        _iconLayer.borderColor = [UIColor whiteColor].CGColor;
        _iconLayer.cornerRadius = 17;
        _iconLayer.strokeColor = [UIColor clearColor].CGColor;
        [_iconLayer setStrokeEnd:0.0];
    }
    return _iconLayer;
}

-(UILabel *)contentLabel{
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.textColor = [UIColor whiteColor];
        _contentLabel.font = [UIFont systemFontOfSize:15];
        _contentLabel.textAlignment = NSTextAlignmentCenter;
        _contentLabel.lineBreakMode = NSLineBreakByCharWrapping;
        _contentLabel.numberOfLines = 0;
    }
    return _contentLabel;
}

-(void)willMoveToSuperview:(UIView *)newSuperview{
    [super willMoveToSuperview:newSuperview];
    if (_overtimeTimer) {
        [_overtimeTimer invalidate]; _overtimeTimer = nil;
        [self removeFromSuperview];
    }
}

@end
