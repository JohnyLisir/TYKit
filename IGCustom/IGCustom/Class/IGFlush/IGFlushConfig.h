//
//  IGFlushConfig.h
//  IGCustom
//
//  Created by iGalactus on 16/1/23.
//  Copyright © 2016年 一斌. All rights reserved.
//

#ifndef IGFlushConfig_h
#define IGFlushConfig_h

typedef enum {
    IGFlushStatusOriginal = 0,      //原始状态
    IGFlushStatusPulling = 1,       //正在拉动
    IGFlushStatusWillOperation = 2, //正要刷新
    IGFlushStatusOperation = 3,     //正在刷新
    IGFlushStatusHiddenForever = 4, //无数据
}IGFlushStatus;

#endif /* IGFlushConfig_h */
