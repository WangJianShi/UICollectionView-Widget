//
//  UICollectionView+XW.h
//  XWNewWidgetDemo
//
//  Created by serein on 2017/11/7.
//  Copyright © 2017年 wangjianshi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "XWWeakObject.h"

@protocol XWCollectionViewDataSource;


@interface UICollectionView (XW)

/**
 数据源和代理对象
 */
@property (nonatomic, strong) id<XWCollectionViewDataSource> xw_dataSource;

/**
 代理对象
 */
@property (nonatomic, strong) id<UICollectionViewDelegate> xw_delegate;

/**
 代理对象---支持多代理（代理转发机制）
 */
@property (nonatomic, strong) XWWeakMutableArray<UICollectionViewDelegate> *xw_delegates;

/**
 便利构造, 默认流布局
 */
+ (instancetype)createWithFlowLayout;

/**
 便利构造, 头部悬浮样式
 */
+(instancetype)createWithStyleGrouped;

/**
 便利构造, 头部拉伸
 */
+(instancetype)createWithStretchyHeaderSize:(CGSize )headerSize;

/**
 便利构造, 自定义样式
 */
+ (instancetype)createWithLayout:(UICollectionViewLayout *)layout;


@end


#pragma mark -
#pragma mark - cell注册
@interface UICollectionView (XWRegister)

@property (nonatomic, strong) NSMutableDictionary *cacheStaticDic;

-(UICollectionViewCell *)dequeueReusableCellWithIdentify:(NSString *)identify indexPath:(NSIndexPath *)indexPath reusable:(BOOL )reusable;

-(UICollectionReusableView *)dequeueReusableView:(NSString *)identify indexPath:(NSIndexPath *)indexPath kind:(NSString *)kind reusable:(BOOL )reusable;

-(UICollectionViewCell *)getStaticReusableCell:(NSString *)identify;

-(UICollectionReusableView *)getStaticReusableView:(NSString *)identify kind:(NSString *)kind;

@end


#pragma mark -
#pragma mark - collectionview数据源
@protocol XWCollectionViewDataSource <NSObject>

@required
/**
 cell数据源
 */
- (NSMutableArray *)cellDataListWithCollectionView:(UICollectionView *)collectionView;
@optional
/**
 头部数据源
 */
- (NSMutableArray *)headerDataListWithCollectionView:(UICollectionView *)collectionView;
/**
 尾部数据源
 */
- (NSMutableArray *)footerDataListWithCollectionView:(UICollectionView *)collectionView;
/**
 每个secion对应的修饰背景view
 */
- (NSMutableArray<Class> *)decorationViewClassListWithCollectionView:(UICollectionView *)collectionView;

@end;


