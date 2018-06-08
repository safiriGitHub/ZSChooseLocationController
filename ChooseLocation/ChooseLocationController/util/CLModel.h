//
//  CLModel.h
//  ChooseLocation
//
//  Created by safiri on 2018/4/19.
//  Copyright © 2018年 HY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CLModel : NSObject

@property (nonatomic ,copy) NSString *name;

@property (nonatomic ,strong) NSArray <CLModel*>*models;

@property (nonatomic ,copy) NSString *code;

@property (nonatomic ,assign) NSInteger tag;

/// for cell
@property (nonatomic ,assign) BOOL isSelected;
//- (instancetype)initWithDataDictionary:(NSDictionary *)dataDic;

@end
