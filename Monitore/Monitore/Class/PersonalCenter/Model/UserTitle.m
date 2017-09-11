//
//  userTitle.m
//  Monitore
//
//  Created by kede on 2017/9/11.
//  Copyright © 2017年 kede. All rights reserved.
//

#import "UserTitle.h"

@implementation UserTitle

// 归档方法 编码成可以持久化的格式(归档时调用)
-(void)encodeWithCoder:(NSCoder *)aCoder
{
    // 对每一个属性都要进行重新编码
    // 注意:属性的类型
    [aCoder encodeObject:self.pcs forKey:@"pcs"];
    [aCoder encodeObject:self.nickname forKey:@"nickname"];
    [aCoder encodeInteger:self.stars forKey:@"stars"];
    [aCoder encodeInteger:self.score forKey:@"score"];
    [aCoder encodeObject:self.usersId forKey:@"usersId"];
    [aCoder encodeObject:self.mobile forKey:@"mobile"];
}

// 反归档方法 解码的过程(反归档时调用)
-(id)initWithCoder:(NSCoder *)aDecoder
{
    //
    self = [super init];
    if (self) {
        
        // 解码的过程
        // 和编码一样 除了对象类型外也是有特殊解码方法
        // 注意:编码时候给的key要和解码key一样
        self.pcs = [aDecoder decodeObjectForKey:@"pcs"];
        self.nickname = [aDecoder decodeObjectForKey:@"nickname"];
        self.stars = [aDecoder decodeObjectForKey:@"stars"];
        self.score = [aDecoder decodeObjectForKey:@"score"];
        self.usersId = [aDecoder decodeObjectForKey:@"usersId"];
        self.mobile = [aDecoder decodeObjectForKey:@"mobile"];
    }
    return self;
    
}

@end
