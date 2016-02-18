//
//  IGRenovaterController.m
//  IGCustom
//
//  Created by iGalactus on 15/12/31.
//  Copyright © 2015年 一斌. All rights reserved.
//

#import "IGReloaderController.h"
#import "IGBaseTableView.h"

@interface IGReloaderController ()

@property (nonatomic,strong) IGBaseTableView *tableView;

@end

@implementation IGReloaderController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];

    self.tableView = [[IGBaseTableView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height-64)];
    __weak typeof(self) wself = self;
    self.tableView.tableViewHeightBlock = ^(UITableView *tableView , NSIndexPath *indexPath){
        return @(50);
    };
    self.tableView.tableViewCellsBlock = ^(UITableView *tableView , NSIndexPath *indexPath){
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
        switch (indexPath.row) {
            case 0:
            {
                cell.textLabel.text = @"ScrollView";
            }
                break;
            case 1:
            {
                cell.textLabel.text = @"TableView";
            }
                break;
            default:
                break;
        }
        return cell;
    };
    self.tableView.tableViewRowsBlock = ^(UITableView *tableView , NSInteger section){
        return (NSUInteger)2;
    };
    self.tableView.tableViewSelectedBlock = ^(UITableView *tableView , NSIndexPath *indexPath){
        NSString *className;
        switch (indexPath.row) {
            case 0:{
                className = @"IGReloaderScrollViewController";
            }
                break;
            case 1:{
                className = @"IGReloaderTableViewController";
            }
                break;
                
            default:
                break;
        }
        [wself.navigationController pushViewController:[[NSClassFromString(className) alloc] init] animated:YES];
    };
    
    [self.view addSubview:self.tableView];
}


@end
