//
//  IGReloaderTableViewController.m
//  IGCustom
//
//  Created by iGalactus on 15/12/31.
//  Copyright © 2015年 一斌. All rights reserved.
//

#import "IGReloaderTableViewController.h"
#import "UIScrollView+IGFlush.h"

@interface IGReloaderTableViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataSourceList;

@end

@implementation IGReloaderTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem *TopItem = [[UIBarButtonItem alloc] initWithTitle:@"Top" style:UIBarButtonItemStylePlain target:self action:@selector(topCancel)];
    UIBarButtonItem *BottomItem = [[UIBarButtonItem alloc] initWithTitle:@"Bottom" style:UIBarButtonItemStylePlain target:self action:@selector(bottomCancel)];
    self.navigationItem.rightBarButtonItems = @[TopItem,BottomItem];
    
    _dataSourceList = [NSMutableArray array];
    for (int i = 0; i < 3; i++) {
        [_dataSourceList addObject:@"1"];
    }
    
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"tableCell"];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.rowHeight = 44;
    _tableView.contentInset = UIEdgeInsetsMake(50, 0, 100, 0);
    _tableView.tableFooterView = [UIView new];
    [self.view addSubview:_tableView];
    
    __weak typeof(self) wself = self;
    
    [_tableView insertTopFlushWithResponse:^{
        for (int i = 0; i < 3; i++) {
            [wself.dataSourceList addObject:@"1"];
        }
        [wself.tableView reloadData];
        [wself.tableView topFlushStopAnimation];
    }];
    
    [_tableView insertBottomFloshWithReponse:^{
        for (int i = 0; i < 3; i++) {
            [wself.dataSourceList addObject:@"2"];
        }
        [wself.tableView reloadData];
        [wself.tableView bottomFlushStopAnimationForever];
    }];
}

-(void)topCancel{
    [_tableView topFlushStopAnimation];
}

-(void)bottomCancel{
    [_tableView bottomFlushStopAnimation];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataSourceList.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"tableCell"];
    cell.textLabel.text = [NSString stringWithFormat:@"%d",(int)indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}


@end
