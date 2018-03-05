//
//  UICollectionReusableView+XW.h
//  
//
//  Created by 王剑石 on 16/12/16.
//  Copyright © 2016年 王剑石. All rights reserved.
//
//  abstract : UICollectionView头部尾部视图分类

#import "UICollectionReusableView+XW.h"
#import <objc/runtime.h>
#import "XWWeakObject.h"

@implementation UICollectionReusableView (XW)

#pragma mark -
#pragma mark - public

- (void)reuseWithData:(NSObject *)data indexPath:(NSIndexPath *)indexPath isHeader:(BOOL)bHeader NS_REQUIRES_SUPER{
    self.xw_data = data;
    self.xw_indexPath = indexPath;
    self.bHeader = bHeader;
}

-(CGSize)view_size{
    
    UIView * view = self;
    if ([self isKindOfClass:[UICollectionViewCell class]])
    {
        view = [self performSelector:@selector(contentView)];
    }
    
    CGFloat width = self.view_width;
    CGFloat height = self.view_height;
    
    if ([self isVerticalLayout] && height > 0)
    {
        return CGSizeMake(width, height);
    }
    else if(![self isVerticalLayout] && width > 0)
    {
        return CGSizeMake(width, height);
    }
    self.frame = CGRectMake(0, 0, width, height);
    if ([self isVerticalLayout])
    {
        [self updateWidthWithView:view width:width];
    }
    else
    {
        [self updateHeightWithView:view height:height];
    }
    
    CGSize  comproessedSize = [view systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    
    if ([self isVerticalLayout])
    {
        comproessedSize.width = width;
    }
    else
    {
        comproessedSize.height = height;
    }
    return comproessedSize;
}

- (CGFloat)view_width{
    if ([self isVerticalLayout])
    {
        UIEdgeInsets insets = [self _seciontInset];
        return self.xw_collectionView.frame.size.width - insets.left - insets.right;
    }
    return 0;
}

- (CGFloat)view_height{
    if (![self isVerticalLayout])
    {
        UIEdgeInsets insets = [self _seciontInset];
        return self.xw_collectionView.frame.size.height - insets.top - insets.bottom;
    }
    return 0;
}


#pragma mark - private

-(BOOL) isVerticalLayout{
    if ([self.xw_collectionView.collectionViewLayout isKindOfClass:[UICollectionViewFlowLayout class]])
    {
        UICollectionViewFlowLayout * layout = (UICollectionViewFlowLayout *)(self.xw_collectionView.collectionViewLayout);
        return layout.scrollDirection == UICollectionViewScrollDirectionVertical;
    }
    return true;
}

-(UIEdgeInsets) _seciontInset{
    if ([self.xw_collectionView.delegate respondsToSelector:@selector(collectionView:layout:insetForSectionAtIndex:)])
    {
        id<UICollectionViewDelegateFlowLayout> delegate = (id<UICollectionViewDelegateFlowLayout>)self.xw_collectionView.delegate;
        
        return [delegate collectionView:self.xw_collectionView layout:self.xw_collectionView.collectionViewLayout insetForSectionAtIndex:self.xw_indexPath.section];
    }
    return UIEdgeInsetsZero;
}

-(void) updateWidthWithView:(UIView *)view width:(CGFloat)width{
    BOOL updated = false;
    NSArray * constraints = [view.constraints copy];
    for (NSLayoutConstraint * constraint in constraints)
    {
        if (constraint.firstAttribute == NSLayoutAttributeWidth && constraint.secondAttribute == NSLayoutAttributeNotAnAttribute && constraint.relation == NSLayoutRelationEqual && constraint.secondItem == nil && constraint.multiplier == 1 && constraint.firstItem == view)
        {
            if (constraint.constant != width) {
                constraint.constant = width;
            }
            updated = true;
        }
        else if(constraint.firstAttribute == NSLayoutAttributeHeight && constraint.secondAttribute == NSLayoutAttributeNotAnAttribute && constraint.relation == NSLayoutRelationEqual && constraint.secondItem == nil && constraint.multiplier == 1 && constraint.firstItem == view)
        {
            [view removeConstraint:constraint];
        }
    }
    if (!updated)
    {
        NSLayoutConstraint * widthConstraint = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:width];
        view.translatesAutoresizingMaskIntoConstraints = NO;
        [view addConstraint:widthConstraint];;
        
    }
}

-(void) updateHeightWithView:(UIView *)view height:(CGFloat)height{
    BOOL updated = false;
    
    NSArray * constraints = [view.constraints copy];
    for (NSLayoutConstraint * constraint in constraints)
    {
        if (constraint.firstAttribute == NSLayoutAttributeHeight && constraint.secondAttribute == NSLayoutAttributeNotAnAttribute && constraint.relation == NSLayoutRelationEqual && constraint.secondItem == nil && constraint.multiplier == 1 && constraint.firstItem == view)
        {
            if (constraint.constant != height)
            {
                constraint.constant = height;
            }
            updated = true;
        }
        else if(constraint.firstAttribute == NSLayoutAttributeWidth && constraint.secondAttribute == NSLayoutAttributeNotAnAttribute && constraint.relation == NSLayoutRelationEqual && constraint.secondItem == nil && constraint.multiplier == 1 && constraint.firstItem == view)
        {
            [view removeConstraint:constraint];
        }
    }
    if (!updated)
    {
        NSLayoutConstraint * heightConstraint = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:height];
        view.translatesAutoresizingMaskIntoConstraints = NO;
        [view addConstraint:heightConstraint];;
    }
}




#pragma mark - getter settter

-(BOOL)bHeader{
    
    return [objc_getAssociatedObject(self, @selector(bHeader)) boolValue];
}

-(void)setBHeader:(BOOL)bHeader{
    
    objc_setAssociatedObject(self, @selector(bHeader), @(bHeader), OBJC_ASSOCIATION_ASSIGN);
}

-(NSObject *)xw_data{
    return objc_getAssociatedObject(self, @selector(xw_data));
}

-(void)setXw_data:(NSObject *)data{
    objc_setAssociatedObject(self, @selector(xw_data), data, OBJC_ASSOCIATION_RETAIN);
}

-(NSIndexPath *)xw_indexPath{
    return objc_getAssociatedObject(self, @selector(xw_indexPath));
}

-(void)setXw_indexPath:(NSIndexPath *)indexPath{
    objc_setAssociatedObject(self, @selector(xw_indexPath), indexPath, OBJC_ASSOCIATION_RETAIN);
}

-(UICollectionView *)xw_collectionView{
    
    XWWeakObject *weakObj= objc_getAssociatedObject(self, @selector(xw_collectionView));
    
    return  weakObj.weakObject;
}

-(void)setXw_collectionView:(UICollectionView *)collectionView{
    if (self.xw_collectionView != collectionView)
    {//为了防止循环引用套一层object
        XWWeakObject *weakCollectionviw = [[XWWeakObject alloc] initWeakObject:collectionView];
        objc_setAssociatedObject(self, @selector(xw_collectionView), weakCollectionviw, OBJC_ASSOCIATION_RETAIN);
    }
}


@end
