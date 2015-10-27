//
//  HMShop.m
//  A03-瀑布流
//
//  Created by chao on 15/10/24.
//  Copyright © 2015年 chao. All rights reserved.
//

#import "HMShop.h"

@implementation HMShop
+ (instancetype)shopWithDict:(NSDictionary *)dict {
    id obj = [[self alloc] init];
    [obj setValuesForKeysWithDictionary:dict];
    return obj;
}


+ (NSArray *)shopsWithIndex:(NSInteger)index {
    NSString *dataName = [NSString stringWithFormat:@"%zd.plist", index];
    NSArray *dictArr = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:dataName ofType:nil]];
    NSMutableArray *arrM = [NSMutableArray arrayWithCapacity:dictArr.count];
    [dictArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        HMShop *shop = [HMShop shopWithDict:obj];
        [arrM addObject:shop];
    }];
    return arrM;
}
@end
