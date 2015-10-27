//
//  ViewController.m
//  A03-瀑布流
//
//  Created by chao on 15/10/24.
//  Copyright © 2015年 chao. All rights reserved.
//

#import "ViewController.h"
#import "HMShop.h"
#import "HMShopCell.h"
#import "HMWaterfallFlowLayout.h"
#import "HMFooterView.h"

@interface ViewController ()<HMWaterfallFlowLayoutDelegate>
@property (nonatomic, strong) NSMutableArray *shopes;
@property (weak, nonatomic) IBOutlet HMWaterfallFlowLayout *flowLayout;
@property (nonatomic, weak) HMFooterView *footerView;
@property (nonatomic, assign) NSInteger dataIndex;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.flowLayout.minimumInteritemSpacing = 5;
    self.flowLayout.minimumLineSpacing = 5;
    
    self.flowLayout.sectionInset = UIEdgeInsetsMake(10, 0, 20, 0);
    self.collectionView.backgroundColor = [UIColor whiteColor];
    // 设置默认列数
    self.flowLayout.columensCount = 2;
    // 设置布局对象的代理
    self.flowLayout.delegate = self;
    // 加载数据
    [self loadData];
}



// 当屏幕发生旋转的时候会调用此方法,
- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    if (size.width > size.height) {
        self.flowLayout.columensCount = 4;
    } else {
        self.flowLayout.columensCount = 2;
    }
}

#pragma mark - HMWaterfallFlowLayoutDelegate
/** 计算cell的高 */
- (CGFloat)waterfallFlowLayout:(HMWaterfallFlowLayout *)flowLayout heightForCellWidth:(CGFloat)cellWidth indexPath:(NSIndexPath *)indexPath {
    HMShop *shop = self.shopes[indexPath.item];
    return shop.height / shop.width * cellWidth;
}

#pragma mark - UICollectionViewDataSource
// 返回有多少组
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

// 返回每一组有多少个Cell
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.shopes.count;
}

// 返回每一个cell
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *ID = @"shop";
    HMShopCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    cell.shop = self.shopes[indexPath.item];
    return cell;
}

// 返回footerView
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    static NSString *ID = @"footer";
    HMFooterView *footer = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:ID forIndexPath:indexPath];
    self.footerView = footer;
    return footer;
}


// 当显示footerView显示时加载数据
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    // 1> 如果当前footerView没有显示或正在加载数据时直接返回
    if (self.footerView == nil || self.footerView.activityIndicator.isAnimating) {
        return;
    }
    // 2> 当offset.y + collectionView的高 > footerView的Y时开始加载数据
    if ((scrollView.contentOffset.y + scrollView.bounds.size.height) > self.footerView.frame.origin.y) {
        // 让菊花转正
        [self.footerView.activityIndicator startAnimating];
        // 延时两秒去加载数据,模型网络
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            // 1.加载数据
            [self loadData];
            // 2.停止菊花
            [self.footerView.activityIndicator stopAnimating];
            // 3.加载完之后把属性赋为nil
            self.footerView = nil;
            // 4.刷新collectionView重新调用数据源方法和重新布局
            [self.collectionView reloadData];
        });
    }
}

// 加载数据
- (void)loadData {
    // 添加数据
    [self.shopes addObjectsFromArray:[HMShop shopsWithIndex:((self.dataIndex % 3) + 1)]];
    // 让数据索引加加
    self.dataIndex++;
    
}



#pragma mark - 懒加载
- (NSMutableArray *)shopes {
    if (_shopes == nil) {
        _shopes = [NSMutableArray array];
    }
    return _shopes;
}

@end
