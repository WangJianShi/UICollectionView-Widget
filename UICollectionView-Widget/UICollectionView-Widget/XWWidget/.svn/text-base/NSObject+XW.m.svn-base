//
//  NSObject+XW.m
//  
//
//  Created by 王剑石 on 16/12/16.
//  Copyright © 2016年 王剑石. All rights reserved.
//

#import "NSObject+XW.h"
#import <objc/runtime.h>

@implementation NSObject (XW)

#pragma mark -
#pragma mark - set/get

-(void)setXw_reuseIdentifier:(NSString *)xw_reuseIdentifier{
    
    objc_setAssociatedObject(self, @selector(xw_reuseIdentifier), xw_reuseIdentifier, OBJC_ASSOCIATION_RETAIN);
}

-(NSString *)xw_reuseIdentifier{
    
    NSString *reuseIdentify =  objc_getAssociatedObject(self, @selector(xw_reuseIdentifier));
    return reuseIdentify;
}


-(CGFloat)xw_width{
    NSNumber * width = objc_getAssociatedObject(self, @selector(xw_width));
    return [width floatValue];
}

-(void)setXw_width:(CGFloat)viewWidth{
    NSNumber * width = [NSNumber numberWithFloat:viewWidth];
    objc_setAssociatedObject(self, @selector(xw_width), width, OBJC_ASSOCIATION_RETAIN);
}

-(CGFloat)xw_height{
    NSNumber * height = objc_getAssociatedObject(self, @selector(xw_height));
    return [height floatValue];
}

-(void)setXw_height:(CGFloat)viewHeight{
    NSNumber * height = [NSNumber numberWithFloat:viewHeight];
    objc_setAssociatedObject(self, @selector(xw_height), height, OBJC_ASSOCIATION_RETAIN);
}

-(UIEdgeInsets)cell_secionInset{
    NSValue * sectionInsetValue = objc_getAssociatedObject(self, @selector(cell_secionInset));
    return [sectionInsetValue UIEdgeInsetsValue];
}

-(void)setCell_secionInset:(UIEdgeInsets)secionInset{
    NSValue * sectionInsetValue = [NSValue valueWithUIEdgeInsets:secionInset];
    objc_setAssociatedObject(self, @selector(cell_secionInset), sectionInsetValue, OBJC_ASSOCIATION_RETAIN);
}

-(CGFloat)cell_minimumInteritemSpacing{
    NSNumber * spacing = objc_getAssociatedObject(self, @selector(cell_minimumInteritemSpacing));
    return [spacing floatValue];
}

-(void)setCell_minimumInteritemSpacing:(CGFloat)minimumInteritemSpacing{
    NSNumber * spacing = [NSNumber numberWithFloat:minimumInteritemSpacing];
    objc_setAssociatedObject(self, @selector(cell_minimumInteritemSpacing), spacing, OBJC_ASSOCIATION_RETAIN);
}

-(CGFloat)cell_minimumLineSpacing{
    NSNumber * spacing = objc_getAssociatedObject(self, @selector(cell_minimumLineSpacing));
    return [spacing floatValue];
}

-(void)setCell_minimumLineSpacing:(CGFloat)minimumLineSpacing{
    NSNumber * spacing = [NSNumber numberWithFloat:minimumLineSpacing];
    objc_setAssociatedObject(self, @selector(cell_minimumLineSpacing), spacing, OBJC_ASSOCIATION_RETAIN);
}

-(void)setUnReusable:(BOOL)unReusable{
    
    NSNumber * reusableNumber = [NSNumber numberWithFloat:unReusable];
    objc_setAssociatedObject(self, @selector(unReusable), reusableNumber, OBJC_ASSOCIATION_RETAIN);
}

-(BOOL)unReusable{
    
    NSNumber * reusableNumber = objc_getAssociatedObject(self, @selector(unReusable));
    return [reusableNumber boolValue];
    
}

@end
