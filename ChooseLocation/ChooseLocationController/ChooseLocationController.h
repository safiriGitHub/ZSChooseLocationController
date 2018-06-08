//
//  ChooseLocationController.h
//  CheFu365
//
//  Created by safiri on 2018/4/19.
//  Copyright © 2018年 safiri. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CLConfigs.h"
#import "CLPopAnimation.h"
#import "CLDataTool.h"

@interface ChooseLocationController : UIView

@property (nonatomic ,weak) id <ChooseLocationDelegate>delegate;

/// 指定最小层的地区，根据数据源调整 默认为LocationLevelDistrict
@property (nonatomic ,assign) LocationLevelTag lastLocationLevelTag;

/// 初始化后调用，使用默认的数据
- (void)parseDefaultData;

/// 显示指定的城市数据
- (void)showLocation:(NSArray <CLModel *>*)clModels;
@end
