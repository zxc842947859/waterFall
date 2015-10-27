//
//  HMWaterfallFlowLayout.m
//  A03-瀑布流
//
//  Created by chao on 15/10/25.
//  Copyright © 2015年 chao. All rights reserved.
//

#import "HMWaterfallFlowLayout.h"

@interface HMWaterfallFlowLayout ()
/** 这个字典用来记录每一列最大的Y值 */
@property (nonatomic, strong) NSMutableDictionary *maxYdict;
/** 存放所有cell的布局属性 */
@property (nonatomic, strong) NSMutableArray *attrsArrM;
@end
@implementation HMWaterfallFlowLayout


// collectionVIew将要显示时准备布局,每当布局更新时,调用该方法做布局前的准备
- (void)prepareLayout {
    [super prepareLayout];
    
    // 1> 给保存最高列的数组赋值默认值
    for (NSInteger i = 0; i < self.columensCount; ++i) {
        // 列号
        NSString *columu = [NSString stringWithFormat:@"%zd", i];
        // 默认每列的最大Y为顶部间距
        self.maxYdict[columu] = @(self.sectionInset.top);
    }
    
    // 2> 计算所有cell布局属性的frame
    // 清空保存所有cell布局属性的数组
    [self.attrsArrM removeAllObjects];
    // 获取当前cell的数量
    NSInteger cellCount = [self.collectionView numberOfItemsInSection:0];
    for (NSInteger i = 0; i < cellCount; ++i) {
        // 创建每一个cell的索引
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        // 创建指定索引cell的布局属性
        UICollectionViewLayoutAttributes *attr = [self layoutAttributesForItemAtIndexPath:indexPath];
        // 把每一个cell的布局属性添加到数组
        [self.attrsArrM addObject:attr];
    }
    
    // 创建footerView的布局属性
    NSIndexPath *footerPath = [NSIndexPath indexPathForItem:0 inSection:0];
    UICollectionViewLayoutAttributes *footerAttr = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionFooter withIndexPath:footerPath];
    footerAttr.frame = CGRectMake(0, [self.maxYdict[self.maxColumn] floatValue] + self.minimumLineSpacing, self.collectionView.bounds.size.width, self.footerReferenceSize.height);
    [self.attrsArrM addObject:footerAttr];
}

// 自定义布局时一定要实现此方法来返回collectionView的contentSize,内容尺寸,collectionView的滚动范围
- (CGSize)collectionViewContentSize {

    return CGSizeMake(0, [self.maxYdict[self.maxColumn] floatValue] + self.footerReferenceSize.height + self.minimumLineSpacing);
}

// 返回最高列的列号
- (NSString *)maxColumn {
    // 找出最长的那一列
    // 假设最长的那一列是第0列
    __block NSString *maxColumn = @"0";
    [self.maxYdict enumerateKeysAndObjectsUsingBlock:^(NSString * column, NSNumber *maxY, BOOL * _Nonnull stop) {
        // 如果当前列比上之前的列长记录当前最长的列号
        if ([maxY floatValue] > [self.maxYdict[maxColumn] floatValue]) {
            maxColumn = column;
        }
    }];
    return maxColumn;
}
// 返回最短列的列号
- (NSString *)minColumn {
    // 找出最短的那一列
    // 假设最短的那一列是第0列
    __block NSString *minColumn = @"0";
    [self.maxYdict enumerateKeysAndObjectsUsingBlock:^(NSString * column, NSNumber *maxY, BOOL * _Nonnull stop) {
        // 如果当前列比上之前的列短记录当前最短的列号
        if ([maxY floatValue] < [self.maxYdict[minColumn] floatValue]) {
            minColumn = column;
        }
    }];
    return minColumn;
}

// 创建指定索引的cell的布局属性
- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    // 1> 计算cell的尺寸
    CGFloat cellWidth = (self.collectionView.bounds.size.width - self.sectionInset.left - self.sectionInset.right - (self.columensCount - 1) * self.minimumInteritemSpacing) / self.columensCount;
    CGFloat cellHeigth = [self.delegate waterfallFlowLayout:self heightForCellWidth:cellWidth indexPath:indexPath];

    // 2> 计算cell的位置
    // 取出最短列的列号
    NSString *minColumn = [self minColumn];
    CGFloat cellX = self.sectionInset.left + (cellWidth + self.minimumInteritemSpacing) * [minColumn integerValue];
    CGFloat cellY = [self.maxYdict[minColumn] floatValue] + self.minimumLineSpacing;
    
    // 更新这一列的最大Y值
    self.maxYdict[minColumn] = @(cellY + cellHeigth);
    // 创建cell的布局属性
    UICollectionViewLayoutAttributes *attr = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    attr.frame = CGRectMake(cellX, cellY, cellWidth, cellHeigth);
    return attr;
}


// 返回collectionView内所的视图的布局属性
- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    return self.attrsArrM;
}


#pragma mark - 懒加载
- (NSMutableDictionary *)maxYdict {
    if (_maxYdict == nil) {
        _maxYdict = [NSMutableDictionary dictionaryWithCapacity:self.columensCount];
    }
    return _maxYdict;
}

- (NSMutableArray *)attrsArrM {
    if (_attrsArrM == nil) {
        _attrsArrM = [NSMutableArray array];
    }
    return _attrsArrM;
}
@end
