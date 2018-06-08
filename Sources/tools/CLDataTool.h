//
//  CLDataTool.h
//  CheFu365
//
//  Created by safiri on 2018/4/19.
//  Copyright © 2018年 safiri. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CLModel.h"

@interface CLDataTool : NSObject

+ (void)parseContainCodeDataFromJson:(void(^)(BOOL finish, NSArray <CLModel *>* locationCLModels))complete;
+ (void)parseNoCodeDataFromJson:(void(^)(BOOL finish, NSArray <CLModel *>* locationCLModels))complete;

@end
