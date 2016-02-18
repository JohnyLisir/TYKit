//
//  IGBaseTableView.m
//  xiangdemei
//
//  Created by iGalactus on 15/12/16.
//  Copyright © 2015年 一斌. All rights reserved.
//

#import "IGBaseTableView.h"

@interface IGBaseTableView() <UITableViewDataSource,UITableViewDelegate>

@end

@implementation IGBaseTableView

-(instancetype)init
{
    if (self = [super init]) {
        [self initializeUI];
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self initializeUI];
    }
    return self;
}

-(void)initializeUI
{
    self.delegate = self;
    self.dataSource = self;
//    self.separatorStyle = UITableViewCellSelectionStyleNone;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.tableViewHeightBlock) {
       return self.tableViewHeightBlock(tableView,indexPath).floatValue;
    }
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    if (self.tableViewCellsBlock) {
       return self.tableViewCellsBlock(tableView,indexPath);
    }
    return nil;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.tableViewRowsBlock) {
        return self.tableViewRowsBlock(tableView,section);
    }
    return 0;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.tableViewSelectedBlock) {
        self.tableViewSelectedBlock(tableView,indexPath);
    }
}

@end
