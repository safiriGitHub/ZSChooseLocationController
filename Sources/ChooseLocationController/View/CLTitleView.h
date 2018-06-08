//
//  CLTitleView.h
//  CheFu365
//
//  Created by safiri on 2018/4/19.
//  Copyright © 2018年 safiri. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CLConfigs.h"

@interface CLTitleView : UIView

@property (nonatomic ,copy) NSString *title;

@property (nonatomic ,weak) id <ChooseLocationDelegate>delegate;

@end
