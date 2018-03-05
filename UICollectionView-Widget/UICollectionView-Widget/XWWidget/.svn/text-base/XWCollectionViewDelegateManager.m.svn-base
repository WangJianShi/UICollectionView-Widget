//
//  XWCollectionViewDelegateManager.m
//  
//
//  Created by 王剑石 on 16/12/16.
//  Copyright © 2016年 王剑石. All rights reserved.
//

#ifdef DEBUG
#define XWAssert(condition , description)  if(!(condition)){ NSLog(@"%@",description); assert(0);}
#else
#define XWAssert(condition , description)
#endif

#ifdef DEBUG
#define XAssert(condition)  if(!(condition)){ assert(0);}
#else
#define XAssert(condition)
#endif

#import "XWCollectionViewDelegateManager.h"
#import "NSObject+XW.h"
#import "UICollectionView+XW.h"
#import "XWCollectionViewFlowLayout.h"
#import "UICollectionViewCell+XW.h"
#import "UICollectionReusableView+XW.h"

@implementation XWCollectionViewDelegateManager


#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [self getSecionDataListWithSection:section collectionview:collectionView].count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    if ([self headerDataList:collectionView]) {
        return [self headerDataList:collectionView].count;
    }else {
        NSArray * cellDataList = [self cellDataList:collectionView];
        if (cellDataList.count) {
            if ([cellDataList.firstObject isKindOfClass:[NSArray class]]) {
                return cellDataList.count;
            }else {
                return 1;
            }
        }
    }
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    id data = [self getCellDataWithIndexPath:indexPath collectionview:collectionView];
    if ([data isKindOfClass:[NSObject class]]) {

        NSObject *cellData = (NSObject *)data;
        NSString * identifier = [self cellReuseIdentifier:cellData];
        UICollectionViewCell * cell = [collectionView dequeueReusableCellWithIdentify:identifier indexPath:indexPath reusable:!cellData.unReusable];
        cell.xw_collectionView = collectionView;
        [CATransaction begin];
        [CATransaction setDisableActions:YES];
        [cell reuseWithData:cellData indexPath:indexPath];
        [CATransaction commit];
        return cell;
    }
    return [collectionView dequeueReusableCellWithReuseIdentifier:@"UICollectionViewCell" forIndexPath:indexPath];
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    NSObject * data = [self getHeaderOrFooterDataWithKind:kind atIndexPath:indexPath collectionview:collectionView];

    if ([data isKindOfClass:[NSObject class]]) {
        
        NSString * identifier = [self viewReuseIdentifier:data];
        UICollectionReusableView * view = [collectionView dequeueReusableView:identifier indexPath:indexPath kind:kind reusable:!data.unReusable];
        view.xw_collectionView = collectionView;
        [CATransaction begin];
        [CATransaction setDisableActions:YES];
        [view reuseWithData:data indexPath:indexPath isHeader:[kind isEqualToString:UICollectionElementKindSectionHeader]];
        
        [CATransaction commit];
        
        return view;
    }
    
    return [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"UICollectionReusableView" forIndexPath:indexPath];
}



#pragma mark UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    id data = [self getCellDataWithIndexPath:indexPath collectionview:collectionView ];
    
    if ([data isKindOfClass:[NSObject class]])
    {
        NSObject *cellData = (NSObject *)data;
        NSString * identifier = [self cellReuseIdentifier:cellData];
        if (cellData.xw_height == 0 || cellData.xw_width == 0)
        {
            UICollectionViewCell * cacheCell = [collectionView getStaticReusableCell:identifier];
            [cacheCell reuseWithData:cellData indexPath:indexPath];
            CGSize size = [cacheCell cell_size];
            cellData.xw_width = size.width;
            cellData.xw_height = size.height;
        }
        
        return CGSizeMake(cellData.xw_width, cellData.xw_height);
    }
    
    return CGSizeZero;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    NSArray * headerDataList = [self headerDataList:collectionView];
    if (section < headerDataList.count) {
        NSObject * headerData = [headerDataList objectAtIndex:section];

        if (headerData) {
            if (headerData.xw_width == 0 && headerData.xw_height == 0) {
                if ([collectionView.collectionViewLayout isKindOfClass:[UICollectionViewFlowLayout class]]) {
                    UICollectionViewFlowLayout * layout = (UICollectionViewFlowLayout *)collectionView.collectionViewLayout;
                    headerData.xw_width = layout.headerReferenceSize.width;
                    headerData.xw_height = layout.headerReferenceSize.height;
                }
            }
            
            if (headerData.xw_width == 0 || headerData.xw_height == 0) {
                 NSString * identifier = [self viewReuseIdentifier:headerData];
                UICollectionReusableView * cacheHeader = [collectionView getStaticReusableView:identifier kind:UICollectionElementKindSectionHeader];
                [cacheHeader reuseWithData:headerData indexPath:[NSIndexPath indexPathForRow:0 inSection:section] isHeader:YES];
                CGSize size = [cacheHeader view_size];
                headerData.xw_height = size.height;
                headerData.xw_width = size.width;
            }

            return CGSizeMake(headerData.xw_width, headerData.xw_height);
        }
    }
    return CGSizeZero;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    NSArray * footerDataList = [self footerDataList:collectionView];
    if (section < footerDataList.count) {
        NSObject * footerData = [footerDataList objectAtIndex:section];
        if (footerData) {
            if (footerData.xw_width == 0 && footerData.xw_height == 0) {
                if ([collectionView.collectionViewLayout isKindOfClass:[UICollectionViewFlowLayout class]]) {
                    UICollectionViewFlowLayout * layout = (UICollectionViewFlowLayout *)collectionView.collectionViewLayout;
                    footerData.xw_width = layout.footerReferenceSize.width;
                    footerData.xw_height = layout.footerReferenceSize.height;
                }
            }
            if (footerData.xw_width == 0 || footerData.xw_height == 0) {
                 NSString * identifier = [self viewReuseIdentifier:footerData];
                UICollectionReusableView * cacheFooter = [collectionView getStaticReusableView:identifier kind:UICollectionElementKindSectionFooter];
                [cacheFooter reuseWithData:footerData indexPath:[NSIndexPath indexPathForRow:0 inSection:section] isHeader:NO];
                CGSize size = [cacheFooter view_size];
                footerData.xw_height = size.height;
                footerData.xw_width = size.width;
            }

            return CGSizeMake(footerData.xw_width, footerData.xw_height);
        }
    }
    return CGSizeZero;
}


- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    NSArray * headerDataList = [self headerDataList:collectionView];
    if (section < headerDataList.count) {
        NSObject * data = [headerDataList objectAtIndex:section];
        return data.cell_secionInset;
    }else {
        NSArray * footerDataList = [self footerDataList:collectionView];
        if (section < footerDataList.count) {
            NSObject * data = [footerDataList objectAtIndex:section];
            return data.cell_secionInset;
        }
    }
    if ([collectionView.collectionViewLayout isKindOfClass:[UICollectionViewFlowLayout class]]) {
        UICollectionViewFlowLayout * layout = (UICollectionViewFlowLayout *)collectionView.collectionViewLayout;
        return layout.cell_secionInset;
    }
    return UIEdgeInsetsZero;
}


- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    NSArray * headerDataList = [self headerDataList:collectionView];
    if (section < headerDataList.count) {
        NSObject * data = [headerDataList objectAtIndex:section];
        return data.cell_minimumLineSpacing;
    }else {
        NSArray * footerDataList = [self footerDataList:collectionView];
        if (section < footerDataList.count) {
            NSObject * data = [footerDataList objectAtIndex:section];
            return data.cell_minimumLineSpacing;
        }
    }
    if ([collectionView.collectionViewLayout isKindOfClass:[UICollectionViewFlowLayout class]]) {
        UICollectionViewFlowLayout * layout = (UICollectionViewFlowLayout *)collectionView.collectionViewLayout;
        return layout.minimumLineSpacing;
    }
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    NSArray * headerDataList = [self headerDataList:collectionView];
    if (section < headerDataList.count) {
        NSObject * data = [headerDataList objectAtIndex:section];
        return data.cell_minimumInteritemSpacing;
    }else {
        NSArray * footerDataList = [self footerDataList:collectionView];
        if (section < footerDataList.count) {
            NSObject * data = [footerDataList objectAtIndex:section];
            return data.cell_minimumInteritemSpacing;
        }
    }
    
    if ([collectionView.collectionViewLayout isKindOfClass:[UICollectionViewFlowLayout class]]) {
        UICollectionViewFlowLayout * layout = (UICollectionViewFlowLayout *)collectionView.collectionViewLayout;
        return layout.minimumInteritemSpacing;
    }
    return 0;
}

#pragma mark -
#pragma mark - private

- (NSArray *) getSecionDataListWithSection:(NSInteger) section collectionview:(UICollectionView *)collectionview{
    NSArray * list = [self cellDataList:collectionview];
    if (list.count) {
        if (section == 0 && ![list.firstObject isKindOfClass:[NSArray class]]) {
            return list;
        }
        if (section < list.count) {
            NSArray * sectionDataList = [list objectAtIndex:section];
            if ([sectionDataList isKindOfClass:[NSArray class]]) {
                return sectionDataList;
            }else {
                XWAssert(false, @"sectionDataList not be NSArray type");
            }
        }
    }
    return nil;
}

- (id ) getCellDataWithIndexPath:(NSIndexPath *)indexPath  collectionview:(UICollectionView *)collectionview{
    NSArray * sectionDataList = [self getSecionDataListWithSection:indexPath.section collectionview:collectionview];
    if (indexPath.row < sectionDataList.count) {
        return [sectionDataList objectAtIndex:indexPath.row];
    }
    return nil;
}


-(NSObject * )getHeaderOrFooterDataWithKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath  collectionview:(UICollectionView *)collectionview{
    NSArray * list;
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        list = [self headerDataList:collectionview];
    }else if([kind isEqualToString:UICollectionElementKindSectionFooter]){
        list = [self footerDataList:collectionview];
    }
    if (indexPath.section < list.count) {
        return [list objectAtIndex:indexPath.section];
    }
    return nil;
}



- (NSArray *) cellDataList:(UICollectionView *)collectionview{
    if ([collectionview.xw_dataSource respondsToSelector:@selector(cellDataListWithCollectionView:)]) {
        NSArray * dataList = [collectionview.xw_dataSource cellDataListWithCollectionView:collectionview];
        if ([dataList isKindOfClass:[NSArray class]]) {
            return dataList;
        }else if(dataList){
            return [NSArray array];
        }
    }
    return nil;
}

- (NSArray *) headerDataList:(UICollectionView *)collectionview{
    if ([collectionview.xw_dataSource respondsToSelector:@selector(headerDataListWithCollectionView:)]) {
        NSArray * dataList = [collectionview.xw_dataSource headerDataListWithCollectionView:collectionview];
        if ([dataList isKindOfClass:[NSArray class]] && dataList.count > 0) {
            
            return dataList;
        }else if(dataList){
            
            return [NSArray array];
        }
    }
    return nil;
}

- (NSArray *) footerDataList:(UICollectionView *)collectionview{
    if ([collectionview.xw_dataSource respondsToSelector:@selector(footerDataListWithCollectionView:)]) {
        NSArray * dataList = [collectionview.xw_dataSource footerDataListWithCollectionView:collectionview];
        if ([dataList isKindOfClass:[NSArray class]] && dataList.count > 0 ) {
            return dataList;
        }else if(dataList){
            return [NSArray array];
        }
    }
    return nil;
}

- (NSArray *) decorationViewClassList:(UICollectionView *)collectionview{
    if ([collectionview.xw_dataSource respondsToSelector:@selector(decorationViewClassListWithCollectionView:)]) {
        NSArray * classList = [collectionview.xw_dataSource decorationViewClassListWithCollectionView:collectionview];
        if ([classList isKindOfClass:[NSArray class]]) {
            return classList;
        }else if(classList){
            XWAssert(false, @"Result not be NSArray type");
        }
    }
    return nil;
}

-(NSString *)cellReuseIdentifier:(NSObject *)obj{
    
    if (obj.xw_reuseIdentifier == nil)
    {
        NSString *reuseIdentify = [NSString stringWithUTF8String:object_getClassName(obj)];
        if (reuseIdentify.length > 4)
        {
            reuseIdentify = [reuseIdentify substringToIndex:[reuseIdentify length] - 4];
            reuseIdentify = [reuseIdentify stringByAppendingString:@"Cell"];
        }
        
        Class identifyClass = NSClassFromString(reuseIdentify);
        
        if ([[identifyClass alloc] init] == nil) {
            
            reuseIdentify = @"UICollectionViewCell";
        }
        obj.xw_reuseIdentifier = reuseIdentify;
    }
    
    return obj.xw_reuseIdentifier;
}

-(NSString *)viewReuseIdentifier:(NSObject *)obj{
    
    if (obj.xw_reuseIdentifier == nil)
    {
        NSString *reuseIdentify = [NSString stringWithUTF8String:object_getClassName(obj)];
        if (reuseIdentify.length > 4)
        {
            reuseIdentify = [reuseIdentify substringToIndex:[reuseIdentify length] - 4];
            reuseIdentify = [reuseIdentify stringByAppendingString:@"View"];
        }
        
        Class identifyClass = NSClassFromString(reuseIdentify);
        
        if ([[identifyClass alloc] init] == nil) {
            
            reuseIdentify = @"UICollectionReusableView";
        }
        
        obj.xw_reuseIdentifier = reuseIdentify;
    }
    
    return obj.xw_reuseIdentifier;
}

#pragma mark - UICollectionViewDelegate

- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath{

    for (id<UICollectionViewDelegate>  delegate in collectionView.xw_delegates ) {
        if ([delegate respondsToSelector:@selector(collectionView:shouldHighlightItemAtIndexPath:)]) {
            return [delegate collectionView:collectionView shouldHighlightItemAtIndexPath:indexPath];
        }
    }
    UICollectionViewCell * cell = [collectionView cellForItemAtIndexPath:indexPath];
    if (cell)
    {
        return [cell xw_shouldHighlightCell];
    }
    return true;
}

- (void)collectionView:(UICollectionView *)collectionView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath{
    
    for (id<UICollectionViewDelegate>  delegate in collectionView.xw_delegates )
    {
        if ([delegate respondsToSelector:@selector(collectionView:didHighlightItemAtIndexPath:)])
        {
            [delegate collectionView:collectionView didHighlightItemAtIndexPath:indexPath];
        }
    }
    UICollectionViewCell * cell = [collectionView cellForItemAtIndexPath:indexPath];
    [cell xw_didHighlightCell];
}


- (void)collectionView:(UICollectionView *)collectionView didUnhighlightItemAtIndexPath:(NSIndexPath *)indexPath{
    for (id<UICollectionViewDelegate>  delegate in collectionView.xw_delegates )
    {
        if ([delegate respondsToSelector:@selector(collectionView:didUnhighlightItemAtIndexPath:)])
        {
            [delegate collectionView:collectionView didUnhighlightItemAtIndexPath:indexPath];
        }
    }
    UICollectionViewCell * cell = [collectionView cellForItemAtIndexPath:indexPath];
    [cell xw_didUnhighlightCell];
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    for (id<UICollectionViewDelegate>  delegate in collectionView.xw_delegates )
    {
        if ([delegate respondsToSelector:@selector(collectionView:shouldSelectItemAtIndexPath:)])
        {
            return [delegate collectionView:collectionView shouldSelectItemAtIndexPath:indexPath];
        }
    }
    UICollectionViewCell * cell = [collectionView cellForItemAtIndexPath:indexPath];
    if (cell)
    {
        return [cell xw_shouldSelectCell];
    }
    return true;
}
- (BOOL)collectionView:(UICollectionView *)collectionView shouldDeselectItemAtIndexPath:(NSIndexPath *)indexPath{
    for (id<UICollectionViewDelegate>  delegate in collectionView.xw_delegates )
    {
        if ([delegate respondsToSelector:@selector(collectionView:shouldDeselectItemAtIndexPath:)])
        {
            return [delegate collectionView:collectionView shouldDeselectItemAtIndexPath:indexPath];
        }
    }
    UICollectionViewCell * cell = [collectionView cellForItemAtIndexPath:indexPath];
    if (cell)
    {
        return [cell xw_shouldDeselectCell];
    }
    return true;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    for (id<UICollectionViewDelegate>  delegate in collectionView.xw_delegates )
    {
        if ([delegate respondsToSelector:@selector(collectionView:didSelectItemAtIndexPath:)])
        {
            [delegate collectionView:collectionView didSelectItemAtIndexPath:indexPath];
        }
    }
    UICollectionViewCell * cell = [collectionView cellForItemAtIndexPath:indexPath];
    [cell xw_didSelectCell];
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath{
    for (id<UICollectionViewDelegate>  delegate in collectionView.xw_delegates )
    {
        if ([delegate respondsToSelector:@selector(collectionView:didDeselectItemAtIndexPath:)])
        {
            [delegate collectionView:collectionView didDeselectItemAtIndexPath:indexPath];
        }
    }
    UICollectionViewCell * cell = [collectionView cellForItemAtIndexPath:indexPath];
    [cell xw_didDeselectCell];
}


-(void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath{
    for (id<UICollectionViewDelegate>  delegate in collectionView.xw_delegates )
    {
        if ([delegate respondsToSelector:@selector(collectionView:willDisplayCell:forItemAtIndexPath:)])
        {
            [delegate collectionView:collectionView willDisplayCell:cell forItemAtIndexPath:indexPath];
        }
    }
    [cell xw_willDisplayCell];
}

#pragma mark UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    UICollectionView *collectionView = (UICollectionView *)scrollView;
    
    for (id<UICollectionViewDelegate>  delegate in collectionView.xw_delegates )
    {
        if ([delegate respondsToSelector:@selector(scrollViewDidScroll:)])
        {
            [delegate scrollViewDidScroll:scrollView];
        }
    }

}


-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    
    UICollectionView *collectionView = (UICollectionView *)scrollView;
    
    for (id<UICollectionViewDelegate>  delegate in collectionView.xw_delegates )
    {
        if ([delegate respondsToSelector:@selector(scrollViewWillBeginDragging:)])
        {
            [delegate scrollViewWillBeginDragging:scrollView];
        }
    }
}

-(void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{
    
    UICollectionView *collectionView = (UICollectionView *)scrollView;
    
    for (id<UICollectionViewDelegate>  delegate in collectionView.xw_delegates )
    {
        if ([delegate respondsToSelector:@selector(scrollViewWillEndDragging:withVelocity:targetContentOffset:)])
        {
            [delegate scrollViewWillEndDragging:scrollView withVelocity:velocity targetContentOffset:targetContentOffset];
        }
    }
    
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
    UICollectionView *collectionView = (UICollectionView *)scrollView;
    
    for (id<UICollectionViewDelegate>  delegate in collectionView.xw_delegates )
    {
        if ([delegate respondsToSelector:@selector(scrollViewDidEndDragging:willDecelerate:)])
        {
            [delegate scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
        }
    }
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
    
    UICollectionView *collectionView = (UICollectionView *)scrollView;
    
    for (id<UICollectionViewDelegate>  delegate in collectionView.xw_delegates )
    {
        if ([delegate respondsToSelector:@selector(scrollViewWillBeginDecelerating:)])
        {
            [delegate scrollViewWillBeginDragging:scrollView];
        }
    }
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    UICollectionView *collectionView = (UICollectionView *)scrollView;
    
    for (id<UICollectionViewDelegate>  delegate in collectionView.xw_delegates )
    {
        if ([delegate respondsToSelector:@selector(scrollViewDidEndDecelerating:)])
        {
            [delegate scrollViewDidEndDecelerating:scrollView];
        }
    }
    
}

-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    
     UICollectionView *collectionView = (UICollectionView *)scrollView;
    
    for (id<UICollectionViewDelegate>  delegate in collectionView.xw_delegates )
    {
        if ([delegate respondsToSelector:@selector(scrollViewDidEndScrollingAnimation:)])
        {
            [delegate scrollViewDidEndScrollingAnimation:scrollView];
        }
    }
}

-(void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale{
    
     UICollectionView *collectionView = (UICollectionView *)scrollView;
    
    for (id<UICollectionViewDelegate>  delegate in collectionView.xw_delegates )
    {
        if ([delegate respondsToSelector:@selector(scrollViewDidEndZooming:withView:atScale:)])
        {
            [delegate scrollViewDidEndZooming:scrollView withView:view atScale:scale];
        }
    }
    
}


@end
