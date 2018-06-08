//
//  CLConfigs.h
//  ChooseLocation
//
//  Created by safiri on 2018/4/23.
//  Copyright © 2018年 HY. All rights reserved.
//

#ifndef CLConfigs_h
#define CLConfigs_h

#import "CLModel.h"
#import "CLDataTool.h"
#import "CLPopAnimation.h"

#define CLTitleColor [UIColor colorWithRed:155/255.f green:159/255.f blue:170/255.f alpha:1]
#define LocationTextNormalColor [UIColor colorWithRed:91/255.f green:100/255.f blue:105/255.f alpha:1]
#define LocationTextSelectedColor [UIColor colorWithRed:254/255.f green:41/255.f blue:43/255.f alpha:1]
#define SegmentTitleOneWordWidth 15

typedef NS_ENUM(NSUInteger, LocationLevelTag) {
    LocationLevelProvince = 0,
    LocationLevelCity,
    LocationLevelDistrict,
    LocationLevelStreet
};

@protocol ChooseLocationDelegate <NSObject>

@optional
//CLSelectView
- (void)selectedLocationName:(NSString *)name tag:(LocationLevelTag)tag;
- (void)contentScrolledToPageTag:(LocationLevelTag)tag;
- (void)selectedLastLocationName:(NSString *)name lastTag:(LocationLevelTag)tag;

// CLSegmentView
- (void)selectedSegmentBtnTag:(LocationLevelTag)tag;
// CLSegmentView ChooseLocationController
- (void)finishChooseLocation:(NSString *)locationString;

// CLTitleView
- (void)closeBtnClick;

//ChooseLocationController
- (void)finishChooseLocationArray:(NSArray *)locationStrArray;
@end

@protocol ChooseLocationPickerDelegate <NSObject>

@optional
/// 确定按钮点击回调 分别返回省市区
- (void)confirmSelectedAreaResultWithProvince:(NSString *)provinceTitle
                                     city:(NSString *)cityTitle
                                     district:(NSString *)districtTitle;
/// 取消按钮点击回调
- (void)cancelChoosePicker;

@required
/// 隐藏
- (void)dismissChoosPicker;
@end

#endif /* CLConfigs_h */
