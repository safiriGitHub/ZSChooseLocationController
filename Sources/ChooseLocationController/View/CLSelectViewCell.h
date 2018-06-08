//
//  CLSelectViewCell.h
//  ChooseLocation
//
//  Created by safiri on 2018/4/20.
//  Copyright © 2018年 HY. All rights reserved.
//

#import <UIKit/UIKit.h>

#define CLSelectViewCellHeight 26
@class CLModel;
@interface CLSelectViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *locationLab;
@property (weak, nonatomic) IBOutlet UIImageView *selectedImgView;

- (void)refreshCell:(CLModel *)model;

+ (instancetype)cellWithTableView:(UITableView *)tableView forIndexPath:(NSIndexPath *)indexPath;
+ (void)registerCellWithTableView:(UITableView *)tableView;
@end
