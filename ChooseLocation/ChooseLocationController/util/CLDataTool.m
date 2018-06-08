//
//  CLDataTool.m
//  CheFu365
//
//  Created by safiri on 2018/4/19.
//  Copyright © 2018年 safiri. All rights reserved.
//

#import "CLDataTool.h"

@implementation CLDataTool

/// for pcas-code.json  pca-code.json
+ (void)parseContainCodeDataFromJson:(void(^)(BOOL finish, NSArray <CLModel *>* locationCLModels))complete {
    
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
        NSString *jsonPath = [[NSBundle mainBundle] pathForResource:@"pca-code" ofType:@"json"];
        NSData *data = [NSData dataWithContentsOfFile:jsonPath];
        NSError *error;
        BOOL finish = YES;
        NSArray *jsonObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
        if (error) finish = NO;
        NSArray *locationCLModels = [CLDataTool parseDataArray:jsonObject];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (complete) {
                complete(finish, locationCLModels);
            }
        });
    });
}

/// for pac.json
+ (void)parseNoCodeDataFromJson:(void(^)(BOOL finish, NSArray <CLModel *>* locationCLModels))complete {
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
        NSString *jsonPath = [[NSBundle mainBundle] pathForResource:@"pca" ofType:@"json"];
        NSData *data = [NSData dataWithContentsOfFile:jsonPath];
        NSError *error;
        BOOL finish = YES;
        NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
        if (error) finish = NO;
        NSArray *locationCLModels = [CLDataTool parseDataDic:jsonObject];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (complete) {
                complete(finish, locationCLModels);
            }
        });
    });
}

+ (NSArray <CLModel *>*)parseDataArray:(NSArray *)dicArray {
    NSMutableArray *array = [NSMutableArray array];
    for (NSInteger i = 0; i < dicArray.count; i++) {
        NSDictionary *dic = dicArray[i];
        CLModel *model = [[CLModel alloc] init];
        model.name = dic[@"name"];
        //model.code = dic[@"code"];
        model.tag = i;
        model.models = [self parseDataArray:dic[@"children"]];
        [array addObject:model];
    }
    return array;
}

+ (NSArray <CLModel *>*)parseDataDic:(id)parJson {
    NSArray *keyNameArray;
    if ([parJson isKindOfClass:NSDictionary.class]) {
        keyNameArray = [parJson allKeys];
        NSMutableArray *array = [NSMutableArray array];
        for (NSInteger i = 0; i < keyNameArray.count; i++) {
            NSString *keyName = keyNameArray[i];
            CLModel *model = [[CLModel alloc] init];
            model.name = keyName;
            //model.code = dic[@"code"];
            model.tag = i;
            model.models = [self parseDataDic:parJson[keyName]];
            [array addObject:model];
        }
        return array;
    }else if ([parJson isKindOfClass:NSArray.class]) {
        keyNameArray = parJson;
        NSMutableArray *array = [NSMutableArray array];
        for (NSInteger i = 0; i < keyNameArray.count; i++) {
            NSString *keyName = keyNameArray[i];
            CLModel *model = [[CLModel alloc] init];
            model.name = keyName;
            //model.code = dic[@"code"];
            model.tag = i;
            [array addObject:model];
        }
        return array;
    }else {
        return nil;
    }
    
    
}
@end
