//
//  XWCollectionViewFlowLayout.h
//  
//
//  Created by 王剑石 on 16/12/16.
//  Copyright © 2016年 olakeji. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef NS_ENUM(NSInteger,AlignType){
    AlignWithLeft,
    AlignWithCenter,
    AlignWithRight
};

typedef enum : NSUInteger {
    XWCollectionViewFlowLayoutTypePlain,    // 普通布局
    XWCollectionViewFlowLayoutTypeStickHeader,// 头部悬浮 布局
    XWCollectionViewFlowLayoutTypeWaterfall,// 瀑布流
    XWCollectionViewFlowLayoutStretchyHeader,// 头部拉伸
    XWCollectionViewFlowLayoutHistory,// 历史标签
} XWCollectionViewFlowLayoutType;

@interface XWCollectionViewFlowLayout : UICollectionViewFlowLayout

@property(nonatomic , assign) XWCollectionViewFlowLayoutType layoutType;

@property (nonatomic,assign)AlignType cellType;

@property (nonatomic, assign) CGFloat stickExtraHeight;

@property (nonatomic, assign) BOOL decorationContainHeader;

@end
