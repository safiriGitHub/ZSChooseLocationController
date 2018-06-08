//
//  ZSChooseLocationPicker.m
//  CheFu365
//
//  Created by safiri on 2018/5/4.
//  Copyright © 2018年 safiri. All rights reserved.
//

#import "ZSChooseLocationPicker.h"
#import "CLConfigs.h"

@interface ZSChooseLocationPicker() <UIPickerViewDelegate, UIPickerViewDataSource>

/// 顶部视图
@property (nonatomic ,weak) UIView *topTitleView;
/// 取消按钮
@property (nonatomic, weak) UIButton *cancelButton;
/// 确定按钮
@property (nonatomic, weak) UIButton *confirmButton;
/// pickView
@property (nonatomic ,weak) UIPickerView *pickView;

/// province models
@property (nonatomic ,strong) NSArray <CLModel *>* provinceModels;
/// city models
@property (nonatomic ,strong) NSArray <CLModel *>*cityModels;
/// district models
@property (nonatomic ,strong) NSArray <CLModel *>*districtModels;
/// street models
@property (nonatomic ,strong) NSArray <CLModel *>*streetModels;

@property (nonatomic ,assign) NSInteger provinceSelectedRow;
@property (nonatomic ,assign) NSInteger citySelectedRow;
@property (nonatomic ,assign) NSInteger districtSelectedRow;
@property (nonatomic ,assign) NSInteger streetSelectedRow;
@end

@implementation ZSChooseLocationPicker
{
    NSString *_selectedProvinceTitle;
    NSString *_selectedCityTitle;
    NSString *_selectedDistrictTitle;
    NSString *_selectedStreetTitle;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.lastLocationLevelTag = LocationLevelDistrict;
        [self initSubViews];
    }
    return self;
}

#pragma mark - - parse data
- (void)parseAndShowDefaultData {
    //show hud
    [CLDataTool parseContainCodeDataFromJson:^(BOOL finish, NSArray<CLModel *> *locationCLModels) {
        // hide hud
        if (finish) {
            [self showLocationData:locationCLModels];
        }
    }];
    //    [CLDataTool parsePCADataFromJson:^(BOOL finish, NSArray<CLModel *> *locationCLModels) {
    //        if (finish) {
    //            [self.clSelectView showLocation:locationCLModels];
    //        }
    //    }];
}
- (void)showLocationData:(NSArray <CLModel *>*)clModels {
    
    if (self.lastLocationLevelTag >= LocationLevelProvince) {
        self.provinceModels = clModels;
    }
    if (self.lastLocationLevelTag >= LocationLevelCity) {
        [self parseCityModelsFromSelectedProvince:0];
    }
    if (self.lastLocationLevelTag >= LocationLevelDistrict) {
        [self parseDistrictModelsFromSelectedCity:0];
    }
    
    [self.pickView reloadAllComponents];
}
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
- (void)setProvinceSelectedRow:(NSInteger)provinceSelectedRow {
//    if (_provinceSelectedRow != provinceSelectedRow) {
//
//    }
    [self parseCityModelsFromSelectedProvince:provinceSelectedRow];
    _provinceSelectedRow = provinceSelectedRow;
}
- (void)setCitySelectedRow:(NSInteger)citySelectedRow {
//    if (_citySelectedRow != citySelectedRow) {
//
//    }
    [self parseDistrictModelsFromSelectedCity:citySelectedRow];
    _citySelectedRow = citySelectedRow;
}
- (void)setDistrictSelectedRow:(NSInteger)districtSelectedRow {
//    if (_districtSelectedRow != districtSelectedRow) {
//
//    }
    [self parseStreetModelsFromSelectedDistrict:districtSelectedRow];
    _districtSelectedRow = districtSelectedRow;
}
#pragma mark - - UIPickerViewDelegate,UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return self.lastLocationLevelTag + 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (component == LocationLevelProvince) {
        return self.provinceModels.count;
    }else if (component == LocationLevelCity) {
        return self.cityModels.count;
    }else if (component == LocationLevelDistrict) {
        return self.districtModels.count;
    }else if (component == LocationLevelStreet) {
        return self.streetModels.count;
    }
    return 0;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    CLModel *model;
    if (component == LocationLevelProvince) {
        model = self.provinceModels[row];
    }else if (component == LocationLevelCity) {
        model = self.cityModels[row];
    }else if (component == LocationLevelDistrict) {
        model = self.districtModels[row];
    }else if (component == LocationLevelStreet) {
        model = self.streetModels[row];
    }
    if (model) return model.name;
    return @"";
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (component == LocationLevelProvince) {
        self.provinceSelectedRow = row;
        self.citySelectedRow = 0;
        self.districtSelectedRow = 0;
        self.streetSelectedRow = 0;
    }else if (component == LocationLevelCity) {
        self.citySelectedRow = row;
        self.districtSelectedRow = 0;
        self.streetSelectedRow = 0;
    }else if (component == LocationLevelDistrict) {
        self.districtSelectedRow = row;
        self.streetSelectedRow = 0;
    }else if (component == LocationLevelStreet) {
        self.streetSelectedRow = row;
    }
    for (NSInteger i = component; i < self.lastLocationLevelTag; i++) {
        [pickerView selectRow:0 inComponent:i+1 animated:NO];
    }
    [pickerView reloadAllComponents];
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    return self.frame.size.width / (self.lastLocationLevelTag + 1);
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    
    UILabel *pickerLabel = (UILabel *)view;
    if (!pickerLabel){
        pickerLabel = [[UILabel alloc] init];
        pickerLabel.adjustsFontSizeToFitWidth = YES;
        [pickerLabel setTextAlignment:NSTextAlignmentCenter];
        [pickerLabel setBackgroundColor:[UIColor clearColor]];
        [pickerLabel setFont:_titleFont ? _titleFont : [UIFont systemFontOfSize:14]];
    }
    pickerLabel.text = [self pickerView:pickerView titleForRow:row forComponent:component];
    return pickerLabel;
}

#pragma mark - - set
- (void)setPickViewBackgroundColor:(UIColor *)pickViewBackgroundColor {
    self.pickView.backgroundColor = pickViewBackgroundColor;
}

- (void)setTopViewBackgroundColor:(UIColor *)topViewBackgroundColor {
    self.topTitleView.backgroundColor = topViewBackgroundColor;
}

- (void)setCancelBtnTitleColor:(UIColor *)cancelBtnTitleColor {
    [self.cancelButton setTitleColor:cancelBtnTitleColor forState:UIControlStateNormal];
}

- (void)setConfirmBtnTitleColor:(UIColor *)confirmBtnTitleColor {
    [self.confirmButton setTitleColor:confirmBtnTitleColor forState:UIControlStateNormal];
}

#pragma mark - - UI

- (void)initSubViews {
    UIView *topTitleView = [[UIView alloc] init];
    [self addSubview:topTitleView];
    self.topTitleView = topTitleView;
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:LocationTextNormalColor forState:UIControlStateNormal];
    [cancelBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [cancelBtn addTarget:self action:@selector(cancelButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [topTitleView addSubview:cancelBtn];
    self.cancelButton = cancelBtn;
    
    UIButton *confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [confirmBtn setTitle:@"确定" forState:UIControlStateNormal];
    [confirmBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [confirmBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [confirmBtn addTarget:self action:@selector(confirmButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [topTitleView addSubview:confirmBtn];
    self.confirmButton = confirmBtn;
    
    UIPickerView *pickView = [[UIPickerView alloc] init];
    pickView.delegate = self;
    pickView.dataSource = self;
    pickView.backgroundColor = [UIColor colorWithRed:244.0/255 green:244.0/255 blue:244.0/255 alpha:1];
    [self addSubview:pickView];
    self.pickView = pickView;
}
- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat width = self.bounds.size.width;
    CGFloat height = self.bounds.size.height;
    CGFloat topViewHeight = 44;
    CGFloat btnWidth = 60;
    
    self.topTitleView.frame = CGRectMake(0, 0, width, topViewHeight);
    self.cancelButton.frame = CGRectMake(0, 0, btnWidth, topViewHeight);
    self.confirmButton.frame = CGRectMake(width - btnWidth, 0, btnWidth, topViewHeight);
    self.pickView.frame = CGRectMake(0, topViewHeight, width, height - topViewHeight);
    
}

- (void)cancelButtonClicked {
    if (self.pickViewDelegate && [self.pickViewDelegate respondsToSelector:@selector(cancelChoosePicker)]) {
        [self.pickViewDelegate cancelChoosePicker];
    }
    if ([self.pickViewDelegate respondsToSelector:@selector(dismissChoosPicker)]) {
        [self.pickViewDelegate dismissChoosPicker];
    }
}

- (void)confirmButtonClicked {
    if (self.lastLocationLevelTag >= LocationLevelProvince) {
        _selectedProvinceTitle = [self pickerView:_pickView titleForRow:_provinceSelectedRow forComponent:0];
    }
    if (self.lastLocationLevelTag >= LocationLevelCity) {
        _selectedCityTitle = [self pickerView:_pickView titleForRow:_citySelectedRow forComponent:1];
    }
    if (self.lastLocationLevelTag >= LocationLevelDistrict) {
        _selectedDistrictTitle = [self pickerView:_pickView titleForRow:_districtSelectedRow forComponent:2];
    }
    if (self.lastLocationLevelTag >= LocationLevelStreet) {
        _selectedStreetTitle = [self pickerView:_pickView titleForRow:_streetSelectedRow forComponent:3];
    }
    
    if (self.pickViewDelegate && [self.pickViewDelegate respondsToSelector:@selector(confirmSelectedAreaResultWithProvince:city:district:)]) {
        [self.pickViewDelegate confirmSelectedAreaResultWithProvince:_selectedProvinceTitle city:_selectedCityTitle district:_selectedDistrictTitle];
    }
    
    if ([self.pickViewDelegate respondsToSelector:@selector(dismissChoosPicker)]) {
        [self.pickViewDelegate dismissChoosPicker];
    }
}
@end
