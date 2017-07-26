//
//  NSArray+LjAdd.m
//  Monitore
//
//  Created by kede on 2017/7/25.
//  Copyright © 2017年 kede. All rights reserved.
//

#import "NSArray+LjAdd.h"

@implementation NSArray (LjAdd)

- (id)objectAtIndexCheck:(NSUInteger)index
{
    if (index >= [self count]) {
        return nil;
    }
    
    id value = [self objectAtIndex:index];
    if (value == [NSNull null]) {
        return nil;
    }
    return value;
}

@end
