//
//  IGPhotoView.m
//  xiangdemei
//
//  Created by iGalactus on 15/12/29.
//  Copyright © 2015年 一斌. All rights reserved.
//

#import "IGPhotoViewCell.h"

#define iG_ScreenW [UIScreen mainScreen].bounds.size.width
#define iG_ScreenH [UIScreen mainScreen].bounds.size.height

#define shortL(a,b) (a - b) / 2
#define shortLScreenW(a) (iG_ScreenW - a) / 2
#define shortLScreenH(a) (iG_ScreenH - a) / 2

#define clipDouble(a,b) a - 2 * b
#define clipDoubleWithScreenW(a) (iG_ScreenW - 2 * a)
#define clipDoubleWithScreenH(a) (iG_ScreenH - 2 * a)

#define photoSize 150

@interface IGPhotoViewCell()<UIScrollViewDelegate>

@property (nonatomic,strong) UIImageView *imageView;
@property (nonatomic,strong) UIScrollView *scrollView;

@property (nonatomic) CGFloat zoomScale;

@end

@implementation IGPhotoViewCell

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
    
        _scrollView = [[UIScrollView alloc] initWithFrame:self.contentView.bounds];
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.contentSize = self.contentView.bounds.size;
        _scrollView.delegate = self;
        _scrollView.bouncesZoom = YES;
        [self.contentView addSubview:_scrollView];
        self.zoomScale = 1.0f;
        
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(shortLScreenW(photoSize),
                                                                   shortLScreenH(photoSize),
                                                                   photoSize,
                                                                   photoSize)];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.scrollView addSubview:_imageView];
        
        UITapGestureRecognizer *singleGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapGestureAction)];
        singleGesture.numberOfTapsRequired = 1;
        [_scrollView addGestureRecognizer:singleGesture];
        
        UITapGestureRecognizer *doubleGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTapGestureAction:)];
        doubleGesture.numberOfTapsRequired = 2;
        [_scrollView addGestureRecognizer:doubleGesture];
    }
    return self;
}

-(void)setMaxScale:(CGFloat)maxScale
{
    _maxScale = maxScale;
    _scrollView.maximumZoomScale = maxScale;
}

-(void)setMinScale:(CGFloat)minScale
{
    _minScale = minScale;
    _scrollView.minimumZoomScale = minScale;
}

-(void)singleTapGestureAction
{
    if (self.singleTapBlock) {
        self.singleTapBlock();
    }
}

-(void)doubleTapGestureAction:(UITapGestureRecognizer *)gesture
{
    if (self.zoomScale == self.maxScale) {
        [self resizeScale];
    }
    else{
        CGPoint touchPoint = [gesture locationInView:self.scrollView];
        CGFloat scale = self.maxScale / self.zoomScale;
        CGRect rectTozoom = CGRectMake(touchPoint.x * scale, touchPoint.y * scale, 1, 1);
        [self.scrollView zoomToRect:rectTozoom animated:YES];
    }
}

-(void)initWithImage:(UIImage *)image
{
    [self resizeScale];
    
    self.saveImage = image;
    _imageView.image = image;
    CGSize size = [self resizedImage:image];
    _imageView.frame = CGRectMake(shortLScreenW(size.width),
                                  shortLScreenH(size.height),
                                  size.width,
                                  size.height);
}

-(void)initWithPhotoURL:(NSString *)photoURL placeHolderImage:(UIImage *)placeHolderImage
{
    __weak typeof(self) wself = self;
    
    [_imageView sd_setImageWithURL:[NSURL URLWithString:photoURL] placeholderImage:placeHolderImage completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        [wself resizeScale];
        wself.saveImage = image;
    }];
}

-(void)resizeScale
{
    [self.scrollView setZoomScale:1.0f];
    self.zoomScale = 1.0f;
    
    CGSize size = [self resizedImage:_imageView.image];
    _imageView.frame = CGRectMake(shortLScreenW(size.width),
                                  shortLScreenH(size.height),
                                  size.width,
                                  size.height);
}

-(CGSize)resizedImage:(UIImage *)image
{
    if (image.size.width > iG_ScreenW && image.size.height > iG_ScreenH) { //都超范围
        if (image.size.width > image.size.height) { //宽度比高度高,宽度裁剪到一定屏幕宽度
            return CGSizeMake(iG_ScreenW, iG_ScreenW / image.size.width * image.size.height);
        }
        else{
            return CGSizeMake(iG_ScreenW / image.size.height * image.size.width, iG_ScreenH);
        }
    }
    else if (image.size.width > iG_ScreenW && image.size.height < iG_ScreenH) { //宽度超范围
        return CGSizeMake(iG_ScreenW, iG_ScreenW / image.size.width * image.size.height);
    }
    else if (image.size.width < iG_ScreenW && image.size.height > iG_ScreenH) { //高度超范围
        return CGSizeMake(iG_ScreenW / image.size.height * image.size.width, iG_ScreenH);
    }
    return CGSizeZero;
}

-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return _imageView;
}

-(void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale
{
    self.zoomScale = scale;
}

-(void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    if (scrollView.zoomScale <= 1) {
        scrollView.zoomScale = 1.0f;
    }
    
    CGFloat xcenter = scrollView.center.x , ycenter = scrollView.center.y;
    xcenter = scrollView.contentSize.width > scrollView.frame.size.width ? scrollView.contentSize.width / 2 : xcenter;
    ycenter = scrollView.contentSize.height > scrollView.frame.size.height ? scrollView.contentSize.height / 2 : ycenter;
    [_imageView setCenter:CGPointMake(xcenter, ycenter)];
}

@end
