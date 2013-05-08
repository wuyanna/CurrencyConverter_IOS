//
//  Currency.m
//  CurrencyConverter
//
//  Created by yutao on 13-3-15.
//  Copyright (c) 2013年 wyn. All rights reserved.
//

#import "Currency.h"
#import "CurrencyHelper.h"

@implementation Currency

@synthesize code;
@synthesize currencyName;
@synthesize flag;

- (id)initWithCode:(NSString *)aCode {
    self = [super init];
    if (self) {
        NSDictionary *codesDict = [[CurrencyHelper sharedInstance]dictionaryOfCurrencies];
        currencyName = [codesDict objectForKey:aCode];
        if (!currencyName) {
            return nil;
        }
        code = aCode;
        
    }
    return self;
}

- (id)initWithCode:(NSString *)aCode name:(NSString *)aName {
    self = [super init];
    if (self) {
        currencyName = aName;
        code = aCode;
        
    }
    return self;
}

- (UIImage *)flag {
    return [UIImage imageNamed:[NSString stringWithFormat:@"x_%@",[self.code lowercaseString]]];
}

- (double)rateAgainstCurrency:(Currency *)currency {
    NSDictionary *rateDict = [[CurrencyHelper sharedInstance] dictionaryOfRates];
    double rate = [[rateDict objectForKey:code] doubleValue];
    double currencyRate = [[rateDict objectForKey:currency.code] doubleValue];
    if (currencyRate == 0) {
        return 0;
    }
    return rate / currencyRate;
}

+ (Currency *)defaultBaseCurrency {
    return [[self alloc] initWithCode:@"USD"];
}

+ (Currency *)defaultTargetCurrency {
    return [[self alloc] initWithCode:@"EUR"];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"%@ - %@",code,currencyName];
}

- (BOOL)isEqual:(id)object {
    if ([object isMemberOfClass:[Currency class]]) {
        Currency *cur = (Currency *)object;
        if ([cur.code isEqualToString:self.code] && [cur.currencyName isEqualToString:self.currencyName]) {
            return YES;
        }
    }
    return NO;
}
@end
