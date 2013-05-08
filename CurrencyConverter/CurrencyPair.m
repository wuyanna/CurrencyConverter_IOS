//
//  CurrencyPair.m
//  CurrencyConverter
//
//  Created by yutao on 13-3-22.
//  Copyright (c) 2013年 wyn. All rights reserved.
//

#import "CurrencyPair.h"

@implementation CurrencyPair
@synthesize baseCurrency;
@synthesize targetCurrency;
@synthesize baseValue;
@synthesize targetValue;

- (id)initWithBaseCurrency:(Currency *)aBaseCurrency targetCurrency:(Currency *)aTargetCurrecy baseVaule:(double)aValue {
    self = [super init];
    if (self) {
        baseCurrency = aBaseCurrency;
        targetCurrency = aTargetCurrecy;
        baseValue = aValue;
    }
    return self;
    
}

- (double)targetValue {
    return [targetCurrency rateAgainstCurrency:baseCurrency] * baseValue;
}
@end
