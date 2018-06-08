//
//  CLSelectViewCell.m
//  ChooseLocation
//
//  Created by safiri on 2018/4/20.
//  Copyright © 2018年 HY. All rights reserved.
//

#import "CLSelectViewCell.h"
#import "CLConfigs.h"

@implementation CLSelectViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)refreshCell:(CLModel *)model {
    self.locationLab.text = model.name;
    self.locationLab.textColor = model.isSelected ? LocationTextSelectedColor : LocationTextNormalColor;
    self.selectedImgView.hidden = !model.isSelected;
}

static NSString *const cellIdentifier = @"CLSelectViewCell";
+ (void)registerCellWithTableView:(UITableView *)tableView {
    [tableView registerNib:[UINib nibWithNibName:cellIdentifier bundle:nil] forCellReuseIdentifier:cellIdentifier];
    //[tableView registerClass:[self class] forCellReuseIdentifier:cellIdentifier];
}
+ (instancetype)cellWithTableView:(UITableView *)tableView forIndexPath:(NSIndexPath *)indexPath{
    CLSelectViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    //cell设置
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
