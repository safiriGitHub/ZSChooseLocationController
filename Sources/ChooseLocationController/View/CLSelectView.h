//
//  CLSelectView.h
//  CheFu365
//
//  Created by safiri on 2018/4/19.
//  Copyright © 2018年 safiri. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CLConfigs.h"

@class CLModel;
@interface CLSelectView : UIView

@property (nonatomic ,assign) LocationLevelTag lastLocationLevelTag;
@property (nonatomic ,weak) id <ChooseLocationDelegate>delegate;

- (void)showLocation:(NSArray <CLModel *>*)clModels;

- (void)scrollToPage:(NSInteger)pageTag;
@end
