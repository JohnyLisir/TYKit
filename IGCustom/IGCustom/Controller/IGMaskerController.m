//
//  IGMaskerController.m
//  IGCustom
//
//  Created by iGalactus on 16/1/21.
//  Copyright © 2016年 一斌. All rights reserved.
//

#import "IGMaskerController.h"
#import "IGMasker.h"

@interface IGMaskerController ()

@property (nonatomic,strong) IGMasker *masker;

@end

@implementation IGMaskerController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    UIButton *showBtn = [[UIButton alloc] initWithFrame:CGRectMake(50, 200, 50, 50)];
    showBtn.backgroundColor = [UIColor greenColor];
    [showBtn addTarget:self action:@selector(showAction) forControlEvents:1<<6];
    [self.view addSubview:showBtn];
    
    UIButton *hiddenBtn = [[UIButton alloc] initWithFrame:CGRectMake(250, 200, 50, 50)];
    hiddenBtn.backgroundColor = [UIColor purpleColor];
    [hiddenBtn addTarget:self action:@selector(hiddenAction) forControlEvents:1<<6];
    [self.view addSubview:hiddenBtn];
}

-(void)showAction{
//    [self.view addSubview:self.masker];
//    [self.masker maskerShow];
    
    [IGMasker maskerShowWithType:IGMaskerTypeError status:@"请求出错" delayTime:MAXFLOAT showInView:self.view maskerCompleteBlock:^{
        NSLog(@"masker 结束");
    }];
    
//    [IGMasker maskerShowDisallowInteractionWithStatus:@"登录中" showInView:self.view];
}

-(void)hiddenAction{
//    [_masker maskerHidden];
    [IGMasker maskerHiddenInView:self.view];
}

-(IGMasker *)masker{
    if (!_masker) {
        _masker = [[IGMasker alloc] init];
        _masker.contentLabel.text = @"正在加载中睡觉奥卡萨克就开始卡";
        _masker.maskerType = IGMaskerTypeWaiting;
        _masker.maskerShowType = IGMaskerAnimationTypeDrawer;
        _masker.isUserDisallowedTouch = YES;
//        _masker.maskerCustomizedSize = CGSizeMake(250, 100);
//        _masker.contentLabelPadding = 20;
//        _masker.iconTopPadding = 30;
//        _masker.autoHiddenTimeInterval = 1.0f;
    }
    return _masker;
}

@end
