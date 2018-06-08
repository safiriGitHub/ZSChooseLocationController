//
//  CLSegmentView.m
//  ChooseLocation
//
//  Created by safiri on 2018/4/20.
//  Copyright © 2018年 HY. All rights reserved.
//

#import "CLSegmentView.h"

@interface CLSegmentView ()

@property (nonatomic ,weak) UIScrollView *scrollView;
@property (nonatomic ,weak) UIView *lineContainer;
/// 指示线
@property (nonatomic ,weak) UIView *lineActiveView;

@property (nonatomic ,strong) NSMutableArray <UIButton *>*titleBtns;

@property (nonatomic ,strong) NSMutableArray <NSString *>*locationNames;

@property (nonatomic ,assign) LocationLevelTag nowActivityTag;
@end

@implementation CLSegmentView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.titleBtns = [NSMutableArray arrayWithCapacity:4];
        self.locationNames = [NSMutableArray arrayWithCapacity:4];
        
        UIScrollView *scrollView = [[UIScrollView alloc] init];
        [self addSubview:scrollView];
        self.scrollView = scrollView;
        
        UIView *lineContainer = [[UIView alloc] init];
        lineContainer.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1];
        [self addSubview:lineContainer];
        self.lineContainer = lineContainer;
        
        UIView *lineActiveView = [[UIView alloc] init];
        lineActiveView.backgroundColor = LocationTextSelectedColor;
        [lineContainer addSubview:lineActiveView];
        self.lineActiveView = lineActiveView;
        
        [self addNextSelectHintBtnForTag:0];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat width = self.bounds.size.width;
    CGFloat height = self.bounds.size.height;
    CGFloat lineHeight = 1;
    self.scrollView.frame = CGRectMake(0, 0, width, height - lineHeight);
    self.scrollView.contentSize = CGSizeMake(width, 0);
    
    self.lineContainer.frame = CGRectMake(0, height - lineHeight, width, lineHeight);
    //self.lineActiveView.frame = CGRectMake(0, 0, 0, lineHeight);
}

#pragma mark - 控制显示位置名的 Segment Btn
- (void)updateTitleBtnWithName:(NSString *)name locationLevelTag:(LocationLevelTag)tag {
    if (tag < self.locationNames.count) {
        //已经含有该地区类的btn,再判断btn所指地区名和给的地区名是否相同
        NSString *oriName = self.locationNames[tag];
        if ([oriName isEqualToString:name]) {
            //移动line适应下一级btn
            self.nowActivityTag = tag + 1;
        }else {//不同
            //改本btn文字及宽度
            [self refreshBtn:name tag:tag];
            //更改数据源
            [self.locationNames replaceObjectAtIndex:tag withObject:name];
            if (tag == self.lastLocationLevelTag) { //最后的地区不展示请选择按钮
                self.nowActivityTag = tag;
                if ([self.delegate respondsToSelector:@selector(finishChooseLocation:)]) {
                    [self.delegate finishChooseLocation:[self.locationNames componentsJoinedByString:@""]];
                }
                if ([self.delegate respondsToSelector:@selector(finishChooseLocationArray:)]) {
                    [self.delegate finishChooseLocationArray:self.locationNames];
                }
            }else {
                //移除后面所有btn
                [self removeBehindLocationBtns:tag];
                //添加请选择btn
                [self addNextSelectHintBtnForTag:tag + 1];
            }
        }
    }
}
- (void)addNextSelectHintBtnForTag:(LocationLevelTag)tag {
    [self addNextLocationBtnWithModel:@"请选择" btnTag:tag];
    self.nowActivityTag = tag;
}
- (void)addNextLocationBtnWithModel:(NSString *)name btnTag:(LocationLevelTag)tag {
    
    CGRect nextBtnRect;
    CGFloat btnWidth = name.length * SegmentTitleOneWordWidth;
    CGFloat btnHeight = 22;
    if (self.titleBtns.count > 0) {
        UIButton *lastBtn = self.titleBtns.lastObject;
        nextBtnRect = CGRectMake(lastBtn.frame.origin.x + lastBtn.frame.size.width + 15, lastBtn.frame.origin.y, btnWidth, lastBtn.frame.size.height);
    }else {
        nextBtnRect = CGRectMake(20, (CLSegmentViewHeight - btnHeight)/2, btnWidth, btnHeight);
    }
    if (tag == LocationLevelProvince) {
        self.lineActiveView.frame = CGRectMake(20, 0, btnWidth, 1);
    }
    
    UIButton *nextBtn = [[UIButton alloc] initWithFrame:nextBtnRect];
    nextBtn.tag = tag;
    [nextBtn setTitle:name forState:UIControlStateNormal];
    [nextBtn setTitleColor:LocationTextNormalColor forState:UIControlStateNormal];
    nextBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    nextBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [nextBtn addTarget:self action:@selector(clickLocationBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollView addSubview:nextBtn];
    [self.titleBtns addObject:nextBtn];
    [self.locationNames addObject:name];
}
- (void)refreshBtn:(NSString *)title tag:(LocationLevelTag)tag {
    CGFloat width = title.length * SegmentTitleOneWordWidth;
    UIButton *btn = self.titleBtns[tag];
    [btn setTitle:title forState:UIControlStateNormal];
    
    CGRect frame = btn.frame;
    frame.size.width = width;
    btn.frame = frame;
}

- (void)removeBehindLocationBtns:(LocationLevelTag)tag {
    NSMutableIndexSet *removeSet = [NSMutableIndexSet indexSet];
    for (NSInteger i = 0; i < self.titleBtns.count; i++) {
        UIButton *btn = self.titleBtns[i];
        if (btn.tag > tag) {
            [btn removeFromSuperview];
            [removeSet addIndex:i];
        }
    }
    [self.titleBtns removeObjectsAtIndexes:removeSet];
    [self.locationNames removeObjectsAtIndexes:removeSet];
}

#pragma mark - 交互

- (void)clickLocationBtn:(UIButton *)senderBtn {
    self.nowActivityTag = senderBtn.tag;
    if ([self.delegate respondsToSelector:@selector(selectedSegmentBtnTag:)]) {
        [self.delegate selectedSegmentBtnTag:senderBtn.tag];
    }
}

- (void)setNowActivityTag:(LocationLevelTag)nowActivityTag {
    _nowActivityTag = nowActivityTag;
    
    for (UIButton *btn in self.titleBtns) {
        [btn setTitleColor:LocationTextNormalColor forState:UIControlStateNormal];
    }
    if (nowActivityTag < self.titleBtns.count) {
        // active btn
        UIButton *toActiveBtn = self.titleBtns[nowActivityTag];
        //active line
        CGRect frame = self.lineActiveView.frame;
        frame.origin.x = toActiveBtn.frame.origin.x;
        frame.size.width = toActiveBtn.frame.size.width;
        if (frame.size.height == 0) frame.size.height = 1;
        [UIView animateWithDuration:0.25 animations:^{
            [toActiveBtn setTitleColor:LocationTextSelectedColor forState:UIControlStateNormal];
            self.lineActiveView.frame = frame;
        }];
    }
    
}

- (void)activeSegmentForTag:(LocationLevelTag)tag {
    if (tag != self.nowActivityTag) {
        self.nowActivityTag = tag;
    }
}

@end
