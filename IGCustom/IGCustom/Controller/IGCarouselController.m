//
//  IGCarouselController.m
//  IGCustom
//
//  Created by iGalactus on 15/12/30.
//  Copyright © 2015年 一斌. All rights reserved.
//

#import "IGCarouselController.h"

@interface IGCarouselController ()

@end

@implementation IGCarouselController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    IGCarousel *carousel = [[IGCarousel alloc] init];
    carousel.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.2];
    carousel.frame = CGRectMake(0, 100, self.view.frame.size.width, 200);
    
    IGCarouselObject *object1 = [[IGCarouselObject alloc] init];
    object1.imageURL = @"http://img10.3lian.com/c1/newpic/10/24/29.jpg";
    object1.content = @"2015年我国的泡沫化问题应该比2014年更加严重了，但为何中央经济工作会议反而不提泡沫了呢？";
    
    IGCarouselObject *object2 = [[IGCarouselObject alloc] init];
    object2.imageURL = @"http://d.hiphotos.baidu.com/zhidao/pic/item/eac4b74543a9822604312cf28882b9014b90eb77.jpg";
    object2.content = @"选择一款具有多种功能的修颜霜，无论它是一款气垫型，还是常规涂抹型，最大的特征是一瓶能够囊括防晒、隔离、保湿、修饰、遮瑕等多种功效，最为适合OL族群使用，安利六款（在护肤、化妆品上女生经常花很多钱却很难找到性价比高、适合自己的产品，关 注我 每天为你推.荐性价比最高、口碑最好的产.品）";
    
    IGCarouselObject *object3 = [[IGCarouselObject alloc] init];
    object3.imageURL = @"http://ww1.sinaimg.cn/large/7bb6feadgw1dv30xnokz5j.jpg";
    object3.content = @"鸡腿做法合集，先关注了，明天再学起";
    
    IGCarouselObject *object4 = [[IGCarouselObject alloc] init];
    object4.imageURL = @"http://wow.yzz.cn/public/images/101215/101_111029_1.jpg";
    object4.content = @"爱美必看！";
    
    
//    carousel.carouselList = @[@"http://img10.3lian.com/c1/newpic/10/24/29.jpg",
//                              @"http://wow.yzz.cn/public/images/101215/101_111029_1.jpg",
//                              @"http://images.gamerlol.com/upload/2013/03/gl201331315104919661221.jpg",
//                              @"http://pic4.nipic.com/20091009/3050636_082643111322_2.jpg",
//                              @"http://d.hiphotos.baidu.com/zhidao/pic/item/eac4b74543a9822604312cf28882b9014b90eb77.jpg",
//                              @"http://wow.tgbus.com/UploadFiles_2396/201002/2010022614150498.jpg",
//                              @"http://ww1.sinaimg.cn/large/7bb6feadgw1dv30xnokz5j.jpg"];
    carousel.currentIndex = 22;
    
    carousel.iGCarouselSelectedBlock = ^(NSInteger index , IGCarouselObject *carouselObject){
        NSLog(@"index %d , carouselObject %@",(int)index,carouselObject);
    };
    
    
    [self.view addSubview:carousel];
    
//    [carousel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.right.equalTo(self.view);
//        make.top.mas_equalTo(100);
//        make.height.mas_equalTo(200);
//    }];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        carousel.carouselList = @[object1,object2,object3,object4];
        [carousel reloadCarousel];
    });
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}


@end
