//
//  IGTabbarController.m
//  IGCustom
//
//  Created by iGalactus on 16/1/5.
//  Copyright © 2016年 一斌. All rights reserved.
//

#import "IGTabbarController.h"
#import "IGTabbar.h"

@interface IGTabbarController ()

@end

@implementation IGTabbarController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    IGTabbar *tabbar = [[IGTabbar alloc] init];
    tabbar.frame = self.tabBar.bounds;
    
    NSArray *titleList = @[@"首页",@"灌水",@"我的",@"我的",@"我的"];
    NSArray *icons = @[@"tabbar_home",@"tabbar_comment",@"tabbar_user",@"tabbar_user",@"tabbar_user"];
    NSArray *selectedIcons = @[@"tabbar_home_select",@"tabbar_comment_select",@"tabbar_user_select",@"tabbar_user_select",@"tabbar_user_select"];
    
    [tabbar initializeWithTitles:titleList normalImages:icons selectedImages:selectedIcons];
    [self.tabBar addSubview:tabbar];
    
    tabbar.selectedIndex = 3;
    
    tabbar.componentSingleTapBlock = ^BOOL(NSInteger index){
        NSLog(@"single %d",(int)index);
        return YES;
    };
    
    tabbar.componentDoubleTapBlock = ^(NSInteger index){
        NSLog(@"double %d",(int)index);
    };
    
    [tabbar componentWithBadgeValue:1 index:2];
    [tabbar componentWithBadgeValue:122 index:0];
    [tabbar componentWithBadgeValue:33 index:3];
    
    tabbar.normalComponentBackgroundColor = [UIColor whiteColor];
    tabbar.selectedComponentBackgroundColor = [UIColor colorWithWhite:0.8f alpha:1.0f];
    tabbar.normalTextColor = [UIColor redColor];
    tabbar.selectedTextColor = [UIColor blueColor];
    
//    [tabbar removeAllBadgeValues];
}


@end
