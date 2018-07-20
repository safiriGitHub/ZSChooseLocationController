//
//  CLSelectViewCell.m
//  ChooseLocation
//
//  Created by safiri on 2018/4/20.
//  Copyright © 2018年 HY. All rights reserved.
//

#import "CLSelectViewCell.h"
#import "CLConfigs.h"

@interface CLSelectViewCell ()

@property (nonatomic ,strong) UILabel *locationLabel;

@property (nonatomic ,strong) UIImageView *selectedImageView;


@end

@implementation CLSelectViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self commonInit];
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self commonInit];
    }
    return self;
}
- (void)commonInit {
    [self.contentView addSubview:self.locationLabel];
    self.locationLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:self.selectedImageView];
    self.selectedImageView.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSLayoutConstraint *leftConstraint = [NSLayoutConstraint constraintWithItem:self.locationLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:20.0];
    [self.contentView addConstraint:leftConstraint];
    
    NSLayoutConstraint *centerYConstraint = [NSLayoutConstraint constraintWithItem:self.locationLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0.0];
    [self.contentView addConstraint:centerYConstraint];
    
    NSLayoutConstraint *heightConstraint = [NSLayoutConstraint constraintWithItem:self.locationLabel attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0.0 constant:20.0];
    [self.locationLabel addConstraint:heightConstraint];
    
    
    NSLayoutConstraint *imageCenterYConstraint = [NSLayoutConstraint constraintWithItem:self.selectedImageView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0.0];
    [self.contentView addConstraint:imageCenterYConstraint];
    
    NSLayoutConstraint *imageWidthConstraint = [NSLayoutConstraint constraintWithItem:self.selectedImageView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0.0 constant:24.0];
    [self.selectedImageView addConstraint:imageWidthConstraint];
    
    NSLayoutConstraint *imageHeightConstraint = [NSLayoutConstraint constraintWithItem:self.selectedImageView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0.0 constant:24.0];
    [self.selectedImageView addConstraint:imageHeightConstraint];
    
    NSLayoutConstraint *imageLeftConstraint = [NSLayoutConstraint constraintWithItem:self.selectedImageView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.locationLabel attribute:NSLayoutAttributeRight multiplier:1.0 constant:0.0];
    [self.contentView addConstraint:imageLeftConstraint];
}

- (void)refreshCell:(CLModel *)model {
    self.locationLabel.text = model.name;
    self.locationLabel.textColor = model.isSelected ? LocationTextSelectedColor : LocationTextNormalColor;
    self.selectedImageView.hidden = !model.isSelected;
}

static NSString *const cellIdentifier = @"CLSelectViewCell";
+ (void)registerCellWithTableView:(UITableView *)tableView {
    //[tableView registerNib:[UINib nibWithNibName:cellIdentifier bundle:nil] forCellReuseIdentifier:cellIdentifier];
    [tableView registerClass:[self class] forCellReuseIdentifier:cellIdentifier];
}
+ (instancetype)cellWithTableView:(UITableView *)tableView forIndexPath:(NSIndexPath *)indexPath{
    CLSelectViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    //cell设置
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (UIImageView *)selectedImageView {
    if (!_selectedImageView) {
        _selectedImageView = [[UIImageView alloc] init];
        NSString *imgFile = [CLDataTool getPathFromZSChooseLocationBundleForResource:@"cl_selected@2x" ofType:@"png" inDirectory:@"Image"];
        _selectedImageView.image = [UIImage imageWithContentsOfFile:imgFile];
    }
    return _selectedImageView;
}
- (UILabel *)locationLabel {
    if (!_locationLabel) {
        _locationLabel = [[UILabel alloc] init];
        _locationLabel.textColor = [UIColor colorWithRed:99/255.0 green:99/255.0 blue:99/255.0 alpha:1];
        _locationLabel.font = [UIFont systemFontOfSize:14];
    }
    return _locationLabel;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
