//
//  XWWidget.m
//
//
//  Created by QLX on 16/12/18.
//  Copyright © 2016年 王剑石. All rights reserved.
//


#define XWSuppressPerformSelectorLeakWarning(Stuff) \
do { \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") \
Stuff; \
_Pragma("clang diagnostic pop") \
} while (0)


#import "XWWidget.h"
#import "NSObject+XW.h"

@interface XWWidget ()

@property (nonatomic , weak , readwrite)  UICollectionView * collectionView;
@property(nonatomic , assign ,readwrite)  XWWidgetState state;
@property(nonatomic , strong)  NSNumber * needRequest;

@end

@implementation XWWidget

@synthesize headerData = _headerData;
@synthesize footerData = _footerData;
@synthesize cellDataList = _cellDataList;
@synthesize decorationViewClass = _decorationViewClass;

#pragma mark -- public

-(void)xw_reloadWidget{
    
    if (self.collectionView) {
        
        XWSuppressPerformSelectorLeakWarning(
                                             [self.collectionView performSelector:NSSelectorFromString(@"xw_reloadWidgets")];
                                             );
    }
}

- (void)requestHeaderRefresh{
    
    _needRequest = @(false);
    [self requestFinishWithState:XWWidgetStateRequestSuccess];
}

- (void)requestFooterRefresh{
    
    _needRequest = @(false);
    [self requestFinishWithState:XWWidgetStateRequestSuccess];
}

-(void)requestSuccess{
    
    [self requestFinishWithState:XWWidgetStateRequestSuccess];
}

-(void)requestFail{
    
    [self requestFinishWithState:XWWidgetStateRequestFail];
}

-(void)requestNoMoreData{
    
    [self requestFinishWithState:XWWidgetStateRequestNoMoreData];
}

-(void)requestFinishWithState:(XWWidgetState)state{
    
    _needRequest = @(false);
    self.state = state;
    XWSuppressPerformSelectorLeakWarning(
                                         [self.collectionView performSelector:NSSelectorFromString(@"xw_requestFinish")];
                                         );
}


#pragma mark -- set/get

-(NSNumber *)needRequest{
    if (!_needRequest) {
        _needRequest = @(false);
    }
    return _needRequest;
}

-(XWWidgetState)state{
    if ([self.needRequest boolValue]) {
        return XWWidgetStateRequsting;
    }
    return _state;
}


-(NSObject *)headerData{
    if (!_headerData) {
        NSObject * defaultData = [NSObject new];
        defaultData.xw_reuseIdentifier = @"UICollectionReusableView";
        defaultData.xw_width = 0.001;
        defaultData.xw_height = 0.001;
        _headerData = defaultData;
    }
    return _headerData;
}

-(void)setHeaderData:(NSObject *)headerData{
    if (( _headerData != headerData)) {
        _headerData = headerData;
        self.headerDataList = nil;
    }
}


-(NSObject *)footerData{
    if (!_footerData) {
        NSObject * defaultData = [NSObject new];
        defaultData.xw_reuseIdentifier = @"UICollectionReusableView";
        defaultData.xw_width= 0.001;
        defaultData.xw_height = 0.001;
        _footerData = defaultData;
    }
    return _footerData;
}


-(void)setFooterData:(NSObject *)footerData{
    if ((_footerData != footerData)) {
        _footerData = footerData;
        self.footerDataList = nil;
    }
}

-(NSMutableArray *)cellDataList{
    if (!_cellDataList) {
        _cellDataList = [NSMutableArray new];
    }
    return _cellDataList;
}

-(void)setCellDataList:(NSMutableArray *)cellDataList{
    if (_cellDataList != cellDataList) {
        _cellDataList = cellDataList;
        self.multiCellDataList = nil;
    }
}

-(Class)decorationViewClass{
    if (!_decorationViewClass) {
        _decorationViewClass = [UICollectionReusableView class];
    }
    return _decorationViewClass;
}

-(NSMutableArray *)headerDataList{
    if (!_headerDataList) {
        _headerDataList = [[NSMutableArray alloc] init];
    }
    
    if (_headerDataList.count < self.multiCellDataList.count) {
        while (_headerDataList.count < self.multiCellDataList.count) {
            [_headerDataList addObject:self.headerData];
        }
    }
    return _headerDataList;
}

-(NSMutableArray *)footerDataList{
    if (!_footerDataList) {
        _footerDataList = [[NSMutableArray alloc] init];
    }
    if (_footerDataList.count < self.headerDataList.count) {
        while (_footerDataList.count < self.headerDataList.count) {
            [_footerDataList addObject:self.footerData];
        }
    }else if(_footerDataList.count > self.headerDataList.count){
        while (_footerDataList.count > self.headerDataList.count) {
            [_footerDataList removeLastObject];
        }
    }
    return _footerDataList;
}


-(NSMutableArray<NSMutableArray *> *)multiCellDataList{
    if (!_multiCellDataList) {
        if (self.cellDataList.count > 0) {
            _multiCellDataList = [[NSMutableArray alloc] initWithObjects:self.cellDataList, nil];
        }else{
            _multiCellDataList = [[NSMutableArray alloc] init];
        }
        
    }
    return _multiCellDataList ;
}



-(NSMutableArray<Class> *)decorationViewClassList{
    if (!_decorationViewClassList) {
        _decorationViewClassList = [[NSMutableArray alloc] init];
    }
    if (_decorationViewClassList.count < self.headerDataList.count) {
        while (_decorationViewClassList.count < self.headerDataList.count) {
            [_decorationViewClassList addObject:self.decorationViewClass];
        }
    }else if(_decorationViewClassList.count > self.headerDataList.count){
        while (_decorationViewClassList.count > self.headerDataList.count) {
            [_decorationViewClassList removeLastObject];
        }
    }
    return _decorationViewClassList;
}

-(void)setDecorationViewClass:(Class)decorationViewClass{
    if (_decorationViewClass != decorationViewClass) {
        _decorationViewClass = decorationViewClass;
        if (self.decorationViewClassList.count == 1) {
            [self.decorationViewClassList replaceObjectAtIndex:0 withObject:_decorationViewClass];
        }
    }
}



@end
