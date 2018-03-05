//
//  NSDictionary+XWWidget.m
//  XWNewWidgetDemo
//
//  Created by serein on 2017/12/22.
//  Copyright © 2017年 wangjianshi. All rights reserved.
//

#import "NSDictionary+XWWidget.h"
#import "NSObject+XW.h"

@implementation NSDictionary (XWWidget)


-(NSDictionary *(^)(NSString *))reuseIdentifier{
    
    return ^(NSString *identify){
        
        self.xw_reuseIdentifier = identify;
        [self setValue:identify forKey:@"xw_reuseIdentifier"];
        return self;
    };
}

-(NSDictionary *(^)(CGFloat))height{
    
    return ^(CGFloat height){
        
        self.xw_height = height;
        [self setValue:[NSString stringWithFormat:@"%f",height] forKey:@"xw_height"];
        return self;
    };
}

-(NSDictionary *(^)(CGFloat))width{
    
    return ^(CGFloat width){
        
        self.xw_width = width;
        [self setValue:[NSString stringWithFormat:@"%f",width] forKey:@"xw_width"];
        return self;
    };
}

@end
