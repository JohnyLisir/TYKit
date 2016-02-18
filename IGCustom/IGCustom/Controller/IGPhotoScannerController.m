//
//  IGPhotoScannerController.m
//  IGCustom
//
//  Created by iGalactus on 16/1/5.
//  Copyright © 2016年 一斌. All rights reserved.
//

#import "IGPhotoScannerController.h"

@interface IGPhotoScannerController ()
@property (nonatomic,strong) NSMutableArray *imageViewList;

@end

@implementation IGPhotoScannerController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _imageViewList = [NSMutableArray array];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"tableCell"];
    self.tableView.rowHeight = 150;
    
    CGFloat gapw = (self.view.frame.size.width - 100 * 3) / 4;
    
    for (int i = 0; i < 9; i++) {
        UIImageView *imageView = [[UIImageView alloc] init];
        NSInteger row = i / 3;
        NSInteger column = i % 3;
        
        imageView.frame = CGRectMake(gapw + (gapw + 100) * column, 100 + (50 + 100) * row, 100, 100);
        imageView.image = [UIImage imageNamed:@"wow.jpg"];
        imageView.tag = i;
        
        __weak typeof(self) wself = self;
        [imageView insertTapGestureWithBlock:^{
            IGPhotoScanner *scanner = [[IGPhotoScanner alloc] init];
            scanner.photosList = wself.imageViewList;
            scanner.showIndex = imageView.tag;
            [scanner photoViewShow];
        }];
        
        [self.view addSubview:imageView];

        [_imageViewList addObject:[UIImage imageNamed:@"wow.jpg"]];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"tableCell"];
    cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"wow.jpg"]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    IGPhotoScanner *scanner = [[IGPhotoScanner alloc] init];
    
//    NSMutableArray *arrays = []
}


@end
