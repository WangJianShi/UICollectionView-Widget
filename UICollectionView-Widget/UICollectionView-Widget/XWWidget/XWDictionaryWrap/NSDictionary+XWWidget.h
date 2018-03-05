//
//  NSDictionary+XWWidget.h
//  XWNewWidgetDemo
//
//  Created by serein on 2017/12/22.
//  Copyright © 2017年 wangjianshi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSDictionary (XWWidget)

-(NSDictionary *(^) (NSString *))reuseIdentifier;

-(NSDictionary *(^) (CGFloat height))height;

-(NSDictionary *(^) (CGFloat width))width;

@end
