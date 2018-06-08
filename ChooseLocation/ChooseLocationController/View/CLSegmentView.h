//
//  CLSegmentView.h
//  ChooseLocation
//
//  Created by safiri on 2018/4/20.
//  Copyright © 2018年 HY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CLConfigs.h"

#define CLSegmentViewHeight 35
@interface CLSegmentView : UIView

@property (nonatomic ,assign) LocationLevelTag lastLocationLevelTag;
@property (nonatomic ,weak) id <ChooseLocationDelegate>delegate;

- (void)updateTitleBtnWithName:(NSString *)name locationLevelTag:(LocationLevelTag)tag;
/// 选择指定的segment Btn 
- (void)activeSegmentForTag:(LocationLevelTag)tag;

@end

