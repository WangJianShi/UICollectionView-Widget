//
//  XWWidget.h
//
//
//  Created by 王剑石 on 16/12/18.
//  Copyright © 2016年 王剑石. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    XWWidgetStateDefault,      // 正常状态
    XWWidgetStateRequsting,   // 正在请求刷新状态
    XWWidgetStateRequestFail,  // 请求刷新失败
    XWWidgetStateRequestSuccess,// 请求刷新成功
    XWWidgetStateRequestNoMoreData// 请求刷新无更多数据状态
}   XWWidgetState;

@interface XWWidget : NSObject

@property (nonatomic , weak , readonly,nullable)  UICollectionView *collectionView;

@property (nonatomic , assign ,readonly)  XWWidgetState state; // 当前请求状态

/**
 *  一个secion时候设置
 */
@property (nonatomic , strong , nullable) NSObject * headerData; // 头部视图数据
@property (nonatomic , strong , nullable) NSMutableArray * cellDataList; // cell视图模型数组
@property (nonatomic , strong , nullable) NSObject * footerData;       // 尾部视图模型
@property (nonatomic , copy , nullable)   Class decorationViewClass; // 修视背景图类

/**
 *  多个secion时候设置
 */
@property(nonatomic , strong , nullable) NSMutableArray * headerDataList;
@property(nonatomic , strong , nullable) NSMutableArray< NSMutableArray * > * multiCellDataList;
@property(nonatomic , strong , nullable) NSMutableArray * footerDataList;
@property(nonatomic , strong , nullable) NSMutableArray<Class> * decorationViewClassList;

/**
 刷新部件
 */
-(void) xw_reloadWidget;

/**
 头部刷新请求回调 可重写
 注：如果重写了该方法不要调用[super qw_requestUpRefresh]
 */
- (void)requestHeaderRefresh;

/**
 尾部刷新请求回调 可重写
 注：如果重写了该方法不要调用[super qw_requestDropRefresh]
 */
- (void)requestFooterRefresh;

/**
 刷新请求完成调用
 @param state 请求结果
 */

-(void)requestFinishWithState:(XWWidgetState)state;

/**
 刷新请求完成 成功 调用
 */

-(void)requestSuccess;

/**
 刷新请求完成 失败 调用
 */
-(void)requestFail;

/**
 刷新请求完成 没有更多数据 （也属于成功） 调用
 */
-(void)requestNoMoreData;


@end
