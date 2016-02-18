//
//  IGPhotoToolbar.m
//  xiangdemei
//
//  Created by iGalactus on 15/12/29.
//  Copyright © 2015年 一斌. All rights reserved.
//

#import "IGPhotoToolbar.h"

@interface IGPhotoToolbar()

@property (nonatomic,strong) UIButton *saveButton , *exitButton;
@property (nonatomic,strong) UILabel *indexLabel;

@end

@implementation IGPhotoToolbar

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.9f];
        
        _indexLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 5, 100, frame.size.height - 10)];
        _indexLabel.textColor = [UIColor whiteColor];
        _indexLabel.font = [UIFont systemFontOfSize:15];
        [self addSubview:_indexLabel];
        
        _saveButton = [[UIButton alloc] initWithFrame:CGRectMake(frame.size.width - 130, 5, 60, frame.size.height - 10)];
        [_saveButton setTitle:@"保存" forState:0];
        [_saveButton setBackgroundImage:[UIImage imageWithColor:[UIColor blackColor]] forState:0];
        [_saveButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithWhite:0.0f alpha:0.8f]] forState:1<<0];
        _saveButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [_saveButton addTarget:self action:@selector(saveButtonAction) forControlEvents:1<<6];
        [self addSubview:_saveButton];
        
        _exitButton = [[UIButton alloc] initWithFrame:CGRectMake(frame.size.width - 60, 5, 60, frame.size.height - 10)];
        [_exitButton setTitle:@"退出" forState:0];
        [_exitButton setBackgroundImage:[UIImage imageWithColor:[UIColor blackColor]] forState:0];
        [_exitButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithWhite:0.0f alpha:0.8f]] forState:1<<0];
        _exitButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [_exitButton addTarget:self action:@selector(exitButtonAction) forControlEvents:1<<6];
        [self addSubview:_exitButton];
        
    }
    return self;
}

-(void)exitButtonAction
{
    if (self.exitActionBlock) {
        self.exitActionBlock();
    }
}

-(void)saveButtonAction
{
    if (self.saveActionBlock) {
        self.saveActionBlock();
    }
}

-(void)setIndexText:(NSString *)indexText
{
    _indexLabel.text = indexText;
}

@end
