//
//  UICollectionView+XWWidget.h
//  
//
//  Created by 王剑石 on 16/12/18.
//  Copyright © 2016年 王剑石. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XWWidget.h"

@interface UICollectionView (XWWidget)

/**
 刷新所有部件
 */
-(void) xw_reloadWidgets;

/**
 刷新部件
 */
-(void) xw_reloadWidget:(XWWidget *)widget;

/**
 添加一个部件
 */
- (void)xw_addWidget:(XWWidget *) widget;

/**
 插入一个部件
 */
- (void)xw_insertWidget:(XWWidget *) widget atIndex:(NSUInteger)index ;

/**
 删除一个部件
 */
- (void)xw_removeWidget:(XWWidget *) widget;

/**
 删除所有部件
 */
- (void)xw_removeAllWidgets;

/**
 头部刷新
 */
-(void)xw_collectionViewHeaderRefresh;

/**
 加载更多
 */
-(void)xw_collectionViewFooterRefresh;

/**
 加载结束
 */
-(void)xw_endRefreshingWithWidgetState:(XWWidgetState)state;

@end
