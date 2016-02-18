//
//  IGFlushTop.m
//  IGCustom
//
//  Created by iGalactus on 16/1/23.
//  Copyright © 2016年 一斌. All rights reserved.
//

#import "IGFlushTop.h"

#define flushTop_Height 65

@interface IGFlushTop()

@property (nonatomic,strong) UIScrollView *scrollView;
@property (nonatomic,copy) void (^ flushReponseBlock)();

@property (nonatomic,strong) UIActivityIndicatorView *activityIndicator;
@property (nonatomic,strong) UILabel *pullStatusLabel;
@property (nonatomic,strong) UIImageView *directionView;

@end

@implementation IGFlushTop

-(instancetype)initWithScrollView:(UIScrollView *)scrollView response:(void (^)())block{
    self = [super initWithFrame:CGRectMake(0, -(flushTop_Height + scrollView.contentInset.top), scrollView.frame.size.width, flushTop_Height)];
    if (self && scrollView) {
        _topFlushHeight = flushTop_Height;
        _scrollView = scrollView;
        _flushReponseBlock = block;
        
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [scrollView addSubview:self];
        [_scrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
        
        [self addSubview:self.activityIndicator];
        [self addSubview:self.pullStatusLabel];
        [self addSubview:self.directionView];
    }
    return self;
}

-(void)willMoveToSuperview:(UIView *)newSuperview{
    [super willMoveToSuperview:newSuperview];
    if (!newSuperview) {
        [self.scrollView removeObserver:self forKeyPath:@"contentOffset"];
        self.scrollView = nil;
    }
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:@"contentOffset"]) {
        CGFloat offset = [[change objectForKey:@"new"] CGPointValue].y + self.scrollView.contentInset.top;
        if (_flushStatus != IGFlushStatusOperation) {
            if (offset < -flushTop_Height) {
                if (_scrollView.isDragging) {
                    self.flushStatus = IGFlushStatusWillOperation;
                }
                else{
                    self.flushStatus = IGFlushStatusOperation;
                }
            }
            else{
                self.flushStatus = IGFlushStatusPulling;
            }
        }
    }
}

-(void)setFlushStatus:(IGFlushStatus)flushStatus{
    if (_flushStatus != flushStatus) {
        _flushStatus = flushStatus;
        switch (flushStatus) {
            case IGFlushStatusOriginal:{
                _pullStatusLabel.text = @"下拉刷新";
                [_activityIndicator stopAnimating];
                _activityIndicator.hidden = YES;
                _directionView.hidden = NO;
                [UIView animateWithDuration:0.2f animations:^{
                    _directionView.transform = CGAffineTransformMakeRotation(0);
                }];
                [self.scrollView setContentInset:UIEdgeInsetsMake(self.scrollView.contentInset.top - flushTop_Height,
                                                                  self.scrollView.contentInset.left,
                                                                  self.scrollView.contentInset.bottom,
                                                                  self.scrollView.contentInset.right)];
            }
                break;
            case IGFlushStatusPulling:{
                _pullStatusLabel.text = @"下拉刷新";
                [UIView animateWithDuration:0.2f animations:^{
                    _directionView.transform = CGAffineTransformMakeRotation(0);
                }];
            }
                break;
            case IGFlushStatusWillOperation:{
                _pullStatusLabel.text = @"松开刷新";
                [UIView animateWithDuration:0.2f animations:^{
                    _directionView.transform = CGAffineTransformMakeRotation(M_PI);
                }];
            }
                break;
            case IGFlushStatusOperation:{
                _pullStatusLabel.text = @"正在刷新";
                [_activityIndicator startAnimating];
                _activityIndicator.hidden = NO;
                _directionView.hidden = YES;
                [UIView animateWithDuration:0.2f animations:^{
                    [self.scrollView setContentInset:UIEdgeInsetsMake(self.scrollView.contentInset.top + flushTop_Height,
                                                                      self.scrollView.contentInset.left,
                                                                      self.scrollView.contentInset.bottom,
                                                                      self.scrollView.contentInset.right)];
                } completion:^(BOOL finished) {
                    if (self.flushReponseBlock) {
                        self.flushReponseBlock();
                    }
                }];
            }
                break;
                
            default:
                break;
        }
    }
}

-(UIActivityIndicatorView *)activityIndicator{
    if (!_activityIndicator) {
        _activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        _activityIndicator.center = CGPointMake(self.frame.size.width / 2 - 30, self.frame.size.height / 2);
    }
    return _activityIndicator;
}

-(UILabel *)pullStatusLabel{
    if (!_pullStatusLabel) {
        _pullStatusLabel = [[UILabel alloc] init];
        _pullStatusLabel.text = @"下拉刷新";
        _pullStatusLabel.frame = CGRectMake(self.frame.size.width / 2 - 10, 0, self.frame.size.width / 2, _topFlushHeight);
        _pullStatusLabel.font = [UIFont systemFontOfSize:13];
        _pullStatusLabel.textColor = [UIColor colorWithWhite:0.4 alpha:1.0f];
    }
    return _pullStatusLabel;
}

-(UIImageView *)directionView{
    if (!_directionView) {
        _directionView = [[UIImageView alloc] init];
        _directionView.image = [UIImage imageNamed:@"arrow_top"];
        _directionView.frame = _activityIndicator.frame;
    }
    return _directionView;
}

- (void)dealloc{
    [self.scrollView removeObserver:self forKeyPath:@"contentOffset"];
    self.scrollView = nil;
}

@end
