//
//  XWWeakObject.h
//  
//
//  Created by 王剑石 on 2017/8/19.
//  Copyright © 2017年 wangjianshi. All rights reserved.
//

#import <Foundation/Foundation.h>

#pragma mark -
#pragma mark - 内置weak对象（可用于分类定义weak属性）
@interface XWWeakObject : NSObject

@property (nullable, nonatomic, weak, readonly) id weakObject;

- (instancetype _Nullable )initWeakObject:(id _Nullable )obj;

+ (instancetype _Nullable )proxyWeakObject:(id _Nullable )obj;

@end


#pragma mark -
#pragma mark - 线程安全和内置weak子元素
@interface XWWeakMutableArray : NSMutableArray

@end
