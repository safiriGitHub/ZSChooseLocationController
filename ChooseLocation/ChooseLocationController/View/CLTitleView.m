//
//  CLTitleView.m
//  CheFu365
//
//  Created by safiri on 2018/4/19.
//  Copyright © 2018年 safiri. All rights reserved.
//

#import "CLTitleView.h"

@interface CLTitleView ()

@property (nonatomic ,weak) UILabel *titleLab;

@property (nonatomic ,weak) UIButton *closeBtn;
@end

@implementation CLTitleView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        UILabel *titleLab = [[UILabel alloc] init];
        titleLab.textColor = CLTitleColor;
        titleLab.textAlignment = NSTextAlignmentCenter;
        titleLab.font = [UIFont systemFontOfSize:15];
        self.titleLab = titleLab;
        [self addSubview:titleLab];
        
        UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [closeBtn setImage:[UIImage imageNamed:@"cl_close.png"] forState:UIControlStateNormal];
        [closeBtn addTarget:self action:@selector(closeClick) forControlEvents:UIControlEventTouchUpInside];
        self.closeBtn = closeBtn;
        [self addSubview:closeBtn];
    }
    return self;
}
- (void)setTitle:(NSString *)title {
    _title = title;
    self.titleLab.text = title;
}
- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat width = self.bounds.size.width;
    CGFloat height = self.bounds.size.height;
    CGFloat wh = 15;
    CGFloat closeBtnX = width - wh - 10;
    CGFloat closeBtnY = (height - wh) / 2;
    
    self.titleLab.frame = CGRectMake((width - 200) / 2, (height - 22) / 2 + 3, 200, 22);
    self.closeBtn.frame = CGRectMake(closeBtnX, closeBtnY, wh, wh);
}

- (void)closeClick {
    if ([self.delegate respondsToSelector:@selector(closeBtnClick)]) {
        [self.delegate closeBtnClick];
    }
}
@end
