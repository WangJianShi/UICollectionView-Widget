//
//  UICollectionViewCell+XW.h
//  
//
//  Created by 王剑石 on 16/12/16.
//  Copyright © 2016年 王剑石. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UICollectionViewCell (XW)

/**
 数据源
 */
@property (nonatomic, strong) NSObject * xw_data;

/**
 视图所对应的indexPath
 */
@property (nonatomic, strong) NSIndexPath * xw_indexPath;

/**
 视图所在的collectionView
 */
@property (nonatomic, strong) UICollectionView * xw_collectionView;

/**
 cell分割线
 */
@property (nonatomic, assign) UIEdgeInsets  separatorInset;

/**
 cell分割线颜色（默认）
 */
@property (nonatomic, strong) UIColor *separatorColor;

/**
 数据和视图绑定的回调方法 需要重写
 重写需要调用父类改方法
 @param data      视图数据
 @param indexPath 视图所在位置
 */
- (void)reuseWithData:(NSObject *)data indexPath:(NSIndexPath *)indexPath NS_REQUIRES_SUPER;

/**
 *  如果重写了就不要调用[super cell_size];
 *  @return 返回view的size
 */
- (CGSize)cell_size;

#pragma mark -
#pragma mark - UICollectionViewDelegate callback

- (void)xw_didSelectCell;

- (void)xw_didDeselectCell;

- (void)xw_willDisplayCell;

- (BOOL)xw_shouldSelectCell;

- (BOOL)xw_shouldDeselectCell;

- (BOOL)xw_shouldHighlightCell;

- (void)xw_didHighlightCell;

- (void)xw_didUnhighlightCell;

@end





