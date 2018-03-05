//
//  XWCollectionViewFlowLayout.m
//
//
//  Created by 王剑石 on 16/12/16.
//  Copyright © 2016年 王剑石. All rights reserved.
//

#import "XWCollectionViewFlowLayout.h"
#import "UICollectionView+XW.h"


@interface XWCollectionViewFlowLayout()<UICollectionViewDelegateFlowLayout>

@property(nonatomic , strong) NSMutableArray * attributesArray;
@property(nonatomic , weak)  id<UICollectionViewDelegateFlowLayout> delegate;
@property(nonatomic , assign) CGSize contentSize;
@property(nonatomic , assign) CGRect rect;
@property(nonatomic , strong)  NSMutableArray * attributesArrayInRect;
@property(nonatomic , strong)  NSMutableArray * decroationViewAttsArray;
@property(nonatomic , assign) NSUInteger  sectionNum;

@property(nonatomic , assign)  BOOL verticalDir;// 是否为纵向布局

@end

@implementation XWCollectionViewFlowLayout

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.minimumLineSpacing = 0;
        self.minimumInteritemSpacing = 0;
        self.cellType = AlignWithLeft;
    }
    return self;
}

-(CGSize)collectionViewContentSize{
    if(self.layoutType == XWCollectionViewFlowLayoutTypeWaterfall){
        return CGSizeMake((int)self.contentSize.width, (int)self.contentSize.height);
    }
    CGSize size = [super collectionViewContentSize];
    return CGSizeMake((int)size.width, (int)size.height);
}


-(void)prepareLayout{
    [super prepareLayout];
    self.sectionNum = [self numOfSection];
    if (self.layoutType == XWCollectionViewFlowLayoutTypePlain) {
        self.decroationViewAttsArray = nil;
    }else if(self.layoutType == XWCollectionViewFlowLayoutTypeStickHeader || self.layoutType == XWCollectionViewFlowLayoutHistory){
        self.decroationViewAttsArray = nil;
        
    }else if(self.layoutType == XWCollectionViewFlowLayoutTypeWaterfall){
        [self prepareLayoutForWaterfallType];
    }
}


-(void)prepareLayoutForWaterfallType{
    if (self.collectionView.frame.size.width == 0) {
        [self.collectionView layoutIfNeeded];
    }
    NSMutableArray * array = [NSMutableArray new];
    
    self.decroationViewAttsArray = [NSMutableArray new];
    
    CGPoint offset = CGPointZero;
    
    int  section = (int)[self numOfSection];
    
    for (int i = 0; i < section; i++) {
        [array addObjectsFromArray:[self getAttributesWithSection:i fromOffset:&offset]];
    }
    
    if (self.verticalDir) {
        self.contentSize = CGSizeMake(self.collectionView.frame.size.width, offset.y);
    }else {
        self.contentSize = CGSizeMake(offset.x, self.collectionView.frame.size.height - 1);
    }
    self.attributesArray = array;
}


-(UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath{
    return  [super layoutAttributesForItemAtIndexPath:indexPath];
}

-(UICollectionViewLayoutAttributes *)layoutAttributesForDecorationViewOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath{
    return [super layoutAttributesForDecorationViewOfKind:elementKind atIndexPath:indexPath];
}


-(UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section >= [self numOfSection]){
        return nil;
    }
    if ([elementKind isEqualToString:UICollectionElementKindSectionHeader]) {
        CGSize size = [self headerSizeWithSection:indexPath.section];
        if (CGSizeEqualToSize(size, CGSizeZero)) {
            return nil;
        }
    }
    if ([elementKind isEqualToString:UICollectionElementKindSectionFooter]) {
        CGSize size = [self footerSizeWithSection:indexPath.section];
        if (CGSizeEqualToSize(size, CGSizeZero)) {
            return nil;
        }
    }
    if (self.layoutType == XWCollectionViewFlowLayoutTypeStickHeader){
        return [self layoutAttributesForStickHeaderTypeSupplementaryViewOfKind:elementKind atIndexPath:indexPath];
    }
    
    return [super layoutAttributesForSupplementaryViewOfKind:elementKind atIndexPath:indexPath];
}



-(UICollectionViewLayoutAttributes *)layoutAttributesForStickHeaderTypeSupplementaryViewOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath{
    
    
    if (self.layoutType == XWCollectionViewFlowLayoutStretchyHeader) {
        
      return   [super layoutAttributesForSupplementaryViewOfKind:elementKind atIndexPath:indexPath];
    }
    if ([elementKind isEqualToString:UICollectionElementKindSectionHeader]) {
        UICollectionViewLayoutAttributes *attributes = [super layoutAttributesForSupplementaryViewOfKind:elementKind atIndexPath:indexPath];
        UICollectionView * const cv = self.collectionView;
        CGPoint const contentOffset = cv.contentOffset;
        CGPoint nextHeaderOrigin = CGPointMake(INFINITY, INFINITY);
        if (indexPath.section + 1 < self.sectionNum) {
            UICollectionViewLayoutAttributes *nextHeaderAttributes = [super layoutAttributesForSupplementaryViewOfKind:elementKind atIndexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section + 1]];
            nextHeaderOrigin = nextHeaderAttributes.frame.origin;
        }
        
        CGRect frame = attributes.frame;
        if (self.scrollDirection == UICollectionViewScrollDirectionVertical) {
            
            frame.origin.y = MIN(MAX(contentOffset.y + self.stickExtraHeight, frame.origin.y), nextHeaderOrigin.y - CGRectGetHeight(frame));
        }
        
        else { // UICollectionViewScrollDirectionHorizontal
            frame.origin.x = MIN(MAX(contentOffset.x, frame.origin.x), nextHeaderOrigin.x - CGRectGetWidth(frame));
        }
        attributes.zIndex = 1024;
        attributes.frame = frame;
        return attributes;
    }
    return [super layoutAttributesForSupplementaryViewOfKind:elementKind atIndexPath:indexPath];
}


-(NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect{
    if(self.layoutType == XWCollectionViewFlowLayoutTypeWaterfall){
        return [self layoutAttributesForWaterfallTypeElementsInRect:rect];
    }else if(self.layoutType == XWCollectionViewFlowLayoutTypePlain){
        return [self layoutAttributesForPlainTypeElementsInRect:rect];
    }else if(self.layoutType == XWCollectionViewFlowLayoutTypeStickHeader){
        return [self layoutAttributesForStickHeaderTypeElementsInRect:rect];
    }else if (self.layoutType == XWCollectionViewFlowLayoutHistory){
        return [self layoutAttributesForHistoryTypeElementsInRect:rect];
    }else if (self.layoutType == XWCollectionViewFlowLayoutStretchyHeader){
        
        UICollectionView *collectionView = [self collectionView];
        CGPoint offset = [collectionView contentOffset];
        
        NSArray *attributes = [super layoutAttributesForElementsInRect:rect];
        
        if (offset.y<0) {
            CGFloat deltaY = fabs(offset.y);
            for (UICollectionViewLayoutAttributes *attrs in attributes ) {
                NSString *kind = [attrs representedElementKind];
                if (kind == UICollectionElementKindSectionHeader) {
                    CGSize headerSize = [self headerReferenceSize];
                    CGRect headRect = [attrs frame];
                    headRect.size.height = headerSize.height+deltaY;
                    headRect.size.width = headerSize.width +deltaY;
                    headRect.origin.y = headRect.origin.y - deltaY;
                    headRect.origin.x = headRect.origin.x - deltaY/2;
                    [attrs setFrame:headRect];
                    break;
                }
            }
            
        }
        
        return attributes;

        
    }
    return nil;
}

-(NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForHistoryTypeElementsInRect:(CGRect)rect{
    

    NSArray * attributes = [super layoutAttributesForElementsInRect:rect];
    NSMutableArray * array = nil;
    if (attributes) {
        array = [NSMutableArray arrayWithArray:attributes];
        if (array.count && self.decroationViewAttsArray) {
            [array addObjectsFromArray:self.decroationViewAttsArray];
        }
    }

     NSMutableArray *attributesArray = [array mutableCopy];
    CGFloat itemSpace = [self minimumInteritemSpacingWithSection:0];
    
    UIEdgeInsets insert = [self sectionInsetWithSecion:0];
    
    CGFloat nowWidth = 0.0;
    for (int i = 0; i < attributesArray.count; i++) {
        
        UICollectionViewLayoutAttributes *attribute = attributesArray[i];
        
        if (attribute.indexPath.section == 0 && attribute.representedElementCategory == UICollectionElementCategoryCell) {
            
            if (i == 0) {
                UICollectionViewLayoutAttributes *currentLayoutAttributes = attributesArray[i];
                CGRect frame = currentLayoutAttributes.frame;
                
                if (self.cellType == AlignWithLeft) {
                    
                    frame.origin.x = insert.left;
                }else{
                    
                    frame.origin.x = self.collectionView.frame.size.width - insert.right - currentLayoutAttributes.frame.size.width;
                }
                
                currentLayoutAttributes.frame = frame;
                
            }else{
                UICollectionViewLayoutAttributes *currentLayoutAttributes = attributesArray[i];
                UICollectionViewLayoutAttributes *prevLayoutAttributes = attributesArray[i - 1];
                CGFloat preX = self.cellType == AlignWithLeft ? CGRectGetMaxX(prevLayoutAttributes.frame) : (self.collectionView.frame.size.width - CGRectGetMaxX(prevLayoutAttributes.frame) ) ;
                if (preX + itemSpace + currentLayoutAttributes.frame.size.width < self.collectionView.frame.size.width) {
                    
                    CGRect frame = currentLayoutAttributes.frame;
                    
                    if (self.cellType == AlignWithLeft) {
                        
                        frame.origin.x = preX + itemSpace;
                    }else{
                        
                        frame.origin.x = prevLayoutAttributes.frame.origin.x - itemSpace  - currentLayoutAttributes.frame.size.width;
                    }

                    currentLayoutAttributes.frame = frame;
                }else{
                    
                    CGRect frame = currentLayoutAttributes.frame;
                    if (self.cellType == AlignWithLeft) {
                        
                        frame.origin.x = insert.left;
                    }else{
                        
                        frame.origin.x = self.collectionView.frame.size.width - insert.right - currentLayoutAttributes.frame.size.width;
                    }

                    currentLayoutAttributes.frame = frame;
                    
                }
                
            }
        }
        
    }
    
    return attributesArray;
    
}

-(NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForWaterfallTypeElementsInRect:(CGRect)rect{
    self.rect = rect;
    return self.attributesArrayInRect;
}

-(NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForPlainTypeElementsInRect:(CGRect)rect{
    NSArray * arrayRect = [super layoutAttributesForElementsInRect:rect];
    NSMutableArray * array = nil;
    if (arrayRect) {
        array = [NSMutableArray arrayWithArray:arrayRect];
        if (array.count && self.decroationViewAttsArray) {
            [array addObjectsFromArray:self.decroationViewAttsArray];
        }
    }
    return  array;
}

-(NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForStickHeaderTypeElementsInRect:(CGRect)rect{
    NSArray * arrayRect = [super layoutAttributesForElementsInRect:rect];
    NSMutableArray * array = nil;
    if (arrayRect) {
        array = [NSMutableArray arrayWithArray:arrayRect];
        if (array.count && self.decroationViewAttsArray) {
            [array addObjectsFromArray:self.decroationViewAttsArray];
        }
    }
    NSMutableArray *modifiedAttributesArray = [array mutableCopy];
    NSMutableIndexSet *attributesToRemoveIdxs = [NSMutableIndexSet indexSet];
    
    NSMutableIndexSet *missingSections = [NSMutableIndexSet indexSet];
    for (NSUInteger idx = 0 ; idx < array.count; idx++) {
        UICollectionViewLayoutAttributes *attributes = array[idx];
        if (attributes.representedElementCategory == UICollectionElementCategoryCell) {
            // remember that we need to layout header for this section
            [missingSections addIndex:attributes.indexPath.section];
        }
        if ([attributes.representedElementKind isEqualToString:UICollectionElementKindSectionHeader]) {
            // remember indexes of header layout attributes, so that we can remove them and add them later
            [attributesToRemoveIdxs addIndex:idx];
        }
    }
    
    // remove headers layout attributes
    [modifiedAttributesArray removeObjectsAtIndexes:attributesToRemoveIdxs];
    
    // layout all headers needed for the rect using self code
    [missingSections enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:idx];
        UICollectionViewLayoutAttributes *layoutAttributes = [self layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader atIndexPath:indexPath];
        [modifiedAttributesArray addObject:layoutAttributes];
    }];
    return  modifiedAttributesArray;
}


- (UICollectionViewLayoutAttributes *)initialLayoutAttributesForAppearingSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if (self.layoutType == XWCollectionViewFlowLayoutTypeStickHeader) {
        UICollectionViewLayoutAttributes *attributes = [self layoutAttributesForSupplementaryViewOfKind:kind atIndexPath:indexPath];
        return attributes;
    }
    return [super initialLayoutAttributesForAppearingSupplementaryElementOfKind:kind atIndexPath:indexPath];
    
}
- (UICollectionViewLayoutAttributes *)finalLayoutAttributesForDisappearingSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if (self.layoutType == XWCollectionViewFlowLayoutTypeStickHeader) {
        UICollectionViewLayoutAttributes *attributes = [self layoutAttributesForSupplementaryViewOfKind:kind atIndexPath:indexPath];
        return attributes;
    }
    
    return [super finalLayoutAttributesForDisappearingSupplementaryElementOfKind:kind atIndexPath:indexPath];
}

- (BOOL) shouldInvalidateLayoutForBoundsChange:(CGRect)newBound {
    if (self.layoutType == XWCollectionViewFlowLayoutTypeStickHeader || self.layoutType == XWCollectionViewFlowLayoutStretchyHeader ) {
        return YES;
    }
    return [super shouldInvalidateLayoutForBoundsChange:newBound];
    
}


-(UICollectionViewLayoutAttributes *) getHeaderAttributesForVerticalWithSection:(NSInteger)section fromOffset:(CGPoint *) offset{
    CGSize headerSize = [self headerSizeWithSection:section];
    // 头部
    if (headerSize.height > 0 ) {
        UICollectionViewLayoutAttributes * arrtibute = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader withIndexPath:[NSIndexPath indexPathForRow:0 inSection:section]];
        arrtibute.frame = CGRectMake(0, (*offset).y, headerSize.width, headerSize.height);
        return arrtibute;
    }
    return nil;
}

-(UICollectionViewLayoutAttributes *) getDecorationViewAttributesForVerticalWithSection:(NSInteger)section fromOffset:(CGPoint *) offset headerY:(CGFloat)headerY{
    Class cla = [self getDecorationViewClassWithSecion:section];
    if (cla) {
        [self registerClass:cla forDecorationViewOfKind:NSStringFromClass(cla)];
        UICollectionViewLayoutAttributes * att = [UICollectionViewLayoutAttributes layoutAttributesForDecorationViewOfKind:NSStringFromClass(cla) withIndexPath:[NSIndexPath indexPathForRow:0 inSection:section]];
        att.frame = CGRectMake(0, headerY , self.collectionView.frame.size.width, (*offset).y - headerY);
        att.zIndex = -1;
        return att;
    }
    return nil;
    
}


-(UICollectionViewLayoutAttributes *) getDecorationViewAttributesForHorizalWithSection:(NSInteger)section fromOffset:(CGPoint *) offset headerX:(CGFloat)headerX{
    Class cla = [self getDecorationViewClassWithSecion:section];
    if (cla) {
        [self registerClass:cla forDecorationViewOfKind:NSStringFromClass(cla)];
        UICollectionViewLayoutAttributes * att = [UICollectionViewLayoutAttributes layoutAttributesForDecorationViewOfKind:NSStringFromClass(cla) withIndexPath:[NSIndexPath indexPathForRow:0 inSection:section]];
        att.frame = CGRectMake(headerX, 0 , (*offset).x - headerX,self.collectionView.frame.size.height);
        att.zIndex = -1;
        return att;
    }
    return nil;
    
}

// 水平布局
-(UICollectionViewLayoutAttributes *) getHeaderAttributesForHorizalWithSection:(NSInteger)section fromOffset:(CGPoint *) offset{
    CGSize headerSize = [self headerSizeWithSection:section];
    // 头部
    if (headerSize.width > 0 ) {
        UICollectionViewLayoutAttributes * arrtibute = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader withIndexPath:[NSIndexPath indexPathForRow:0 inSection:section]];
        arrtibute.frame = CGRectMake((*offset).x, 0, headerSize.width, headerSize.height);
        
        return arrtibute;
    }
    return nil;
}


-(UICollectionViewLayoutAttributes *) getFooterAttributesForHorizalWithSection:(NSInteger)section fromOffset:(CGPoint *) offset{
    CGSize footerSize = [self footerSizeWithSection:section];
    if (footerSize.width > 0) {
        UICollectionViewLayoutAttributes * arrtibute = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionFooter withIndexPath:[NSIndexPath indexPathForRow:0 inSection:section]];
        arrtibute.frame = CGRectMake((*offset).x - footerSize.width, 0, footerSize.width, footerSize.height);
        return arrtibute;
    }
    return nil;
}

-(UICollectionViewLayoutAttributes *) getFooterAttributesForVerticalWithSection:(NSInteger)section fromOffset:(CGPoint *) offset{
    CGSize footerSize = [self footerSizeWithSection:section];
    
    if (footerSize.height > 0) {
        UICollectionViewLayoutAttributes * arrtibute = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionFooter withIndexPath:[NSIndexPath indexPathForRow:0 inSection:section]];
        arrtibute.frame = CGRectMake(0, (*offset).y - footerSize.height, footerSize.width, footerSize.height);
        return arrtibute;
    }
    return nil;
}

-(NSMutableArray * )  getCellsAttributesForVerticalWithSection:(NSInteger )section fromOffset:(CGPoint *)offset{
    CGFloat lineSpace = [self minimumLineSpacingWithSection:section];
    CGFloat itemSpace = [self minimumInteritemSpacingWithSection:section];
    UIEdgeInsets sectionInset = [self sectionInsetWithSecion:section];
    CGSize headerSize = [self headerSizeWithSection:section];
    CGSize footerSize = [self footerSizeWithSection:section];
    NSInteger count = [self numOfItemInSection:section];
    NSMutableArray * array = [NSMutableArray new];
    if (count > 0) {
        // cells
        CGSize itemSize = [self itemSizeWithSection:section row:0];
        CGFloat width = (self.collectionView.frame.size.width - sectionInset.left - sectionInset.right );
        int rows = (width + itemSpace) / (itemSize.width + itemSpace);
        if (rows > 0) {
            if (rows - 1 >0) {
                itemSpace = (width - itemSize.width * rows) / (rows - 1);
            }else {
                itemSpace = (width - itemSize.width ) / 2;
            }
            CGFloat offsetX = (rows == 1)?(sectionInset.left + itemSpace) : sectionInset.left;
            CGFloat initValue = (*offset).y + headerSize.height + sectionInset.top - lineSpace;
            NSMutableArray * heightArray = [self createArrayWithSize:rows initValue:initValue];
            for (int i = 0 ; i < count ; i++) {
                itemSize = [self itemSizeWithSection:section row:i];
                
                CGFloat addHeight = itemSize.height + lineSpace;// 添加了一个cell所在列增加到高度
                // 每次在最低列添加cell
                NSInteger row = [self minHeightInRowWithArray:heightArray];
                CGFloat rowHeight = [self rowHeightWithArray:heightArray index:row];
                
                [self addHeightInArray:heightArray index:row height:addHeight];
                
                UICollectionViewLayoutAttributes * arrtibute = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:[NSIndexPath indexPathForRow:i inSection:section]];
                CGFloat x = offsetX + (row * (itemSize.width + itemSpace));
                arrtibute.frame = CGRectMake( x, rowHeight + lineSpace, itemSize.width, itemSize.height);
                [array addObject:arrtibute];
            }
            // 维护偏移量
            (*offset).y = [self maxHeightInArray:heightArray] + sectionInset.bottom + footerSize.height ;
        }else {
            assert(0); // itemSize.width过大
        }
    }else{
        // 维护偏移量
        (*offset).y = (*offset).y +  headerSize.height + footerSize.height + sectionInset.top + sectionInset.bottom;
    }
    
    return array;
}

// 水平布局
-(NSMutableArray * )  getCellsAttributesForHorizalWithSection:(NSInteger )section fromOffset:(CGPoint *)offset{
    CGFloat lineSpace = [self minimumLineSpacingWithSection:section];
    CGFloat itemSpace = [self minimumInteritemSpacingWithSection:section];
    UIEdgeInsets sectionInset = [self sectionInsetWithSecion:section];
    CGSize headerSize = [self headerSizeWithSection:section];
    CGSize footerSize = [self footerSizeWithSection:section];
    NSInteger count = [self numOfItemInSection:section];
    NSMutableArray * array = [NSMutableArray new];
    if (count > 0) {
        // cells
        CGSize itemSize = [self itemSizeWithSection:section row:0];
        CGFloat height = (self.collectionView.frame.size.height - sectionInset.top - sectionInset.bottom );
        int rows = (height + lineSpace) / (itemSize.height + lineSpace);
        if (rows > 0) {
            if (rows - 1 >0) {
                lineSpace = (height - itemSize.height * rows) / (rows - 1);
            }else {
                lineSpace = (height - itemSize.height ) / 2;
            }
            CGFloat offsetY = (rows == 1)?(sectionInset.top + lineSpace) : sectionInset.top;
            CGFloat initValue = (*offset).x + headerSize.width + sectionInset.left - itemSpace;
            NSMutableArray * heightArray = [self createArrayWithSize:rows initValue:initValue];
            for (int i = 0 ; i < count; i++) {
                itemSize = [self itemSizeWithSection:section row:i];
                
                CGFloat addHeight = itemSize.width + itemSpace;// 添加了一个cell所在列增加到高度
                // 每次在最低列添加cell
                NSInteger row = [self minHeightInRowWithArray:heightArray];
                CGFloat rowHeight = [self rowHeightWithArray:heightArray index:row];
                
                [self addHeightInArray:heightArray index:row height:addHeight];
                
                UICollectionViewLayoutAttributes * arrtibute = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:[NSIndexPath indexPathForRow:i inSection:section]];
                CGFloat y = offsetY + (row * (itemSize.height + lineSpace));
                arrtibute.frame = CGRectMake(rowHeight + itemSpace , y, itemSize.width, itemSize.height);
                [array addObject:arrtibute];
            }
            // 维护偏移量
            (*offset).x = [self maxHeightInArray:heightArray] + sectionInset.right + footerSize.width ;
        }else {
            assert(0); // itemSize.width过大
        }
    }else{
        // 维护偏移量
        (*offset).x = (*offset).x +  headerSize.width + footerSize.width + sectionInset.left + sectionInset.right;
    }
    
    return array;
}


-(NSMutableArray *) getAttributesWithSection:(NSInteger) section fromOffset:(CGPoint *) offset {
    NSMutableArray * attributesArray = [NSMutableArray new];
    // 纵向布局
    if (self.verticalDir) {
        // 头部
        
        CGFloat headerY = (*offset).y;
        UICollectionViewLayoutAttributes * headerAtt = [self getHeaderAttributesForVerticalWithSection:section fromOffset:offset];
        if (headerAtt) {
            [attributesArray addObject:headerAtt];
        }
        // cells
        NSMutableArray * cellAtts = [self getCellsAttributesForVerticalWithSection:section fromOffset:offset];
        [attributesArray addObjectsFromArray:cellAtts];
        // 尾部
        UICollectionViewLayoutAttributes * footerAtt = [self getFooterAttributesForVerticalWithSection:section fromOffset:offset];
        if (footerAtt) {
            [attributesArray addObject:footerAtt];
        }
        
        // 装饰
        
        UICollectionViewLayoutAttributes * decorationAtt = [self getDecorationViewAttributesForVerticalWithSection:section fromOffset:offset headerY:headerY];
        if (decorationAtt) {
            [self.decroationViewAttsArray addObject:decorationAtt];
        }
        
    }else {
        // 横向布局
        // 头部
        CGFloat headerX = (*offset).x;
        UICollectionViewLayoutAttributes * headerAtt = [self getHeaderAttributesForHorizalWithSection:section fromOffset:offset];
        if (headerAtt) {
            [attributesArray addObject:headerAtt];
        }
        // cells
        NSMutableArray * cellAtts = [self getCellsAttributesForHorizalWithSection:section fromOffset:offset];
        [attributesArray addObjectsFromArray:cellAtts];
        // 尾部
        UICollectionViewLayoutAttributes * footerAtt = [self getFooterAttributesForHorizalWithSection:section fromOffset:offset];
        if (footerAtt) {
            [attributesArray addObject:footerAtt];
        }
        // 装饰
        
        UICollectionViewLayoutAttributes * decorationAtt = [self getDecorationViewAttributesForHorizalWithSection:section fromOffset:offset headerX:headerX];
        if (decorationAtt) {
            [self.decroationViewAttsArray addObject:decorationAtt];
        }
        
        
    }
    return attributesArray;
}




-(NSInteger) numOfSection{
    if ([self.collectionView.dataSource respondsToSelector:@selector(numberOfSectionsInCollectionView:)]) {
        
        return [self.collectionView numberOfSections];
    }
    return 0;
}

-(NSInteger ) numOfItemInSection:(NSInteger) section{
    if (section < [self numOfSection]) {
        if ([self.collectionView.dataSource respondsToSelector:@selector(collectionView:numberOfItemsInSection:)]) {
            return [self.collectionView numberOfItemsInSection:section];
        }
    }
    return 0;
}

-(CGFloat)minimumLineSpacingWithSection:(NSInteger) section{
    if ([self.delegate respondsToSelector:@selector(collectionView:layout:minimumLineSpacingForSectionAtIndex:)]) {
        return [self.delegate collectionView:self.collectionView layout:self minimumLineSpacingForSectionAtIndex:section];
    }
    return self.minimumLineSpacing;
}

-(CGFloat)minimumInteritemSpacingWithSection:(NSInteger) section{
    if ([self.delegate respondsToSelector:@selector(collectionView:layout:minimumInteritemSpacingForSectionAtIndex:)]) {
        return [self.delegate collectionView:self.collectionView layout:self minimumInteritemSpacingForSectionAtIndex:section];
    }
    return self.minimumInteritemSpacing;
}

-(UIEdgeInsets)sectionInsetWithSecion:(NSInteger)section{
    if ([self.delegate respondsToSelector:@selector(collectionView:layout:insetForSectionAtIndex:)]) {
        return [self.delegate collectionView:self.collectionView layout:self insetForSectionAtIndex:section];
    }
    return self.sectionInset;
}

-(CGSize) headerSizeWithSection:(NSInteger)section{
    if ([self.delegate respondsToSelector:@selector(collectionView:layout:referenceSizeForHeaderInSection:)]) {
        return [self.delegate collectionView:self.collectionView layout:self referenceSizeForHeaderInSection:section];
    }
    return self.headerReferenceSize;
}

-(Class) getDecorationViewClassWithSecion:(NSInteger) section{
    if ([self.collectionView isKindOfClass:[UICollectionView class]]) {
        UICollectionView * collectionView = (UICollectionView *)self.collectionView;
        if ([collectionView.xw_dataSource respondsToSelector:@selector(decorationViewClassListWithCollectionView:)]) {
            NSArray * array = [collectionView.xw_dataSource decorationViewClassListWithCollectionView:collectionView];
            if (array.count > section) {
                return [array objectAtIndex:section];
            }
        }
    }
    return nil;
}


-(CGSize) footerSizeWithSection:(NSInteger)section{
    if ([self.delegate respondsToSelector:@selector(collectionView:layout:referenceSizeForFooterInSection:)]) {
        return [self.delegate collectionView:self.collectionView layout:self referenceSizeForFooterInSection:section];
    }
    return self.footerReferenceSize;
}

-(CGSize) itemSizeWithSection:(NSInteger) section row:(NSInteger)row{
    if ([self.delegate respondsToSelector:@selector(collectionView:layout:sizeForItemAtIndexPath:)]) {
        return [self.delegate collectionView:self.collectionView layout:self sizeForItemAtIndexPath:[NSIndexPath indexPathForRow:row inSection:section]];
    }
    return self.itemSize;
}

-(id<UICollectionViewDelegateFlowLayout>)delegate{
    if (!_delegate) {
        _delegate = (id<UICollectionViewDelegateFlowLayout>)self.collectionView.dataSource;
    }
    return _delegate;
}

-(NSMutableArray *) createArrayWithSize:(int) size initValue:(int) value{
    NSMutableArray * array = [NSMutableArray new];
    for (int i = 0 ; i < size ; i++) {
        NSNumber * num = [NSNumber numberWithFloat:value];
        [array addObject:num];
    }
    return array;
}

-(void) addHeightInArray:(NSMutableArray *)array index:(NSInteger)index height:(CGFloat)height{
    NSNumber * num = [array objectAtIndex:index];
    num = [NSNumber numberWithFloat:num.floatValue + height];
    [array replaceObjectAtIndex:index withObject:num];
}

-(CGFloat) rowHeightWithArray:(NSMutableArray *)array index:(NSInteger) index{
    NSNumber * num = [array objectAtIndex:index];
    return num.floatValue;
}

-(NSUInteger) minHeightInRowWithArray:(NSMutableArray *)array{
    
    NSUInteger minIndex = 0;
    for (int i = 1 ; i < array.count; i++) {
        NSNumber * num = [array objectAtIndex:i];
        NSNumber * minNum = [array objectAtIndex:minIndex];
        if (minNum.floatValue > num.floatValue) {
            minIndex = i;
        }
    }
    return minIndex;
}

-(NSUInteger) maxHeightInRowWithArray:(NSMutableArray *)array{
    
    NSUInteger maxIndex = 0;
    for (int i = 1 ; i < array.count; i++) {
        NSNumber * num = [array objectAtIndex:i];
        NSNumber * minNum = [array objectAtIndex:maxIndex];
        if (minNum.floatValue < num.floatValue) {
            maxIndex = i;
        }
    }
    return maxIndex;
}

-(CGFloat) maxHeightInArray:(NSMutableArray *)array{
    NSInteger index = [self maxHeightInRowWithArray:array];
    NSNumber * num =  [array objectAtIndex:index];
    return num.floatValue;
}


-(NSMutableArray * )  getAttributesInRectWithArray:(NSMutableArray *)array from:(NSInteger)from to:(NSInteger)to{
    UICollectionViewLayoutAttributes * fromAtt = [array objectAtIndex:from];
    
    UICollectionViewLayoutAttributes * toAtt = [array objectAtIndex:to];
    
    
    if ([self isContainRectWithLeftAttribute:fromAtt rightAttribute:toAtt] == false) {
        return nil;
    }
    if (fromAtt == toAtt) {
        return [NSMutableArray arrayWithObjects:fromAtt, nil];
    }
    NSInteger divide = (from + to) / 2;
    NSMutableArray * leftArray = [self getAttributesInRectWithArray:array from:from to:divide];
    NSMutableArray * rightArray = [self getAttributesInRectWithArray:array from:divide + 1 to:to];
    NSMutableArray * result = leftArray;
    if (result) {
        if (rightArray) {
            [result addObjectsFromArray:rightArray];
        }
    }else {
        result = rightArray;
    }
    return result;
}


-(BOOL) isContainRectWithLeftAttribute:(UICollectionViewLayoutAttributes *)left rightAttribute:(UICollectionViewLayoutAttributes *)right{
    
    if (self.verticalDir) {
        CGFloat top = left.frame.origin.y ;
        CGFloat bottom = right.frame.origin.y  + right.frame.size.height;
        if ((self.rect.origin.y > bottom)||
            (self.rect.origin.y + self.rect.size.height < top)) {
            return false;
        }else {
            return true;
        }
    }else {
        CGFloat top = left.frame.origin.x ;
        CGFloat bottom = right.frame.origin.x  + right.frame.size.width;
        if ((self.rect.origin.x > bottom)||
            (self.rect.origin.x + self.rect.size.width < top)) {
            return false;
        }else {
            return true;
        }
    }
}


-(NSMutableArray *)attributesArrayInRect{
    if (self.attributesArray.count > 0) {
        _attributesArrayInRect = [self getAttributesInRectWithArray:self.attributesArray from:0 to:self.attributesArray.count - 1];
        [_attributesArrayInRect addObjectsFromArray:self.decroationViewAttsArray];
    }else {
        _attributesArrayInRect = [NSMutableArray new];
    }
    return _attributesArrayInRect;
    
}

-(BOOL)verticalDir{
    return self.scrollDirection == UICollectionViewScrollDirectionVertical;
}

-(NSMutableArray *)decroationViewAttsArray{
    if (!_decroationViewAttsArray) {
        if (self.layoutType == XWCollectionViewFlowLayoutTypePlain || self.layoutType == XWCollectionViewFlowLayoutHistory || self.layoutType == XWCollectionViewFlowLayoutTypeStickHeader) {
            _decroationViewAttsArray = [NSMutableArray new];
            int  section = (int)self.sectionNum;
            for (int i = 0; i < section; i++) {
                if (true) {
                    
                    UICollectionViewLayoutAttributes  * first = [self firstAttributeWithSection:i];
                    UICollectionViewLayoutAttributes  * last = [self lastAttributeWithSection:i];
                    
                    UICollectionViewLayoutAttributes * decorationViewAtt = [self getDecorationViewAttributesWithSection:i firstAtt:first lastAtt:last];
                    if (decorationViewAtt) {
                        [_decroationViewAttsArray addObject:decorationViewAtt];
                    }
                    
                }
            }
        }
    }
    return  _decroationViewAttsArray;
}

-(UICollectionViewLayoutAttributes *) firstAttributeWithSection:(NSUInteger)section{
    CGSize size = [self headerSizeWithSection:section];
    UICollectionViewLayoutAttributes  * first = nil;
    if ( size.width > 0 && size.height > 0 && self.layoutType != XWCollectionViewFlowLayoutTypeStickHeader) {
        first = [self layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader atIndexPath:[NSIndexPath indexPathForRow:0 inSection:section]];
    }else {
        if ([self numOfItemInSection:section]) {
            first = [self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:section]];
        }
    }
    return first;
}

-(UICollectionViewLayoutAttributes *) lastAttributeWithSection:(NSUInteger)section{
    CGSize size = [self footerSizeWithSection:section];
    UICollectionViewLayoutAttributes  * last = nil;
    if (size.width > 0 && size.height > 0) {
        last = [self layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionFooter atIndexPath:[NSIndexPath indexPathForRow:0 inSection:section]];
    }else {
        NSUInteger numItems = [self numOfItemInSection:section];
        if (numItems) {
            last = [self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForRow:numItems - 1 inSection:section]];
        }
    }
    return last;
}
-(UICollectionViewLayoutAttributes *) getDecorationViewAttributesWithSection:(NSInteger)section firstAtt:(UICollectionViewLayoutAttributes *)firstAtt lastAtt:(UICollectionViewLayoutAttributes *)lastAtt{
    if (firstAtt == nil) {
        firstAtt = lastAtt;
    }
    Class cla = [self getDecorationViewClassWithSecion:section];
    if (cla && firstAtt) {
        
        [self registerClass:cla forDecorationViewOfKind:NSStringFromClass(cla)];
        UICollectionViewLayoutAttributes * att = [UICollectionViewLayoutAttributes layoutAttributesForDecorationViewOfKind:NSStringFromClass(cla) withIndexPath:[NSIndexPath indexPathForRow:0 inSection:section]];
        if (self.verticalDir) {
            CGFloat minY = CGRectGetMinY(firstAtt.frame);
            if (firstAtt.representedElementCategory == UICollectionElementCategoryCell) {
                minY -= [self sectionInsetWithSecion:section].top;
            }
            CGFloat maxY = CGRectGetMaxY(lastAtt.frame);
            if (lastAtt.representedElementCategory == UICollectionElementCategoryCell) {
                maxY += [self sectionInsetWithSecion:section].bottom;
            }
            
//            if (self.decorationContainHeader) {
//                UICollectionView * collectionView = (UICollectionView *)self.collectionView;
//                if ([collectionView.xw_dataSource respondsToSelector:@selector(headerDataListWithCollectionView:)]) {
//                    NSArray * array = [collectionView.xw_dataSource headerDataListWithCollectionView:collectionView];
//                    if (array.count > section) {
//                        
//                        NSObject *header = array[section];
//                        minY -= header.cell_height;
//                    }
//                }
//
//            }
            
            CGFloat height = maxY - minY;
            att.frame = CGRectMake(0, minY, self.collectionView.frame.size.width, height);
        }else {
            CGFloat minX = CGRectGetMinX(firstAtt.frame);
            if (firstAtt.representedElementCategory == UICollectionElementCategoryCell) {
                minX -= [self sectionInsetWithSecion:section].left;
            }
            
            CGFloat maxX = CGRectGetMaxX(lastAtt.frame);
            if (lastAtt.representedElementCategory == UICollectionElementCategoryCell) {
                maxX += [self sectionInsetWithSecion:section].right;
            }
            CGFloat width = maxX - minX;
            att.frame = CGRectMake(minX, 0, width , self.collectionView.frame.size.height);
        }
        att.zIndex = -1;
        return att;
    }
    return nil;
    
}
@end
