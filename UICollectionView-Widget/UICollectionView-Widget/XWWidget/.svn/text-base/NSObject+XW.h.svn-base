//
//  NSObject+XW.h
//  
//
//  Created by 王剑石 on 16/12/16.
//  Copyright © 2016年 王剑石. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSObject (XW)

/**
 cell或者header,footer的高度，框架自动缓存
 */
@property (nonatomic, assign) CGFloat xw_height;

/**
 cell或者header,footer的宽度，框架自动缓存
 */
@property (nonatomic, assign) CGFloat xw_width;

/**
 cell或者header,footer的重用标识，框架自动缓存（可以为空，有默认值）
 cell的重用标识（默认数据去除Data改为Cell）
 header或者footer的重用标识 （默认数据去除Data改为View）
 */
@property (nonatomic, strong) NSString *xw_reuseIdentifier;

/**
 cell或者header,footer是否重用
 */
@property (nonatomic, assign) BOOL unReusable;

#pragma mark -
#pragma mark - 以下属性只对header或者footer生效
/**
 collectionView每个section的内边距
 */
@property(nonatomic , assign) UIEdgeInsets cell_secionInset;

/**
 collectionView每个section的边距
 */
@property(nonatomic , assign) CGFloat cell_minimumLineSpacing;

/**
 collectionView每个item的边距
 */
@property(nonatomic , assign) CGFloat cell_minimumInteritemSpacing;


@end
