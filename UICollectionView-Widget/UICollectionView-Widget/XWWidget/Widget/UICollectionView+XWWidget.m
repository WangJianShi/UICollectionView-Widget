//
//  UICollectionView+XWWidget.m
//  
//
//  Created by 王剑石 on 16/12/18.
//  Copyright © 2016年 王剑石. All rights reserved.
//

#import "UICollectionView+XWWidget.h"
#import <objc/runtime.h>
#import "UICollectionView+XW.h"

@interface UICollectionView ()

@property (nonatomic, strong)  NSMutableArray * xw_headerDataList;
@property (nonatomic, strong)  NSMutableArray * xw_cellDataList;
@property (nonatomic, strong)  NSMutableArray * xw_footerDataList;
@property (nonatomic , strong) NSMutableArray * xw_decorationViewClassList;
//@property (nonatomic , strong) NSMutableArray * xw_oldSectionList;

@property(nonatomic, strong) NSMutableArray *xw_widgets;

@end

@implementation UICollectionView (XWWidget)


#pragma mark - XWCollectionViewDataSource

- (NSMutableArray *)headerDataListWithCollectionView:(UICollectionView *) collectionView{
    return self.xw_headerDataList;
}

- (NSMutableArray *)cellDataListWithCollectionView:(UICollectionView *) collectionView{
    return self.xw_cellDataList;
}

- (NSMutableArray *)footerDataListWithCollectionView:(UICollectionView *) collectionView{
    return self.xw_footerDataList;
}

- (NSMutableArray<Class> *)decorationViewClassListWithCollectionView:(UICollectionView *)collectionView{
    return self.xw_decorationViewClassList;
}

#pragma mark - public

-(void) xw_reloadWidgets{
    
    [self.xw_headerDataList removeAllObjects];
    [self.xw_cellDataList removeAllObjects];
    [self.xw_footerDataList removeAllObjects];
    [self.xw_decorationViewClassList removeAllObjects];
    for (XWWidget * widget in self.xw_widgets) {
        [self.xw_headerDataList addObjectsFromArray:widget.headerDataList];
        [self.xw_cellDataList addObjectsFromArray:widget.multiCellDataList];
        [self.xw_footerDataList addObjectsFromArray:widget.footerDataList];
        [self.xw_decorationViewClassList addObjectsFromArray:widget.decorationViewClassList];
    }
    
    self.xw_dataSource = (id<XWCollectionViewDataSource>)self;
    dispatch_async(dispatch_get_main_queue(),^{
        [UIView performWithoutAnimation:^{
            //刷新界面
            [CATransaction begin];
            [CATransaction setDisableActions:YES];
            [self reloadData];
            [CATransaction commit];
        }];
        
    });
    
}

-(void) xw_reloadWidget:(XWWidget *)widget{
    
    [self xw_reloadWidgets];
}


- (void)xw_addWidget:(XWWidget *) widget{
    NSUInteger index = self.xw_widgets.count;
    [self xw_insertWidget:widget atIndex:index];
}

- (void)xw_insertWidget:(XWWidget *) widget atIndex:(NSUInteger)index {
    if ([widget isKindOfClass:[XWWidget class]] && self.xw_widgets.count <= index) {
        if ([self xw_containWidget:widget] == false) {
            [widget setValue:self forKey:@"collectionView"];
            [self.xw_widgets insertObject:widget atIndex:index];
            [self xw_delayReload];
        }
    }
}

- (void)xw_removeWidget:(XWWidget *) widget{
    if ([self.xw_widgets containsObject:widget]) {
        [self.xw_widgets removeObject:widget];
        [self xw_delayReload];
    }
}

- (void)xw_removeAllWidgets{
    if (self.xw_widgets.count) {
        [self.xw_widgets removeAllObjects];
        [self xw_delayReload];
    }
}

- (BOOL)xw_containWidget:(XWWidget *)widget{
    return [self.xw_widgets containsObject:widget];
}


- (BOOL)xw_containWidgetClass:(Class) widgetClass{
    for (XWWidget * sub in self.xw_widgets) {
        if ([sub isMemberOfClass:widgetClass]) {
            return true;
        }
    }
    return false;
}


-(void)xw_collectionViewHeaderRefresh{
    
    for (XWWidget * widget in self.xw_widgets) {
        [widget setValue:@(true) forKey:@"needRequest"];
        [widget requestHeaderRefresh];
    }
}


-(void)xw_collectionViewFooterRefresh{
    for (XWWidget * widget in self.xw_widgets) {
        [widget setValue:@(true) forKey:@"needRequest"];
        [widget requestFooterRefresh];
    }
}


-(void)xw_endRefreshingWithWidgetState:(XWWidgetState)state{
    
}

/**
 *  请求数据完毕时回调
 */
- (void)xw_requestFinish{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(reloadAllWidgetsIfNeed) object:nil];
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(reloadData) object:nil];
    //    [self performSelectorOnMainThread:@selector(reloadAllWidgetsIfNeed) withObject:nil waitUntilDone:YES];
    [self performSelector:@selector(reloadAllWidgetsIfNeed) withObject:nil afterDelay:0];
    
    
}

-(void)reloadAllWidgetsIfNeed{
    BOOL need = true;
    for (XWWidget * widget in self.xw_widgets) {
        if (widget.state == XWWidgetStateRequsting) {
            need = false;
            break;
        }
    }
    if (need) {
        
        [self xw_reloadWidgets];
        [self xw_endRefreshingWithWidgetState:self.xw_state];

    }
}


#pragma mark - private

-(void) xw_delayReload{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(xw_reloadWidgets) object:nil];
    [self performSelector:@selector(xw_reloadWidgets) withObject:nil afterDelay:0];
}


#pragma mark - getter setter

- (XWWidgetState)xw_state{
    XWWidgetState state = XWWidgetStateDefault;
    for (XWWidget * widget in self.xw_widgets) {
        if (widget.state == XWWidgetStateRequsting) {
            return XWWidgetStateRequsting;
        }
    }
    for (XWWidget * widget in self.xw_widgets) {
        if (widget.state == XWWidgetStateRequestNoMoreData) {
            state = XWWidgetStateRequestNoMoreData;
            break;
        }
        if (widget.state == XWWidgetStateRequestSuccess) {
            state = XWWidgetStateRequestSuccess;
        }
        if (widget.state == XWWidgetStateRequestFail && state != XWWidgetStateRequestSuccess) {
            state = XWWidgetStateRequestFail;
        }
    }
    return state;
}


- (NSMutableArray *)xw_headerDataList{
    NSMutableArray * list = objc_getAssociatedObject(self, @selector(xw_headerDataList));
    if (!list) {
        list = [NSMutableArray new];
        objc_setAssociatedObject(self, @selector(xw_headerDataList), list, OBJC_ASSOCIATION_RETAIN);
    }
    return list;
}


- (void)setXw_headerDataList:(NSMutableArray *)xw_headerDataList{
    objc_setAssociatedObject(self, @selector(xw_headerDataList), xw_headerDataList, OBJC_ASSOCIATION_RETAIN);
}

- (NSMutableArray *)xw_footerDataList{
    NSMutableArray * list = objc_getAssociatedObject(self, @selector(xw_footerDataList));
    if (!list) {
        list = [NSMutableArray new];
        objc_setAssociatedObject(self, @selector(xw_footerDataList), list, OBJC_ASSOCIATION_RETAIN);
    }
    return list;
}

- (void)setXw_footerDataList:(NSMutableArray *)xw_footerDataList{
    objc_setAssociatedObject(self, @selector(xw_footerDataList), xw_footerDataList, OBJC_ASSOCIATION_RETAIN);
}

- (NSMutableArray *)xw_cellDataList{
    NSMutableArray * list = objc_getAssociatedObject(self, @selector(xw_cellDataList));
    if (!list) {
        list = [NSMutableArray new];
        objc_setAssociatedObject(self, @selector(xw_cellDataList), list, OBJC_ASSOCIATION_RETAIN);
    }
    return list;
}

- (void)setXw_cellDataList:(NSMutableArray *)xw_cellDataList{
    objc_setAssociatedObject(self, @selector(xw_cellDataList), xw_cellDataList, OBJC_ASSOCIATION_RETAIN);
}


- (NSMutableArray *)xw_decorationViewClassList{
    NSMutableArray * list = objc_getAssociatedObject(self, @selector(xw_decorationViewClassList));
    if (!list) {
        list = [NSMutableArray new];
        objc_setAssociatedObject(self, @selector(xw_decorationViewClassList), list, OBJC_ASSOCIATION_RETAIN);
    }
    return list;
}

- (void)setXw_decorationViewClassList:(NSMutableArray *)xw_decorationViewClassList{
    objc_setAssociatedObject(self, @selector(xw_decorationViewClassList), xw_decorationViewClassList, OBJC_ASSOCIATION_RETAIN);
}


- (NSMutableArray *)xw_widgets{
    NSMutableArray * widgets = objc_getAssociatedObject(self, @selector(xw_widgets));
    if (!widgets) {
        widgets = [NSMutableArray new];
        objc_setAssociatedObject(self, @selector(xw_widgets), widgets, OBJC_ASSOCIATION_RETAIN);
    }
    return widgets;
}

- (void)setXw_widgets:(NSMutableArray *)xw_widgets{
    objc_setAssociatedObject(self, @selector(xw_widgets), xw_widgets, OBJC_ASSOCIATION_RETAIN);
}


@end
