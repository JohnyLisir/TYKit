//
//  IGPhotoScanner.m
//  xiangdemei
//
//  Created by iGalactus on 15/12/29.
//  Copyright © 2015年 一斌. All rights reserved.
//

#import "IGPhotoScanner.h"
#import "IGPhotoViewCell.h"
#import "IGPhotoToolbar.h"

#define iG_ScreenW [UIScreen mainScreen].bounds.size.width
#define iG_ScreenH [UIScreen mainScreen].bounds.size.height

#define shortL(a,b) (a - b) / 2
#define shortLScreenW(a) (iG_ScreenW - a) / 2
#define shortLScreenH(a) (iG_ScreenH - a) / 2

#define clipDouble(a,b) a - 2 * b
#define clipDoubleWithScreenW(a) (iG_ScreenW - 2 * a)
#define clipDoubleWithScreenH(a) (iG_ScreenH - 2 * a)

static const CGFloat toolbarH = 50;


@interface IGPhotoScanner()<UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic,strong) UIWindow *overlayWindow;
@property (nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic,strong) IGPhotoToolbar *photoToolbar;

@property (nonatomic,strong) NSMutableArray *photoInnerList;
@property (nonatomic,strong) IGPhotoObject *currentObject;
@property (nonatomic) BOOL isBarShow; //上下视图是否已经显示


@end

@implementation IGPhotoScanner

-(instancetype)init
{
    if (self = [super init]) {
        
        _overlayWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _overlayWindow.backgroundColor = [UIColor clearColor];
        _overlayWindow.windowLevel = UIWindowLevelAlert;
        _overlayWindow.userInteractionEnabled = YES;
        [_overlayWindow addSubview:self];
        
        self.frame = _overlayWindow.bounds;
        
        [self addSubview:self.collectionView];
        [self addSubview:self.photoToolbar];
        
        [self initParams];
    }
    return self;
}

-(void)initParams
{
    self.photoInnerList = [NSMutableArray array];
    
    self.showIndex = 0;
    self.isBarShow = NO;
    self.maxScale = 3.0f;
    self.minScale = 1.0f;
}

-(void)photoViewShow
{
    [self initUI];
    [self.overlayWindow makeKeyAndVisible];
    
    if (self.showIndex > 0) {
        self.currentObject = self.photoInnerList[self.showIndex];
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:self.showIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
    }
    [self resetBars];
}

-(void)initUI
{
    if (self.photoObjectList) {
        for (NSObject *subObject in self.photoObjectList) {
            if ([subObject isKindOfClass:[IGPhotoObject class]]) {
                [self.photoInnerList addObject:subObject];
            }
        }
    }
    if (self.photosList) {
        for (int i = 0; i < self.photosList.count; i++) {
            id object = self.photosList[i];
            IGPhotoObject *photoObj = [[IGPhotoObject alloc] init];
            if ([object isKindOfClass:[NSString class]]) {
                photoObj.imageURL = object;
            }
            else if ([object isKindOfClass:[UIImage class]]){
                photoObj.photo = object;
            }
            [self.photoInnerList addObject:photoObj];
        }
    }

    [self.collectionView reloadData];
    self.currentObject = self.photoInnerList[self.showIndex];
    
    if (self.showTopTitleBar) {
        [self insertSubview:self.titleLabel belowSubview:self.photoToolbar];
    }
    
    if (self.showBottomContentBar) {
        [self insertSubview:self.contentLabel belowSubview:self.photoToolbar];
    }
}

//取消视图
-(void)photoViewDismiss
{
    [UIView animateWithDuration:0.2f animations:^{
        self.alpha = 0.0f;
    }completion:^(BOOL finished) {
        self.collectionView.dataSource = nil;
        self.collectionView.delegate = nil;
        [self.collectionView removeFromSuperview];
        self.collectionView = nil;
        
        [self.photoToolbar removeFromSuperview];
        self.photoToolbar = nil;
        
        self.overlayWindow = nil;
        
        [[UIApplication sharedApplication].windows enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(UIWindow *window, NSUInteger idx, BOOL *stop) {
            if ([window isKindOfClass:[UIWindow class]] && window.windowLevel == UIWindowLevelNormal && ![[window class] isEqual:[IGPhotoScanner class]]) {
                [window makeKeyWindow];
                *stop = YES;
            }
        }];
    }];
}

//重新设置上下栏的文字 和 toolbar的序号
-(void)resetBars
{
    self.photoToolbar.indexText = [NSString stringWithFormat:@"%d/%d",(int)self.showIndex + 1,(int)self.photoInnerList.count];
    
    self.titleLabel.frame = [self titleFrame];
    self.contentLabel.frame = [self contentFrame];
    self.titleLabel.text = self.currentObject.title;
    self.contentLabel.text = self.currentObject.content;
}

//单击手势
-(void)collectionViewTagGestureAction
{
    if (!self.showTopTitleBar && !self.showBottomContentBar) {
        [self photoViewDismiss];
        return;
    }
    
    if (self.isBarShow) {
        [UIView animateWithDuration:0.2f
                              delay:0.0f
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             self.titleLabel.frame = CGRectMake(0,
                                                                - CGRectGetHeight(self.titleLabel.frame),
                                                                iG_ScreenW,
                                                                CGRectGetHeight(self.titleLabel.frame));
                             
                             self.contentLabel.frame = CGRectMake(0,
                                                                  iG_ScreenH,
                                                                  iG_ScreenW,
                                                                  CGRectGetHeight(self.contentLabel.frame));
                             
                         } completion:^(BOOL finished) {
                             
                         }];
    }
    else{
        [self resetBars];
        [UIView animateWithDuration:0.2f
                              delay:0.0f
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             self.titleLabel.frame = CGRectMake(0,
                                                                0,
                                                                iG_ScreenW,
                                                                CGRectGetHeight(self.titleLabel.frame));
                             
                             self.contentLabel.frame = CGRectMake(0,
                                                                  iG_ScreenH - CGRectGetHeight(self.contentLabel.frame) - toolbarH,
                                                                  iG_ScreenW,
                                                                  CGRectGetHeight(self.contentLabel.frame));
                             
                         } completion:^(BOOL finished) {
                             
                         }];
    }
    
    self.isBarShow = !self.isBarShow;
}

//标题的尺寸
-(CGRect)titleFrame
{
    if (!self.showTopTitleBar) {
        return CGRectZero;
    }
    
    CGFloat titleH = [self.currentObject.title boundingRectWithSize:CGSizeMake(iG_ScreenW, MAXFLOAT)
                                                            options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin
                                                         attributes:@{NSFontAttributeName : self.titleLabel.font}
                                                            context:nil].size.height;
    if (self.currentObject.title && self.currentObject.title.length == 0) {
        titleH = 0;
    }
    
    return CGRectMake(0, self.isBarShow ? 0 : - titleH, iG_ScreenW, titleH);
}

//内容的尺寸
-(CGRect)contentFrame
{
    if (!self.showBottomContentBar) {
        return CGRectZero;
    }
    
    CGFloat contentH = [self.currentObject.content boundingRectWithSize:CGSizeMake(iG_ScreenW, MAXFLOAT)
                                                         options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin
                                                      attributes:@{NSFontAttributeName : self.contentLabel.font}
                                                         context:nil].size.height;
    if (self.currentObject.content && self.currentObject.content.length == 0) {
        contentH = 0;
    }
    return CGRectMake(0, self.isBarShow ? iG_ScreenH - contentH - toolbarH: iG_ScreenH, iG_ScreenW, contentH);
}

-(UICollectionView *)collectionView
{
    if (!_collectionView) {
        
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.itemSize = [UIScreen mainScreen].bounds.size;
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
        flowLayout.minimumInteritemSpacing = 1;
        flowLayout.minimumLineSpacing = 0;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height) collectionViewLayout:flowLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.pagingEnabled = YES;
        [_collectionView registerClass:[IGPhotoViewCell class] forCellWithReuseIdentifier:@"iGPhotoViewCell"];
    }
    return _collectionView;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.photoInnerList.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    IGPhotoViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"iGPhotoViewCell" forIndexPath:indexPath];
    IGPhotoObject *object = _photoInnerList[indexPath.row];
    cell.maxScale = self.maxScale;
    cell.minScale = self.minScale;
    if (object.imageURL && object.imageURL.length > 0) {
        [cell initWithPhotoURL:object.imageURL placeHolderImage:self.placeHolderImage];
    }
    else if (object.photo) {
        [cell initWithImage:object.photo];
    }
    
    __weak typeof(self) wself = self;
    
    cell.singleTapBlock = ^(){
        [wself collectionViewTagGestureAction];
    };
    
    return cell;
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    self.showIndex = scrollView.contentOffset.x / scrollView.frame.size.width;
    self.currentObject = self.photoInnerList[self.showIndex];
    [self resetBars];
}

-(IGPhotoToolbar *)photoToolbar
{
    if (!_photoToolbar) {
        _photoToolbar = [[IGPhotoToolbar alloc] initWithFrame:CGRectMake(0, iG_ScreenH - toolbarH, iG_ScreenW, toolbarH)];
        
        __weak typeof(self) wself = self;
        
        _photoToolbar.saveActionBlock = ^(){ //保存按钮点击
            IGPhotoViewCell *cell = (IGPhotoViewCell *)[wself.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:wself.showIndex inSection:0]];
            if (cell.saveImage) {
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//                    [IGOverlay showOverlayWithIndicatorWithStatus:@"正在保存" showInView:nil];
                    UIImageWriteToSavedPhotosAlbum(cell.saveImage, wself, @selector(image:didFinishSavingWithError:contextInfo:), nil);
                });
            }
        };
        
        _photoToolbar.exitActionBlock = ^(){
            [wself photoViewDismiss];
        };
    }
    return _photoToolbar;
}

//保存结果回调
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if (error) {
//        [IGOverlay showOverlayWithStatus:@"保存失败" options:1<<2 afterDelay:2.0f showInView:nil];
    }
    else {
//        [IGOverlay showOverlayWithStatus:@"保存成功" options:1<<3 afterDelay:2.0f showInView:nil];
    }
}

-(UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = [UIFont boldSystemFontOfSize:15];
        _titleLabel.numberOfLines = 0;
        _titleLabel.lineBreakMode = NSLineBreakByCharWrapping;
        _titleLabel.backgroundColor = [UIColor colorWithWhite:0.5f alpha:0.3f];
    }
    return _titleLabel;
}

-(UILabel *)contentLabel
{
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.textColor = [UIColor whiteColor];
        _contentLabel.font = [UIFont systemFontOfSize:15];
        _contentLabel.lineBreakMode = NSLineBreakByCharWrapping;
        _contentLabel.numberOfLines = 0;
        _contentLabel.backgroundColor = [UIColor colorWithWhite:0.5f alpha:0.3f];
    }
    return _contentLabel;
}

@end
