//
//  HMShopCell.m
//  A03-瀑布流
//
//  Created by chao on 15/10/25.
//  Copyright © 2015年 chao. All rights reserved.
//

#import "HMShopCell.h"
#import "HMShop.h"

@interface HMShopCell ()
@property (weak, nonatomic) IBOutlet UIImageView *shopImage;
@property (weak, nonatomic) IBOutlet UILabel *priceView;

@end
@implementation HMShopCell

- (void)awakeFromNib {
    self.layer.cornerRadius = 1;
    self.clipsToBounds = YES;
}
- (void)setShop:(HMShop *)shop {
    _shop = shop;
    self.shopImage.image = [UIImage imageNamed:shop.icon];
    self.priceView.text = shop.price;
}

@end
