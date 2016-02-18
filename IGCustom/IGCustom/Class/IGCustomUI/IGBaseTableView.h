//
//  IGBaseTableView.h
//  xiangdemei
//
//  Created by iGalactus on 15/12/16.
//  Copyright © 2015年 一斌. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IGBaseTableView : UITableView

@property (nonatomic,copy) NSUInteger (^ tableViewSectionsBlock)(UITableView *tableView);
@property (nonatomic,copy) NSUInteger (^ tableViewRowsBlock)(UITableView *tableView , NSInteger section);
@property (nonatomic,copy) UITableViewCell* (^ tableViewCellsBlock)(UITableView *tableView , NSIndexPath *indexPath);
@property (nonatomic,copy) NSNumber* (^ tableViewHeightBlock)(UITableView *tableView , NSIndexPath *indexPath);
@property (nonatomic,copy) void (^ tableViewSelectedBlock)(UITableView *tableView , NSIndexPath *indexPath);

@end
