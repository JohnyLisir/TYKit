//
//  IGDisplayerController.m
//  IGCustom
//
//  Created by iGalactus on 16/1/23.
//  Copyright © 2016年 一斌. All rights reserved.
//

#import "IGDisplayerController.h"
#import "IGDisplayer.h"

@interface IGDisplayerController ()

@end

@implementation IGDisplayerController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *displayBtn = [[UIButton alloc] initWithFrame:CGRectMake(100, 200, 100, 100)];
    displayBtn.backgroundColor = [UIColor redColor];
    [displayBtn addTarget:self action:@selector(displayAction) forControlEvents:1<<6];
    [self.view addSubview:displayBtn];
}

-(void)displayAction{
    [IGDisplayer showDisplayerWithPositionType:IGDisplayerPositionTypeCenter
                                     titleText:@"我们有新版本啦~"
                                   contentText:@"马上前去更新"
                             cancelButtonTitle:@"残忍地取消"
                                    buttonList:@[@"一号",@"二号"]
                             handleActionBlock:^(IGDisplayer *displayer, NSInteger index) {
                                 
                             }];
    
    
//    IGDisplayer *displayer = [[IGDisplayer alloc] init];
//    displayer.titleLabel.text = @"这台电脑怎么样";
//    displayer.textLabel.textAlignment = NSTextAlignmentLeft;
//    displayer.titleLabel.textColor = [UIColor purpleColor];
//    displayer.titleLabel.backgroundColor = [UIColor redColor];
//    displayer.textLabel.text = @"第一点:这很重要\n第二点:这很关键\n第三点:强冷空气主体已影响我市，气温快速下降，明天到26日最低气温市区和沿海地区－5～－8度，高海拔山区－15度以下";
//    displayer.textLabel.font = [UIFont systemFontOfSize:25];
//    displayer.otherButtonList = @[@"很差",@"很好",@"不错"];
//    displayer.isHiddenCancelButton = YES;
//    displayer.displayerPositionType = IGDisplayerPositionTypeBottom;
//    displayer.displayerShowType = IGDisplayerShowTypeDrawer;
//    displayer.titleEdgeInsets = UIEdgeInsetsMake(50, 10, 30, 0);
//    displayer.buttonHeight = 30;
//    displayer.buttonsInset = 5;
//    displayer.isHiddenDisplayerByTouch = YES;
//    
//    UIView *customView = [[UIView alloc] init];
//    customView.backgroundColor = [UIColor redColor];
//    displayer.customView = customView;
//    displayer.customViewSize = CGSizeMake(100, 200);
//    displayer.displayerContentType = IGDisplayerContentTypeCustom;
//    
//    displayer.displayerActionBlock = ^(IGDisplayer *displayer , NSInteger index){
//        NSLog(@"按钮%d被点击",(int)index);
//    };
//    [displayer displayerShow];
}

@end
