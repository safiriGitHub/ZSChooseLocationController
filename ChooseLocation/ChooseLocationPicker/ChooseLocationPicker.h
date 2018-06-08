//
//  ChooseLocationPicker.h
//  CheFu365
//
//  Created by safiri on 2018/5/4.
//  Copyright © 2018年 safiri. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CLConfigs.h"

@interface ChooseLocationPicker : UIView

/// 指定最小层的地区，根据数据源调整 默认为LocationLevelDistrict
@property (nonatomic ,assign) LocationLevelTag lastLocationLevelTag;

/// 标题大小
@property (nonatomic, strong) UIFont  *titleFont;
/// 选择器背景颜色
@property (nonatomic, strong) UIColor *pickViewBackgroundColor;
/// 选择器头部视图颜色
@property (nonatomic, strong) UIColor *topViewBackgroundColor;
/// 取消按钮颜色
@property (nonatomic, strong) UIColor *cancelBtnTitleColor;
/// 确定按钮颜色
@property (nonatomic, strong) UIColor *confirmBtnTitleColor;

/// 选择器代理
@property (nonatomic, weak) id <ChooseLocationPickerDelegate>pickViewDelegate;

- (void)parseAndShowDefaultData;
/// 赋值数据源
- (void)showLocationData:(NSArray <CLModel *>*)clModels;
@end
