//
//  IGTabbar.m
//  IGCustom
//
//  Created by iGalactus on 16/1/5.
//  Copyright © 2016年 一斌. All rights reserved.
//

#import "IGTabbar.h"
#import "IGTabbarComponent.h"

@interface IGTabbar()

@property (nonatomic) NSInteger tabbarCounts;
@property (nonatomic,strong) IGTabbarComponent *selectedComponent;

@end

@implementation IGTabbar

-(instancetype)init{
    if (self != [super init]) {
        return nil;
    }
    [self contentInit];
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame{
    if (self != [super initWithFrame:frame]) {
        return nil;
    }
    [self contentInit];
    return self;
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self != [super initWithCoder:aDecoder]) {
        return nil;
    }
    [self contentInit];
    return self;
}

-(void)contentInit{
    self.normalTextColor = [UIColor colorWithWhite:0.8f alpha:1.0f];
    self.selectedTextColor = [UIColor blackColor];
    self.normalComponentBackgroundColor = [UIColor whiteColor];
    self.selectedComponentBackgroundColor = [UIColor whiteColor];
}

-(void)initializeWithTitles:(NSArray *)titles normalImages:(NSArray *)normalImages selectedImages:(NSArray *)selectedImages{
    self.tabbarCounts = titles.count;
    
    int tempIndex = 0;
    for (NSString *title in titles) {
        IGTabbarComponent *component = [[IGTabbarComponent alloc] init];
        component.contentLabel.text = title;
        component.normalImage = [UIImage imageNamed:normalImages[tempIndex]];
        component.selectedImage = [UIImage imageNamed:selectedImages[tempIndex]];
        component.tag = tempIndex;
        [component addTarget:self action:@selector(componentAction:) forControlEvents:UIControlEventTouchDown];
        [component addTarget:self action:@selector(componentDoubleAction:) forControlEvents:UIControlEventTouchDownRepeat];
        [self addSubview:component];
        tempIndex++;
    }
}

-(void)componentWithBadgeValue:(NSInteger)badgeValues index:(NSInteger)index{
    for (UIView *subObj in self.subviews) {
        if ([subObj isKindOfClass:[IGTabbarComponent class]]) {
            if (subObj.tag == index) {
                IGTabbarComponent *component = (IGTabbarComponent *)subObj;
                component.badgeValue = (int)badgeValues;
            }
        }
    }
}

-(void)removeAllBadgeValues{
    for (UIView *subObj in self.subviews) {
        if ([subObj isKindOfClass:[IGTabbarComponent class]]) {
            IGTabbarComponent *component = (IGTabbarComponent *)subObj;
            component.badgeValue = 0;
        }
    }
}

-(void)removeBadgeValueAtIndex:(NSInteger)index{
    for (UIView *subObj in self.subviews) {
        if ([subObj isKindOfClass:[IGTabbarComponent class]]) {
            if (subObj.tag == index) {
                IGTabbarComponent *component = (IGTabbarComponent *)subObj;
                component.badgeValue = 0;
            }
        }
    }
}

-(void)componentAction:(IGTabbarComponent *)sender{
    if (self.selectedComponent == sender) {
        return;
    }
    if (self.componentSingleTapBlock) {
        BOOL isAction = self.componentSingleTapBlock(sender.tag);//是否允许点击跳转
        if (isAction) {
            self.selectedComponent.selected = NO;
            sender.selected = YES;
            self.selectedComponent = sender;
            self.selectedIndex = self.selectedComponent.tag;
        }
    }
}

-(void)componentDoubleAction:(IGTabbarComponent *)sender{
    if (sender != self.selectedComponent) {
        return;
    }
    if (self.componentDoubleTapBlock) {
        self.componentDoubleTapBlock(sender.tag);
    }
}

-(void)setSelectedIndex:(NSInteger)selectedIndex{
    _selectedIndex = selectedIndex;
    if (!self.selectedComponent) {
        return;
    }
    for (UIView *subObj in self.subviews) {
        if ([subObj isKindOfClass:[IGTabbarComponent class]]) {
            if (subObj.tag == selectedIndex) {
                [self componentAction:(IGTabbarComponent *)subObj];
                return;
            }
        }
    }
}

-(void)layoutSubviews{
    [super layoutSubviews];
    [self tabbarComponents];
}

-(void)willMoveToSuperview:(UIView *)newSuperview{
    [super willMoveToSuperview:newSuperview];
    if (!CGRectIsEmpty(self.frame)) {
        return;
    }
    [self tabbarComponents];
}

-(void)tabbarComponents{
    CGFloat componentW = self.frame.size.width / self.tabbarCounts;
    
    int tempIndex = 0;
    for (UIView *subObj in self.subviews) {
        if ([subObj isKindOfClass:[IGTabbarComponent class]]) {
            IGTabbarComponent *component = (IGTabbarComponent *)subObj;
            component.normalTextColor = self.normalTextColor;
            component.selectedTextColor = self.selectedTextColor;
            component.normalComponentBackgroundColor = self.normalComponentBackgroundColor;
            component.selectedComponentBackgroundColor = self.selectedComponentBackgroundColor;
            component.frame = CGRectMake(componentW * component.tag, 0, componentW, self.frame.size.height);
            if (component.tag == _selectedIndex) {
                [self componentAction:component];
            }
            else{
                component.selected = NO;
            }
            tempIndex ++;
        }
    }
}

@end
