//
//  ChooseLocationController.m
//  CheFu365
//
//  Created by safiri on 2018/4/19.
//  Copyright © 2018年 safiri. All rights reserved.
//

#import "ChooseLocationController.h"

#import "CLTitleView.h"
#import "CLSegmentView.h"
#import "CLSelectView.h"

@interface ChooseLocationController ()<ChooseLocationDelegate>

@property (nonatomic ,weak) CLTitleView *clTitleView;

@property (nonatomic ,weak) CLSegmentView *clSegmentView;

@property (nonatomic ,weak) CLSelectView *clSelectView;
@end

@implementation ChooseLocationController

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.lastLocationLevelTag = LocationLevelDistrict;
        
        CLTitleView *titleView = [[CLTitleView alloc] init];
        titleView.title = @"选择收货地址";
        titleView.delegate = self;
        [self addSubview:titleView];
        self.clTitleView = titleView;
        
        CLSegmentView *locationSegmentView = [[CLSegmentView alloc] init];
        locationSegmentView.delegate = self;
        locationSegmentView.lastLocationLevelTag = self.lastLocationLevelTag;
        [self addSubview:locationSegmentView];
        self.clSegmentView = locationSegmentView;
        
        CLSelectView *selectView = [[CLSelectView alloc] init];
        selectView.delegate = self;
        selectView.lastLocationLevelTag = self.lastLocationLevelTag;
        [self addSubview:selectView];
        self.clSelectView = selectView;
        
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat width = self.bounds.size.width;
    CGFloat height = self.bounds.size.height;
    CGFloat subH = CLSegmentViewHeight;
    
    self.clTitleView.frame = CGRectMake(0, 0, width, subH);
    self.clSegmentView.frame = CGRectMake(0, subH, width, subH);
    self.clSelectView.frame = CGRectMake(0, subH * 2, width, height - subH * 2);
}

- (void)setLastLocationLevelTag:(LocationLevelTag)lastLocationLevelTag {
    _lastLocationLevelTag = lastLocationLevelTag;
    self.clSelectView.lastLocationLevelTag = lastLocationLevelTag;
    self.clSegmentView.lastLocationLevelTag = lastLocationLevelTag;
}

- (void)parseDefaultData {
    //show hud
    [CLDataTool parseContainCodeDataFromJson:^(BOOL finish, NSArray<CLModel *> *locationCLModels) {
        // hide hud
        if (finish) {
            [self showLocation:locationCLModels];
        }
    }];
//    [CLDataTool parsePCADataFromJson:^(BOOL finish, NSArray<CLModel *> *locationCLModels) {
//        if (finish) {
//            [self.clSelectView showLocation:locationCLModels];
//        }
//    }];
}
- (void)showLocation:(NSArray <CLModel *>*)clModels {
    [self.clSelectView showLocation:clModels];
}
#pragma mark - delegate

//CLSelectView
- (void)selectedLocationName:(NSString *)name tag:(LocationLevelTag)tag {
    [self.clSegmentView updateTitleBtnWithName:name locationLevelTag:tag];
}
- (void)selectedLastLocationName:(NSString *)name lastTag:(LocationLevelTag)tag {
    [self.clSegmentView updateTitleBtnWithName:name locationLevelTag:tag];
}
- (void)contentScrolledToPageTag:(LocationLevelTag)tag {
    [self.clSegmentView activeSegmentForTag:tag];
}

//CLSegmentView
- (void)selectedSegmentBtnTag:(LocationLevelTag)tag {
    [self.clSelectView scrollToPage:tag];
}
- (void)finishChooseLocation:(NSString *)locationString {
    if ([self.delegate respondsToSelector:@selector(finishChooseLocation:)]) {
        [self.delegate finishChooseLocation:locationString];
    }
    [self closeBtnClick];
}
- (void)finishChooseLocationArray:(NSArray *)locationStrArray {
    if ([self.delegate respondsToSelector:@selector(finishChooseLocationArray:)]) {
        [self.delegate finishChooseLocationArray:locationStrArray];
    }
}

// CLTitleView
- (void)closeBtnClick {
    if ([self.delegate respondsToSelector:@selector(closeBtnClick)]) {
        [self.delegate closeBtnClick];
    }
}
@end
