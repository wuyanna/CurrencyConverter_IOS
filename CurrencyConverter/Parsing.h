//
//  Parsing.h
//  CurrencyConverter
//
//  Created by yutao on 13-3-22.
//  Copyright (c) 2013年 wyn. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol Parsing <NSObject>

- (id)parseWithData:(NSData *)data;

@end
