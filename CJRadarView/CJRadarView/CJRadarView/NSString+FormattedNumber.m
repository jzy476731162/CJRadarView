//
//  NSString+FormattedNumber.m
//  CJRadarView
//
//  Created by Carl Ji on 2018/4/3.
//  Copyright © 2018年 Carl Ji. All rights reserved.
//

#import "NSString+FormattedNumber.h"

@implementation NSString (FormattedNumber)

+ (NSString *)formattedFloatString:(float)f {
    if (fmodf(f, 1)==0) {//如果有一位小数点
        return [NSString stringWithFormat:@"%.0f",f];
    } else if (fmodf(f*10, 1)==0) {//如果有两位小数点
        return [NSString stringWithFormat:@"%.1f",f];
    } else {
        return [NSString stringWithFormat:@"%.2f",f];
    }
    
}

@end
