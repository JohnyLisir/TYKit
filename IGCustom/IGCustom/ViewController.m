//
//  ViewController.m
//  IGCustom
//
//  Created by iGalactus on 15/12/30.
//  Copyright © 2015年 一斌. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <UITableViewDelegate,UITableViewDataSource>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"tableCell"];
}

- (NSArray *)viewControllers
{
    return @[@{@"name":@"IGDisplayer", //弹出框
               @"controller":@"IGDisplayerController"},
//             @{@"name":@"IGCarousel", //轮播图
//               @"controller":@"IGCarouselController"},
//             @{@"name":@"IGPhotoScanner", //图片浏览器
//               @"controller":@"IGPhotoScannerController"},
             @{@"name":@"IGOverlay2", //提示框
               @"controller":@"IGMaskerController"}];
//             @{@"name":@"IGTabbar", //底栏
//               @"controller":@"IGTabbarController"},
//             @{@"name":@"IGFlush", //刷新
//               @"controller":@"IGReloaderController"}];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self viewControllers].count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"tableCell"];
    cell.textLabel.text = [self viewControllers][indexPath.row][@"name"];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *controllerName = [self viewControllers][indexPath.row][@"controller"];
    [self.navigationController pushViewController:[[[NSClassFromString(controllerName) class] alloc] init] animated:YES];
}

@end
