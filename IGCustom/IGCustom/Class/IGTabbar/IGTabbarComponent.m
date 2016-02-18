//
//  IGTabbarComponent.m
//  IGCustom
//
//  Created by iGalactus on 16/1/5.
//  Copyright © 2016年 一斌. All rights reserved.
//

#import "IGTabbarComponent.h"

@interface IGTabbarComponent()

@property (nonatomic,strong) UILabel *badgeLabel;
@property (nonatomic,strong) UIImageView *iconView;

@end

@implementation IGTabbarComponent

-(instancetype)init
{
    if (self != [super init]) {
        return nil;
    }
    [self contentInit];
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self != [super initWithFrame:frame]) {
        return nil;
    }
    [self contentInit];
    return self;
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self != [super initWithCoder:aDecoder]) {
        return nil;
    }
    [self contentInit];
    return self;
}

-(void)contentInit
{
    self.selected = NO;
    self.badgeValue = 0;
}

-(void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    
    if (selected) {
        self.iconView.image = self.selectedImage;
        self.contentLabel.textColor = self.selectedTextColor;
        self.backgroundColor = self.selectedComponentBackgroundColor;
    }
    else{
        self.iconView.image = self.normalImage;
        self.contentLabel.textColor = self.normalTextColor;
        self.backgroundColor = self.normalComponentBackgroundColor;
    }
}

-(void)setBadgeValue:(int)badgeValue
{
    NSString *badgeValueText = [NSString stringWithFormat:@"%d",badgeValue];
    if (badgeValue > 99) {
        badgeValueText = @"99+";
        _badgeLabel.font = [UIFont systemFontOfSize:9];
    }
    else{
        _badgeLabel.font = [UIFont boldSystemFontOfSize:10];
    }
    self.badgeLabel.text = badgeValueText;
    self.badgeLabel.hidden = badgeValue <= 0;
}

-(void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    [self addSubview:self.iconView];
    [self addSubview:self.contentLabel];
    [self addSubview:self.badgeLabel];
    
    //Frame
    _iconView.frame = CGRectMake((self.frame.size.width - 25) / 2, 5, 25, 25);
    _badgeLabel.frame = CGRectMake(CGRectGetMaxX(_iconView.frame), 3, 25, 25);
    _contentLabel.frame = CGRectMake(0, CGRectGetMaxY(_iconView.frame), self.frame.size.width, 20);
}

-(UIImageView *)iconView
{
    if (!_iconView) {
        _iconView = [[UIImageView alloc] init];
        _iconView.contentMode = UIViewContentModeScaleAspectFit;
        _iconView.clipsToBounds = YES;
    }
    return _iconView;
}

-(UILabel *)contentLabel
{
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.font = [UIFont systemFontOfSize:13];
        _contentLabel.textColor = [UIColor colorWithWhite:0.3f alpha:1.0f];
        _contentLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _contentLabel;
}

-(UILabel *)badgeLabel
{
    if (!_badgeLabel) {
        _badgeLabel = [[UILabel alloc] init];
        _badgeLabel.backgroundColor = [UIColor colorWithRed:244.0 / 255.0 green:86.0 / 255.0 blue:137.0 / 255.0 alpha:1.0f];
        _badgeLabel.textAlignment = NSTextAlignmentCenter;
        _badgeLabel.textColor = [UIColor whiteColor];
        _badgeLabel.layer.cornerRadius = 12.5;
        _badgeLabel.clipsToBounds = YES;
        _badgeLabel.layer.borderColor = [UIColor whiteColor].CGColor;
        _badgeLabel.layer.borderWidth = 2.0f;
    }
    return _badgeLabel;
}

@end
