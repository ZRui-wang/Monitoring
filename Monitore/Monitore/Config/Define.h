//
//  Define.h
//  Monitore
//
//  Created by kede on 2017/7/24.
//  Copyright © 2017年 kede. All rights reserved.
//

#ifndef Define_h
#define Define_h

#pragma mark -------------- 颜色转换 ----------------------------------------------------------------------------
/**
 16进制颜色转换
 */
#define UIColorWithHex(hexValue) [UIColor colorWithRed:((float)((hexValue & 0xFF0000) >> 16))/255.0 \
green:((float)((hexValue & 0xFF00) >> 8))/255.0 \
blue:((float)(hexValue & 0xFF))/255.0 alpha:1]

/**
 获取屏幕的宽高
 */
#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)

/**
 APP主色  绿色
 */
#define kDefaultGreenColor UIColorWithHex(0x2F6DB6)
/**
 字体的灰色
 */
#define kDefaultGrayColor  UIColorWithHex(0x888888)


#define kLINK_HOST @"http://39.108.78.69:3002/mobile/"
#define Kstatus @"status"
#define Kinfo @"info"
#define Ksuccess @"200"

//MARK: - 打印
#if DEBUG
#define NSSLog(FORMAT, ...) fprintf(stderr,"[%s:%d行] %s\n",[[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String], __LINE__, [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String])
#else
#define NSLog(FORMAT, ...) nil

#endif

#endif /* Define_h */
