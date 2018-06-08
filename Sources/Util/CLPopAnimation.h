//
//  CLPopAnimation.h
//  CheFu365
//
//  Created by safiri on 2018/5/3.
//  Copyright © 2018年 safiri. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void(^CloseCompletion)(BOOL finished);
typedef void(^SetNeedsStatusBarAppearanceUpdateCallBack)(void);

@interface CLPopAnimation : NSObject

/// YES:hide NO:show 暂时不用
//@property (nonatomic ,assign) BOOL showOrHideForStatusBar;
/// YES:def  NO:light
@property (nonatomic ,assign) BOOL showOrHideForstatusBarStyle;

+ (instancetype)shareAnimation;


/**
 传入凹陷的rootView和底部弹出的popView
 
 @param rootView 底层凹陷的View
 @param popView 底部弹出的View
 */
- (void)startAnimationRootView:(UIView *)rootView andPopView:(UIView *)popView completion:(void (^)(BOOL finished))completion;

@property (nonatomic ,copy) CloseCompletion closeCompletion;
@property (nonatomic ,copy) SetNeedsStatusBarAppearanceUpdateCallBack statusBarAppearanceUpdateCallBack;
- (void)dismissPopView;

/** 从底部向上展示View
 */
- (void)showDownPopView:(UIView *)showView;
- (void)dismissDownPopView;
@end
