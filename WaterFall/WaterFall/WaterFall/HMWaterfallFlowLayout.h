//
//  HMWaterfallFlowLayout.h
//  A03-瀑布流
//
//  Created by chao on 15/10/25.
//  Copyright © 2015年 chao. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HMWaterfallFlowLayout;
@protocol HMWaterfallFlowLayoutDelegate <NSObject>
@required
// 返回cell的高
- (CGFloat)waterfallFlowLayout:(HMWaterfallFlowLayout *)flowLayout heightForCellWidth:(CGFloat)cellWidth indexPath:(NSIndexPath *)indexPath;

@end
@interface HMWaterfallFlowLayout : UICollectionViewFlowLayout

@property (nonatomic, weak) id<HMWaterfallFlowLayoutDelegate> delegate;
// 列数
@property (nonatomic, assign) NSInteger columensCount;
@end
