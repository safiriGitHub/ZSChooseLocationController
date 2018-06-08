//
//  CLSelectView.m
//  CheFu365
//
//  Created by safiri on 2018/4/19.
//  Copyright © 2018年 safiri. All rights reserved.
//

#import "CLSelectView.h"
#import "CLSelectViewCell.h"
#import "CLModel.h"

@interface CLSelectView ()<UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate>

/// province models
@property (nonatomic ,strong) NSArray <CLModel *>* provinceModels;
/// selected city models
@property (nonatomic ,strong) NSArray <CLModel *>*cityModels;
/// selected district models
@property (nonatomic ,strong) NSArray <CLModel *>*districtModels;
/// selected street models
@property (nonatomic ,strong) NSArray <CLModel *>*streetModels;

@property (nonatomic ,weak) UIScrollView *contentScrollView;
@property (nonatomic ,strong) NSMutableArray <UITableView *>*tableViews;

@end

@implementation CLSelectView

#pragma mark - UI
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self createUI];
    }
    return self;
}

- (void)createUI {
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.pagingEnabled = YES;
    scrollView.backgroundColor = [UIColor whiteColor];
    scrollView.delegate = self;
    [self addSubview:scrollView];
    self.contentScrollView = scrollView;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat width = self.bounds.size.width;
    self.contentScrollView.frame = CGRectMake(0, 0, width, self.bounds.size.height);
    self.contentScrollView.contentSize = CGSizeMake(width, 0);
}

#pragma mark - UI show action
- (void)showLocation:(NSArray <CLModel *>*)clModels {
    /// data init
    self.provinceModels = clModels;
    self.tableViews = [NSMutableArray arrayWithCapacity:4];
    
    [self addTableView];
}
- (void)addTableView {
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(self.bounds.size.width * self.tableViews.count, 0, self.bounds.size.width, self.bounds.size.height) style:UITableViewStylePlain];
    [self.contentScrollView addSubview:tableView];
    [self.tableViews addObject:tableView];
    tableView.tag = [self.tableViews indexOfObject:tableView];// add tag
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.contentInset = UIEdgeInsetsMake(0, 0, 5, 0);
    [CLSelectViewCell registerCellWithTableView:tableView];
}
//当重新选择省或者市的时候，需要将下级所有table视图移除。
- (void)removeNextAllTableView:(NSInteger)currentTableViewTag {
    for (NSInteger i = self.tableViews.count - 1; i > currentTableViewTag; i--) {
        [self.tableViews.lastObject performSelector:@selector(removeFromSuperview) withObject:nil withObject:nil];
        [self.tableViews removeLastObject];
    }
}

#pragma mark ScrollView
- (void)scrollToNextTableView:(NSInteger)currentTableViewTag {
    CGFloat width = self.bounds.size.width;
    
    [UIView animateWithDuration:0.25 animations:^{
        self.contentScrollView.contentSize = (CGSize){self.tableViews.count * width, 0};
        CGPoint offset = self.contentScrollView.contentOffset;
        self.contentScrollView.contentOffset = CGPointMake(offset.x + width, offset.y);
    }];
}
- (void)scrollToPage:(NSInteger)pageTag {
    CGFloat width = self.bounds.size.width;
    [UIView animateWithDuration:0.25 animations:^{
        self.contentScrollView.contentOffset = CGPointMake(width * pageTag, 0);
    }];

}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView != self.contentScrollView) return;
    NSInteger index = scrollView.contentOffset.x / scrollView.frame.size.width;
    if ([self.delegate respondsToSelector:@selector(contentScrolledToPageTag:)]) {
        [self.delegate contentScrolledToPageTag:index];
    }
}

#pragma mark - tableView delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (tableView.tag == 0) { //省
        return self.provinceModels.count;
    }else if (tableView.tag == 1) { //市
        return self.cityModels.count;
    }else if (tableView.tag == 2) { //区
        return self.districtModels.count;
    }else if (tableView.tag == 3) { //街道
        return self.streetModels.count;
    }
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 35;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CLSelectViewCell *cell = [CLSelectViewCell cellWithTableView:tableView forIndexPath:indexPath];
    
    CLModel *model;
    if (tableView.tag == 0) { //省
        model = self.provinceModels[indexPath.row];
    }else if (tableView.tag == 1) { //市
        model = self.cityModels[indexPath.row];
    }else if (tableView.tag == 2) { //区
        model = self.districtModels[indexPath.row];
    }else if (tableView.tag == 3) { //街道
        model = self.streetModels[indexPath.row];
    }
    if (model) [cell refreshCell:model];
    return cell;
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSIndexPath *selectedIndexPath = [tableView indexPathForSelectedRow];
    //BOOL repeat = [selectedIndexPath compare:indexPath] == NSOrderedSame;
    BOOL repeat = selectedIndexPath == indexPath;
    NSInteger currentTableViewTag = tableView.tag;
    
    if (!repeat) {
        // 解析下一级数据源
        if (currentTableViewTag == 0 ) { //省
            [self parseCityModelsFromSelectedProvince:indexPath.row];
        }else if (currentTableViewTag == 1) { //市
            [self parseDistrictModelsFromSelectedCity:indexPath.row];
        }else if (currentTableViewTag == 2) { //区
            [self parseStreetModelsFromSelectedDistrict:indexPath.row];
        }else if (currentTableViewTag == 3) { //街道
           
        }
    }
    
    return indexPath;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger currentTableViewTag = tableView.tag;
    CLModel *cellModel;
    BOOL canEnterNext = YES;
    if (currentTableViewTag == 0 ) { //省
        cellModel = self.provinceModels[indexPath.row];
    }else if (currentTableViewTag == 1) { //市
        cellModel = self.cityModels[indexPath.row];
    }else if (currentTableViewTag == 2) { //区
        cellModel = self.districtModels[indexPath.row];
    }else if (currentTableViewTag == 3) { //街道
        cellModel = self.streetModels[indexPath.row];
        canEnterNext = NO;
    }
    if (currentTableViewTag == self.lastLocationLevelTag) {
        canEnterNext = NO;
    }
    cellModel.isSelected = YES;
    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    [tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    if (canEnterNext) {
        [self removeNextAllTableView:currentTableViewTag];
        [self addTableView];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self scrollToNextTableView:currentTableViewTag];
            if ([self.delegate respondsToSelector:@selector(selectedLocationName:tag:)]) {
                [self.delegate selectedLocationName:cellModel.name tag:currentTableViewTag];
            }
        });
    }else {
        if ([self.delegate respondsToSelector:@selector(selectedLastLocationName:lastTag:)]) {
            [self.delegate selectedLastLocationName:cellModel.name lastTag:currentTableViewTag];
        }
    }
    
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    //将刚才选的地区取消选择及效果
    NSInteger currentTableViewTag = tableView.tag;
    CLModel *cellModel;
    
    if (currentTableViewTag == 0 ) { //省
        cellModel = self.provinceModels[indexPath.row];
    }else if (currentTableViewTag == 1) { //市
        cellModel = self.cityModels[indexPath.row];
    }else if (currentTableViewTag == 2) { //区
        cellModel = self.districtModels[indexPath.row];
    }else if (currentTableViewTag == 3) { //街道
        cellModel = self.streetModels[indexPath.row];
    }
    
    cellModel.isSelected = NO;
    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

#pragma mark - data
- (void)parseCityModelsFromSelectedProvince:(NSInteger)provinceIndex {
    CLModel *provinceModel = self.provinceModels[provinceIndex];
    //NSLog(@"%@",provinceModel.name);
    self.cityModels = provinceModel.models;
}
- (void)parseDistrictModelsFromSelectedCity:(NSInteger)cityIndex {
    CLModel *cityModel = self.cityModels[cityIndex];
    //NSLog(@"%@",cityModel.name);
    self.districtModels = cityModel.models;
}
- (void)parseStreetModelsFromSelectedDistrict:(NSInteger)districtIndex {
    CLModel *districtModel = self.districtModels[districtIndex];
    //NSLog(@"%@",districtModel.name);
    self.streetModels = districtModel.models;
}
@end
