//
//  CurrencyPair.h
//  CurrencyConverter
//
//  Created by yutao on 13-3-22.
//  Copyright (c) 2013年 wyn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Currency.h"

@interface CurrencyPair : NSObject

@property (nonatomic,strong) Currency *baseCurrency;
@property (nonatomic,strong) Currency *targetCurrency;
@property (nonatomic,assign) double baseValue;
@property (nonatomic,readonly) double targetValue;

- (id)initWithBaseCurrency:(Currency *)baseCurrency targetCurrency:(Currency *)targetCurrecy baseVaule:(double)value;
@end
