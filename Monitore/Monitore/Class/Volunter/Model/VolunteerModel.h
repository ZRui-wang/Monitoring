//
//  VolunteerModel.h
//  Monitore
//
//  Created by kede on 2017/9/20.
//  Copyright © 2017年 kede. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VolModel : NSObject

@property (copy, nonatomic) NSString *name;



@end


@interface VolunteerModel : NSObject

@property (strong, nonatomic) NSArray *volunteer;
@property (copy, nonatomic) NSString *towns;



@end
