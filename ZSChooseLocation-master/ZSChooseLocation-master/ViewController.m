//
//  ViewController.m
//  ZSChooseLocation-master
//
//  Created by safiri on 2018/6/8.
//  Copyright © 2018年 safiri. All rights reserved.
//

#import "ViewController.h"
#import "ZSChooseLocationController.h"
#import "ZSChooseLocationPicker.h"

@interface ViewController ()<ChooseLocationPickerDelegate, ChooseLocationDelegate>
@property (weak, nonatomic) IBOutlet UILabel *chooseResultLab;

@property (nonatomic ,strong) ZSChooseLocationPicker *choosePicker;
@property (nonatomic ,strong) ZSChooseLocationController *chooseController;
@end

@implementation ViewController

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    //[_choosePicker showLocationData:self.checkCarNewVM.choosePickerModels];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - ChooseLocationPickerDelegate
- (void)dismissChoosPicker {
    [[CLPopAnimation shareAnimation] dismissPopView];
}
- (void)confirmSelectedAreaResultWithProvince:(NSString *)provinceTitle city:(NSString *)cityTitle district:(NSString *)districtTitle {
    self.chooseResultLab.text = [NSString stringWithFormat:@"%@ %@ %@",provinceTitle,cityTitle,districtTitle];
}
#pragma mark - ChooseLocationDelegate
- (void)closeBtnClick {
    [[CLPopAnimation shareAnimation] dismissPopView];
}
- (void)finishChooseLocation:(NSString *)locationString {
    self.chooseResultLab.text = locationString;
}
#pragma mark - event response

- (IBAction)ShowZSChooseLocationPickerClick:(id)sender {
    [[CLPopAnimation shareAnimation] showDownPopView:self.choosePicker];
}
- (IBAction)ShowZSChooseLocationControllerClick:(id)sender {
    /*ex: 控制状态栏颜色
     @weakify(self);
     [[CLPopAnimation shareAnimation] setStatusBarAppearanceUpdateCallBack:^{
     @strongify(self);
     [self setNeedsStatusBarAppearanceUpdate];
     }];
     */
    //[[CLPopAnimation shareAnimation] startAnimationRootView:self.navigationController.view andPopView:self.chooseController completion:nil];
    [[CLPopAnimation shareAnimation] startAnimationRootView:self.view andPopView:self.chooseController completion:nil];
}
#pragma mark - private methods

#pragma mark - getters and setters
- (ZSChooseLocationPicker *)choosePicker {
    if (!_choosePicker) {
        _choosePicker = [[ZSChooseLocationPicker alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height, self.view.frame.size.width, 260)];
        _choosePicker.titleFont = [UIFont systemFontOfSize:15];
        _choosePicker.confirmBtnTitleColor = [UIColor blueColor];
        _choosePicker.pickViewDelegate = self;
        [_choosePicker parseAndShowDefaultData];
    }
    return _choosePicker;
}
- (ZSChooseLocationController *)chooseController {
    if (!_chooseController) {
        CGFloat height = [UIScreen mainScreen].bounds.size.height;
        _chooseController = [[ZSChooseLocationController alloc] initWithFrame:CGRectMake(0, height, self.view.frame.size.width, height * 0.75)];
        [_chooseController parseDefaultData];
        _chooseController.delegate = self;
        
    }
    return _chooseController;
}
@end
