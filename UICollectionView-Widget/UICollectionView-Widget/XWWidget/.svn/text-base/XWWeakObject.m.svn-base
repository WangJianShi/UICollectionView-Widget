//
//  XWWeakObject.m
//  
//
//  Created by 王剑石 on 2017/8/19.
//  Copyright © 2017年 wangjianshi. All rights reserved.
//

#import "XWWeakObject.h"

@implementation XWWeakObject

-(instancetype)initWeakObject:(id)obj{
    _weakObject = obj;
    return self;
}

+(instancetype)proxyWeakObject:(id)obj{
    
   return  [[XWWeakObject alloc] initWeakObject:obj];
}


- (id)forwardingTargetForSelector:(SEL)selector {
    return _weakObject;
}

- (void)forwardInvocation:(NSInvocation *)invocation {
    void *null = NULL;
    [invocation setReturnValue:&null];
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)selector {
    return [NSObject instanceMethodSignatureForSelector:@selector(init)];
}

- (BOOL)respondsToSelector:(SEL)aSelector {
    return [_weakObject respondsToSelector:aSelector];
}

- (BOOL)isEqual:(id)object {
    return [_weakObject isEqual:object];
}

- (NSUInteger)hash {
    return [_weakObject hash];
}

- (Class)superclass {
    return [_weakObject superclass];
}

- (Class)class {
    return [_weakObject class];
}

- (BOOL)isKindOfClass:(Class)aClass {
    return [_weakObject isKindOfClass:aClass];
}

- (BOOL)isMemberOfClass:(Class)aClass {
    return [_weakObject isMemberOfClass:aClass];
}

- (BOOL)conformsToProtocol:(Protocol *)aProtocol {
    return [_weakObject conformsToProtocol:aProtocol];
}

- (BOOL)isProxy {
    return YES;
}

- (NSString *)description {
    return [_weakObject description];
}

- (NSString *)debugDescription {
    return [_weakObject debugDescription];
}

@end

@interface XWWeakMutableArray ()

@property (nonatomic, strong) dispatch_queue_t queue;
@property (nonatomic, strong) NSMutableArray* array;

@end

@implementation XWWeakMutableArray

- (instancetype)initCommon
{
    self = [super init];
    if (self) {
        NSString* uuid = [NSString stringWithFormat:@"com.kong.XWWeakMutableArray_%p", self];
        _queue = dispatch_queue_create([uuid UTF8String], DISPATCH_QUEUE_CONCURRENT);
    }
    return self;
}

- (instancetype)init
{
    if (self) {
        _array = [NSMutableArray array];
    }
    return self;
}

- (instancetype)initWithCapacity:(NSUInteger)numItems
{
    if (self) {
        _array = [NSMutableArray arrayWithCapacity:numItems];
    }
    return self;
}

- (NSArray *)initWithContentsOfFile:(NSString *)path
{
    if (self) {
        _array = [NSMutableArray arrayWithContentsOfFile:path];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self) {
        _array = [[NSMutableArray alloc] initWithCoder:aDecoder];
    }
    return self;
}

- (instancetype)initWithObjects:(const id [])objects count:(NSUInteger)cnt
{
    
    if (self) {
        _array = [NSMutableArray array];
        for (NSUInteger i = 0; i < cnt; ++i) {
            [_array addObject:objects[i]];
        }
    }
    return self;
}

- (NSUInteger)count
{
    __block NSUInteger count;
    dispatch_sync(self.queue, ^{
        count = _array.count;
    });
    return count;
}

- (id)objectAtIndex:(NSUInteger)index
{
    __block id obj;
    dispatch_sync(self.queue, ^{
        
         obj = _array[index];
        
    });
    return obj;
}

- (NSEnumerator *)keyEnumerator
{
    __block NSEnumerator *enu;
    dispatch_sync(self.queue, ^{
        enu = [_array objectEnumerator];
    });
    return enu;
}

- (void)insertObject:(id)anObject atIndex:(NSUInteger)index
{
    if ([[self realArray] containsObject:anObject]) {
        return;
    }
    dispatch_barrier_async(self.queue, ^{
        
        if ([anObject isMemberOfClass:[XWWeakObject class]]) {
            
            [_array insertObject:anObject atIndex:index];
        }else{
            XWWeakObject *weakObj = [XWWeakObject proxyWeakObject:anObject];
             [_array insertObject:weakObj atIndex:index];
        }
    });
}

- (void)addObject:(id)anObject;
{

    dispatch_barrier_async(self.queue, ^{
        
        if ([[self realArray] containsObject:anObject]) {
            NSLog(@"重复Delegate，自动去重!!!");
            return;
        }
        if ([anObject isMemberOfClass:[XWWeakObject class]]) {
            [_array addObject:anObject];
        }else{
            XWWeakObject *weakObj = [XWWeakObject proxyWeakObject:anObject];
            [_array addObject:weakObj];
        }
        
    });
}

- (void)removeObjectAtIndex:(NSUInteger)index
{
    dispatch_barrier_async(self.queue, ^{
        [_array removeObjectAtIndex:index];
    });
}

- (void)removeLastObject
{
    dispatch_barrier_async(self.queue, ^{
        [_array removeLastObject];
    });
}

- (void)replaceObjectAtIndex:(NSUInteger)index withObject:(id)anObject
{

    dispatch_barrier_async(self.queue, ^{
        
        if ([[self realArray] containsObject:anObject]) {
            NSLog(@"重复Delegate，自动去重!!!");
            return;
        }
        if ([anObject isMemberOfClass:[XWWeakObject class]]) {
            
            [_array replaceObjectAtIndex:index withObject:anObject];
        }else{
            XWWeakObject *weakObj = [XWWeakObject proxyWeakObject:anObject];
            [_array replaceObjectAtIndex:index withObject:weakObj];
        }
        
        
    });
}

- (NSUInteger)indexOfObject:(id)anObject
{
    __block NSUInteger index = NSNotFound;
    dispatch_sync(self.queue, ^{
        for (int i = 0; i < [_array count]; i ++) {
            if ([_array objectAtIndex:i] == anObject) {
                index = i;
                break;
            }
        }
    });
    return index;
}

- (dispatch_queue_t)queue {
    
    if (_queue == nil) {
        _queue = dispatch_queue_create("com.kong.XWWeakMutableArray", DISPATCH_QUEUE_CONCURRENT);
    }
    return _queue;
    
}

-(NSMutableArray *)realArray{
    
    NSMutableArray *reals = [NSMutableArray array];
    for (id obj in _array) {
        if ([obj isMemberOfClass:[XWWeakObject class]]) {
            XWWeakObject *weakObj = (XWWeakObject *)obj;
            [reals addObject:weakObj.weakObject];
        }else{
            [reals addObject:obj];
        }
    }
    return reals;
}

- (void)dealloc
{
    if (_queue) {
        _queue = NULL;
    }
}

@end
