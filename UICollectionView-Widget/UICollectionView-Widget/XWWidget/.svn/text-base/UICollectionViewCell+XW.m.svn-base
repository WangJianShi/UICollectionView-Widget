//
//  UICollectionViewCell+XW.m
//  
//
//  Created by serein on 2017/11/6.
//  Copyright © 2017年 wangjianshi. All rights reserved.
//

#import "UICollectionViewCell+XW.h"
#import <objc/runtime.h>
#import "XWWeakObject.h"

@implementation UICollectionViewCell (XW)

#pragma mark -
#pragma mark - public

- (void)reuseWithData:(NSObject *)data indexPath:(NSIndexPath *)indexPath NS_REQUIRES_SUPER{
    self.xw_data = data;
    self.xw_indexPath = indexPath;
}

-(CGSize)cell_size{
    
    UIView * view = self;
    if ([self isKindOfClass:[UICollectionViewCell class]])
    {
        view = [self performSelector:@selector(contentView)];
    }
    
    CGFloat width = self.cell_width;
    CGFloat height = self.cell_height;
    
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

- (CGFloat)cell_width{
    if ([self isVerticalLayout])
    {
        UIEdgeInsets insets = [self _seciontInset];
        return self.xw_collectionView.frame.size.width - insets.left - insets.right;
    }
    return 0;
}

- (CGFloat)cell_height{
    if (![self isVerticalLayout])
    {
        UIEdgeInsets insets = [self _seciontInset];
        return self.xw_collectionView.frame.size.height - insets.top - insets.bottom;
    }
    return 0;
}


- (void)xw_didSelectCell{
    
}

- (void)xw_didDeselectCell{
    
}

- (void)xw_willDisplayCell{
    
}

- (BOOL)xw_shouldSelectCell{
    return true;
}

- (BOOL)xw_shouldDeselectCell{
    return true;
}

- (BOOL)xw_shouldHighlightCell{
    return true;
}

- (void)xw_didHighlightCell{
    
}

- (void)xw_didUnhighlightCell{
    
}

#pragma mark -
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
            if (constraint.constant != width)
            {
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

#pragma mark -
#pragma mark - getter settter


-(void)setSeparatorInset:(UIEdgeInsets)separatorInset{
    
    
    if ( !UIEdgeInsetsEqualToEdgeInsets(self.separatorInset, separatorInset)) {
        
        objc_setAssociatedObject(self, @selector(separatorInset), [NSValue valueWithUIEdgeInsets:separatorInset]  , OBJC_ASSOCIATION_ASSIGN);
        
        UIView *bottomView = [self separatorView];
        
        bottomView.translatesAutoresizingMaskIntoConstraints = NO;
        
        NSLayoutConstraint *bottom = [NSLayoutConstraint constraintWithItem:bottomView
                                                                  attribute:NSLayoutAttributeBottom
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:self
                                                                  attribute:NSLayoutAttributeBottom
                                                                 multiplier:1
                                                                   constant:0];
        
        NSLayoutConstraint *left = [NSLayoutConstraint constraintWithItem:bottomView
                                                                attribute:NSLayoutAttributeLeft
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:self
                                                                attribute:NSLayoutAttributeLeft
                                                               multiplier:1
                                                                 constant:separatorInset.left];
        
        NSLayoutConstraint *right = [NSLayoutConstraint constraintWithItem:bottomView
                                                                 attribute:NSLayoutAttributeRight
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self
                                                                 attribute:NSLayoutAttributeRight
                                                                multiplier:1
                                                                  constant:-separatorInset.right];
        
        NSDictionary *views = NSDictionaryOfVariableBindings(bottomView);
        
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[bottomView(==1)]"
                                                                     options:0
                                                                     metrics:nil
                                                                       views:views]];
        
        
        
        [self addConstraints:@[bottom,left,right]];
 
    }
}

-(UIEdgeInsets)separatorInset{
    
    return  [objc_getAssociatedObject(self, @selector(separatorInset)) UIEdgeInsetsValue];
}

-(UIColor *)separatorColor{
    
    return objc_getAssociatedObject(self, @selector(separatorColor));
}

-(void)setSeparatorColor:(UIColor *)separatorColor{
    
    objc_setAssociatedObject(self, @selector(separatorColor), separatorColor, OBJC_ASSOCIATION_RETAIN);
    UIView *bottomView = [self separatorView];
    bottomView.backgroundColor = separatorColor;
    if (UIEdgeInsetsEqualToEdgeInsets(self.separatorInset, UIEdgeInsetsZero)) {
        
        self.separatorInset = UIEdgeInsetsZero;
    }
}

-(UIView *)separatorView{
    UIView *bottomView = objc_getAssociatedObject(self, @selector(separatorView));
    if (!bottomView) {
        bottomView = [[UIView alloc] init];
        bottomView.backgroundColor = [UIColor blackColor];
        [self.contentView addSubview:bottomView];
        [self.contentView bringSubviewToFront:bottomView];
        objc_setAssociatedObject(self, @selector(separatorView), bottomView, OBJC_ASSOCIATION_RETAIN);
    }
    return bottomView;
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


