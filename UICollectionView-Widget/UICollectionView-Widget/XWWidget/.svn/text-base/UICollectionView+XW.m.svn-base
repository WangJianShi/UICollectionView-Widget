//
//  UICollectionView+XW.m
//  
//
//  Created by serein on 2017/11/7.
//  Copyright © 2017年 wangjianshi. All rights reserved.
//

#import "UICollectionView+XW.h"
#import <objc/runtime.h>
#import "XWCollectionViewFlowLayout.h"
#import "XWCollectionViewDelegateManager.h"
#import "XWWeakObject.h"

@implementation UICollectionView (XW)

#pragma mark -
#pragma mark - public

+(instancetype) createWithLayout:(UICollectionViewLayout *)layout{
    
    return [[self alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
}

+(instancetype)createWithStyleGrouped{
    
    XWCollectionViewFlowLayout * layout = [XWCollectionViewFlowLayout new];
    layout.layoutType = XWCollectionViewFlowLayoutTypeStickHeader;
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = 0;
    return [self createWithLayout:layout];
}

+(instancetype)createWithStretchyHeaderSize:(CGSize)headerSize{
    
    XWCollectionViewFlowLayout * layout = [XWCollectionViewFlowLayout new];
    layout.layoutType = XWCollectionViewFlowLayoutStretchyHeader;
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    layout.headerReferenceSize = headerSize;
    return [self createWithLayout:layout];
    
}

+(instancetype) createWithFlowLayout{
    
    UICollectionViewFlowLayout * layout = [XWCollectionViewFlowLayout new];
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = 0;
    return [self createWithLayout:layout];
}

#pragma mark -
#pragma mark - set/get
-(void)setXw_dataSource:(id<XWCollectionViewDataSource>)xw_dataSource{
    
    if (self.xw_dataSource != xw_dataSource )
    {
        XWWeakObject *weakDatasource = [[XWWeakObject alloc] initWeakObject:xw_dataSource];
        objc_setAssociatedObject(self, @selector(xw_dataSource), weakDatasource, OBJC_ASSOCIATION_RETAIN);
        XWCollectionViewDelegateManager * delegator = [self delegateManager];
        if (xw_dataSource)
        {
            [self setDataSource:delegator];
            [self setDelegate:delegator];
        }
        else
        {
            [self setDataSource:nil];
            [self setDelegate:nil];
        }
        
    }
    
}
-(id<XWCollectionViewDataSource>)xw_dataSource{
    
    XWWeakObject *weakDatasource = objc_getAssociatedObject(self, @selector(xw_dataSource));
    return weakDatasource.weakObject;
}

-(id<UICollectionViewDelegate>)xw_delegate{
    
    XWWeakObject *weakDelegate = objc_getAssociatedObject(self, @selector(xw_delegate));
    return  weakDelegate.weakObject;
}

-(void)setXw_delegate:(id<UICollectionViewDelegate>)xw_delegate{
    
    XWCollectionViewDelegateManager * delegator = [self delegateManager];
    [self setDelegate:delegator];
    XWWeakObject *weakDelegate = [[XWWeakObject alloc] initWeakObject:xw_delegate];
    [self.xw_delegates addObject:xw_delegate];
    objc_setAssociatedObject(self, @selector(xw_delegate), weakDelegate, OBJC_ASSOCIATION_RETAIN);
}

-(XWWeakMutableArray<UICollectionViewDelegate> *)xw_delegates{
    
    XWWeakMutableArray<UICollectionViewDelegate> *weakDelegates = objc_getAssociatedObject(self, @selector(xw_delegates));
    if (weakDelegates == nil)
    {
         XWWeakMutableArray<UICollectionViewDelegate> *delegates = [[XWWeakMutableArray<UICollectionViewDelegate> alloc] init];
         objc_setAssociatedObject(self, @selector(xw_delegates), delegates, OBJC_ASSOCIATION_RETAIN);
        return delegates;
    }

    return weakDelegates;
}
-(void)setXw_delegates:(XWWeakMutableArray<UICollectionViewDelegate> *)xw_delegates{
    
    XWWeakMutableArray *news = [[XWWeakMutableArray alloc] init];
    for (id obj in xw_delegates)
    {
        if (![obj isMemberOfClass:[XWWeakObject class]])
        {
            XWWeakObject *weakObj = [[XWWeakObject alloc] initWeakObject:obj];
            [news addObject:weakObj];
        }
        else
        {
            [news addObject:obj];
        }
    }
    if (self.xw_delegate) {
        
        [news addObject:self.xw_delegate];
    }
     objc_setAssociatedObject(self, @selector(xw_delegates), news, OBJC_ASSOCIATION_RETAIN);
    
}

-(XWCollectionViewDelegateManager *)delegateManager{
    XWCollectionViewDelegateManager * delegator = objc_getAssociatedObject(self, @selector(delegateManager));
    if (!delegator) {
        delegator = [XWCollectionViewDelegateManager new];
        objc_setAssociatedObject(self, @selector(delegateManager), delegator, OBJC_ASSOCIATION_RETAIN);
    }
    return delegator;
}


@end

#pragma mark -
#pragma mark - cell注册
@implementation UICollectionView (XWRegister)

-(NSMutableDictionary *)cacheStaticDic{
    
    NSMutableDictionary *dic = objc_getAssociatedObject(self, @selector(cacheStaticDic));
    
    if (dic == nil) {
        
        objc_setAssociatedObject(self, @selector(cacheStaticDic), [NSMutableDictionary dictionary], OBJC_ASSOCIATION_RETAIN);
    }
    
    return objc_getAssociatedObject(self, @selector(cacheStaticDic));
}

-(void)setCacheStaticDic:(NSMutableDictionary *)cacheStaticDic{
    
     objc_setAssociatedObject(self, @selector(cacheStaticDic), cacheStaticDic, OBJC_ASSOCIATION_RETAIN);
}


-(UICollectionViewCell *)dequeueReusableCellWithIdentify:(NSString *)identify indexPath:(NSIndexPath *)indexPath reusable:(BOOL )reusable{
    
    NSString *reusableClass = (identify == nil || identify.length == 0) ? @"UICollectionViewCell" : identify;
    
    NSString *reusableIdentify = reusableClass;
    
    Class identifyClass = NSClassFromString(reusableClass);

    if (!reusable) {
        
        reusableIdentify = [NSString stringWithFormat:@"%@%ld%ld",reusableIdentify,indexPath.section,indexPath.row];
        
    }
    
    [self registerCellClassIfNeedWithIdentifierClass:identifyClass reusableIdentify:reusableIdentify];

    return [self dequeueReusableCellWithReuseIdentifier:reusableIdentify forIndexPath:indexPath];
}

-(UICollectionReusableView *)dequeueReusableView:(NSString *)identify indexPath:(NSIndexPath *)indexPath kind:(NSString *)kind reusable:(BOOL )reusable{
    
    NSString *reusableClass = (identify == nil || identify.length == 0) ? @"UICollectionReusableView" : identify;
    
    NSString *reusableIdentify = reusableClass;
    
    Class identifyClass=NSClassFromString(reusableIdentify);
    
    if (!reusable) {
        
        reusableIdentify = [NSString stringWithFormat:@"%@%ld",reusableIdentify,indexPath.section];
        
    }
    
    [self registerReusableViewClassIfNeedWithIdentifierClass:identifyClass reusableIdentify:reusableIdentify kind:kind];
    
    return [self dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:reusableIdentify forIndexPath:indexPath];
    
}


-(UICollectionViewCell *)getStaticReusableCell:(NSString *)identify{
    
    NSString *reusableClass = (identify == nil || identify.length == 0) ? @"UICollectionViewCell" : identify;
    
     Class identifyClass = NSClassFromString(reusableClass);
    
    [self registerCellClassIfNeedWithIdentifierClass:identifyClass reusableIdentify:identify];

    UICollectionViewCell *cell = [self.cacheStaticDic objectForKey:identify];
    
    return cell;
}


-(UICollectionReusableView *)getStaticReusableView:(NSString *)identify kind:(NSString *)kind{
    
    NSString *reusable = (identify == nil || identify.length == 0) ? @"UICollectionReusableView" : identify;
    
    Class identifyClass = NSClassFromString(reusable);
    
    [self registerReusableViewClassIfNeedWithIdentifierClass:identifyClass reusableIdentify:reusable kind:kind];

    
    UICollectionReusableView *view = [self.cacheStaticDic objectForKey:reusable];
    
    return view;
    
}

- (void)registerCellClassIfNeedWithIdentifierClass:(Class) identifierClass  reusableIdentify:(NSString *)identify{
    
    
    UICollectionViewCell *cacheCell = [self.cacheStaticDic objectForKey:identify];
    if (!cacheCell) {
        cacheCell = [[identifierClass alloc] init];
        if (cacheCell == nil) {
            
            cacheCell = [[UICollectionViewCell alloc] init];
        }
        [self registerClass:identifierClass forCellWithReuseIdentifier:identify];
        [self.cacheStaticDic setObject:cacheCell forKey:identify];
        
    }
}

- (void)registerReusableViewClassIfNeedWithIdentifierClass:(Class) identifierClass  reusableIdentify:(NSString *)identify kind:(NSString *)kind{
    
    UICollectionReusableView *cacheReusableView = [self.cacheStaticDic objectForKey:[NSString stringWithFormat:@"%@%@",identify,kind]];
    if (!cacheReusableView) {
        cacheReusableView = [[identifierClass alloc] init];
        
        if (cacheReusableView == nil) {
            
            cacheReusableView = [[UICollectionReusableView alloc] init];
        }
        
        [self registerClass:identifierClass forSupplementaryViewOfKind:kind withReuseIdentifier:identify];
        [self.cacheStaticDic setObject:cacheReusableView forKey:[NSString stringWithFormat:@"%@%@",identify,kind]];
        
    }
}

@end

