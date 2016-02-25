//
//  IGFlushBottom.m
//  IGCustom
//
//  Created by iGalactus on 16/1/23.
//  Copyright © 2016年 一斌. All rights reserved.
//

#import "IGFlushBottom.h"

#define flushBottom_Height 40

@interface IGFlushBottom()

@property (nonatomic,strong) UIScrollView *scrollView;
@property (nonatomic,copy) void (^ flushReponseBlock)();

@property (nonatomic,strong) UILabel *statusLabel;
@property (nonatomic) BOOL isSetEdgeInset;

@end

@implementation IGFlushBottom

-(instancetype)initWithScrollView:(UIScrollView *)scrollView response:(void (^)())block{
    self = [super initWithFrame:CGRectMake(0, MAX(scrollView.frame.size.height,scrollView.contentSize.height+scrollView.contentInset.bottom), scrollView.frame.size.width, flushBottom_Height)];
    if (self && scrollView) {
        self.hidden = YES;
        _bottomFlushHeight = flushBottom_Height;
        _isSetEdgeInset = NO;
        
        _scrollView = scrollView;
        _flushReponseBlock = block;
        
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [scrollView addSubview:self];
        [_scrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
        [_scrollView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
        
        [self addSubview:self.statusLabel];
    }
    return self;
}

-(void)willMoveToSuperview:(UIView *)newSuperview{
    [super willMoveToSuperview:newSuperview];
    if (!newSuperview) {
        [self.scrollView removeObserver:self forKeyPath:@"contentOffset"];
        [self.scrollView removeObserver:self forKeyPath:@"contentSize"];
        self.scrollView = nil;
    }
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:@"contentSize"]) {
        self.hidden = _scrollView.contentSize.height + _scrollView.contentInset.bottom < _scrollView.frame.size.height;
        if (!self.isHidden) {
            if (!_isSetEdgeInset || _flushStatus == IGFlushStatusHiddenForever) {
                CGFloat frameY = MAX(_scrollView.frame.size.height,_scrollView.contentSize.height + _scrollView.contentInset.bottom) - (_flushStatus == IGFlushStatusHiddenForever ? _bottomFlushHeight : 0);
                self.frame = CGRectMake(0,
                                        frameY,
                                        _scrollView.frame.size.width,
                                        flushBottom_Height);
            }
        }
    }
    if ([keyPath isEqualToString:@"contentOffset"]) {
        CGFloat offset = [[change objectForKey:@"new"] CGPointValue].y;
        CGFloat changeH = _scrollView.contentSize.height + _scrollView.contentInset.bottom - _scrollView.frame.size.height;
        CGFloat gapY = offset - changeH;
        if (!self.isHidden) {
            if (_flushStatus != IGFlushStatusHiddenForever) {
                if (_flushStatus != IGFlushStatusOperation) {
                    if (gapY > 0 && gapY < _bottomFlushHeight) {
                        self.flushStatus = IGFlushStatusOriginal;
                    }
                    else if (gapY > _bottomFlushHeight){
                        if (_scrollView.isDragging) {
                            self.flushStatus = IGFlushStatusWillOperation;
                        }
                        else{
                            self.flushStatus = IGFlushStatusOperation;
                        }
                    }
                }
            }
        }
    }
}

-(void)setFlushStatus:(IGFlushStatus)flushStatus{
    if (_flushStatus != flushStatus) {
        _flushStatus = flushStatus;
        switch (flushStatus) {
            case IGFlushStatusOriginal:{
                _statusLabel.text = @"上拉加载";
                _isSetEdgeInset = NO;
                [self.scrollView setContentInset:UIEdgeInsetsMake(self.scrollView.contentInset.top,
                                                                  self.scrollView.contentInset.left,
                                                                  self.scrollView.contentInset.bottom - flushBottom_Height,
                                                                  self.scrollView.contentInset.right)];
            }
                break;
            case IGFlushStatusPulling:{
                _statusLabel.text = @"上拉加载";
            }
                break;
            case IGFlushStatusWillOperation:{
                _statusLabel.text = @"松开加载";
            }
                break;
            case IGFlushStatusOperation:{
                _statusLabel.text = @"正在加载";
                _isSetEdgeInset = YES;
                [UIView animateWithDuration:0.2f animations:^{
                    [self.scrollView setContentInset:UIEdgeInsetsMake(self.scrollView.contentInset.top,
                                                                      self.scrollView.contentInset.left,
                                                                      self.scrollView.contentInset.bottom + flushBottom_Height,
                                                                      self.scrollView.contentInset.right)];
                } completion:^(BOOL finished) {
                    if (self.flushReponseBlock) {
                        self.flushReponseBlock();
                    }
                }];
            }
                break;
            case IGFlushStatusHiddenForever:{
                _statusLabel.text = @"暂无更多内容";
                self.frame = CGRectMake(0,
                                        MAX(_scrollView.frame.size.height,_scrollView.contentSize.height + _scrollView.contentInset.bottom) - flushBottom_Height,
                                        _scrollView.frame.size.width,
                                        flushBottom_Height);
            }
                break;
                
            default:
                break;
        }
    }
}

-(UILabel *)statusLabel{
    if (!_statusLabel) {
        _statusLabel = [[UILabel alloc] init];
        _statusLabel.text = @"上拉刷新";
        _statusLabel.frame = CGRectMake(0, 0, self.frame.size.width, flushBottom_Height);
        _statusLabel.font = [UIFont systemFontOfSize:13];
        _statusLabel.textAlignment = NSTextAlignmentCenter;
        _statusLabel.textColor = [UIColor colorWithWhite:0.4 alpha:1.0f];
    }
    return _statusLabel;
}

- (void)dealloc{
    [self.scrollView removeObserver:self forKeyPath:@"contentOffset"];
    [self.scrollView removeObserver:self forKeyPath:@"contentSize"];
    self.scrollView = nil;
}


@end
