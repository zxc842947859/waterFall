//
//  HMShop.h
//  A03-瀑布流
//
//  Created by chao on 15/10/24.
//  Copyright © 2015年 chao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HMShop : NSObject
@property (nonatomic, copy) NSString *icon;
@property (nonatomic, copy) NSString *price;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;


+ (instancetype)shopWithDict:(NSDictionary *)dict;
+ (NSArray *)shopsWithIndex:(NSInteger)index;
@end
