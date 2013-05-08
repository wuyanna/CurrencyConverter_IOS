//
//  JSONParser.m
//  CurrencyConverter
//
//  Created by yutao on 13-3-22.
//  Copyright (c) 2013年 wyn. All rights reserved.
//

#import "JSONParser.h"

@implementation JSONParser

+ (JSONParser *)parser {
    static JSONParser *ins = nil;
    if (ins == nil) {
        ins = [[JSONParser alloc] init];
    }
    return ins;
}

- (id)parseWithData:(NSData *)data {
    NSError *err = nil;
    id res = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&err];
    if (err!=nil) {
        return nil;
    }
    
    return res;
}
@end
