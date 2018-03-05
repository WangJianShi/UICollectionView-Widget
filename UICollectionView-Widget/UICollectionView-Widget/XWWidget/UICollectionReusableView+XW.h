//
//  UICollectionReusableView+XW.h
//  
//
//  Created by 王剑石 on 16/12/16.
//  Copyright © 2016年 王剑石. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UICollectionReusableView (XW)

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
@property (nonatomic, strong)   UICollectionView * xw_collectionView;

/**
 是否是header（YES-header,NO-footer）
 */
@property (nonatomic, assign) BOOL bHeader;

/**
 数据和视图绑定的回调方法 需要重写
 重写需要调用父类改方法
 */
- (void)reuseWithData:(NSObject *)data indexPath:(NSIndexPath *)indexPath isHeader:(BOOL)bHeader  NS_REQUIRES_SUPER;

/**
 如果重写了就不要调用[super view_size];
 @return 返回view的size
 */
- (CGSize)view_size;


@end
