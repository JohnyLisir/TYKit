//
//  ViewController.m
//  TYKit
//
//  Created by yanyibin on 16/2/25.
//  Copyright © 2016年 yanyibin. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong) UITableView *tableView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"tableCell"];
    [self.view addSubview:_tableView];
}

- (NSArray *)viewControllers{
    return @[@{@"name":@"IGDisplayer", @"controller":@"IGDisplayerController"},
             @{@"name":@"IGMasker", @"controller":@"IGMaskerController"}];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self viewControllers].count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"tableCell"];
    cell.textLabel.text = [self viewControllers][indexPath.row][@"name"];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *controllerName = [self viewControllers][indexPath.row][@"controller"];
    [self.navigationController pushViewController:[[[NSClassFromString(controllerName) class] alloc] init] animated:YES];
}

@end
