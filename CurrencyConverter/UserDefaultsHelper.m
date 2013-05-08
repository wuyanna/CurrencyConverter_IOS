//
//  UserDefaultsHelper.m
//  CurrencyConverter
//
//  Created by yutao on 13-3-16.
//  Copyright (c) 2013年 wyn. All rights reserved.
//

#import "UserDefaultsHelper.h"

@implementation UserDefaultsHelper

+ (UserDefaultsHelper *)sharedInstance {
    static UserDefaultsHelper *ins = nil;
    if (ins == nil) {
        ins = [[UserDefaultsHelper alloc] init];
    }
    return ins;
}

- (id)init {
    self = [super init];
    if (self) {
        NSMutableArray *currencies = [self userCurrencyCodes];
        if (currencies == nil || [currencies count] < 2) {
            [currencies addObjectsFromArray:[NSArray arrayWithObjects:@"USD",@"EUR",@"GBP", nil]];
            [self setUserCurrencyCodes:currencies];
        }
        _userCurrencies = [[NSMutableArray alloc] initWithCapacity:[currencies count]];
        for (NSString *s in currencies) {
            Currency *c = [[Currency alloc]initWithCode:s];
            [_userCurrencies addObject:c];
        }
    }
    return self;
}

// Array of Codes Not public
- (NSMutableArray *)userCurrencyCodes {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults mutableArrayValueForKey:@"user_currencies"];
}

- (void)setUserCurrencyCodes:(NSMutableArray *)codes {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:codes forKey:@"user_currencies"];
}

- (NSArray *)userCurrencies {

    
    return [NSArray arrayWithArray: _userCurrencies];
}

- (BOOL)addUserCurrency:(Currency *)currency {
    if ([_userCurrencies containsObject:currency]) {
        return NO;
    }
    [_userCurrencies addObject:currency];
    NSMutableArray *codes = [self userCurrencyCodes];
    [codes addObject:currency.code];
    [self setUserCurrencyCodes:codes];
    return YES;
}

- (BOOL)removeUserCurrency:(Currency *)currency {
    if ([_userCurrencies count] <= 2) {
        return NO;
    }
    [_userCurrencies removeObject:currency];
    NSMutableArray *codes = [self userCurrencyCodes];
    [codes removeObject:currency.code];
    [self setUserCurrencyCodes:codes];
    return YES;
}

- (void)setBaseCurrency:(Currency *)currency baseValue:(double)value {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setValue:currency.code forKey:@"base_currency"];
    [defaults setDouble:value forKey:@"base_value"];
}

- (Currency *)baseCurrencyWithBaseValue:(double *)value {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *code = [defaults stringForKey:@"base_currency"];
    NSArray *currencies = [self userCurrencies];
    Currency *currency = nil;
    for (Currency *c in currencies) {
        if ([code isEqualToString:c.code]) {
            currency = c;
            *value = [defaults doubleForKey:@"base_value"]>0?[defaults doubleForKey:@"base_value"]:1.00;
        }
    }
    if (currency == nil) {
        currency = [currencies objectAtIndex:0];
        *value = 1.00;
    }
    return currency;
}

- (void)setInputCurrency:(Currency *)inCurrency inputValue:(double)value outputCurrency:(Currency *)outCurrency {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setValue:inCurrency.code forKey:@"input_currency"];
    [defaults setDouble:value forKey:@"input_value"];
    [defaults setValue:outCurrency.code forKey:@"output_currency"];
}

- (void)loadInputCurrency:(Currency **)inCurrency outputCurrency:(Currency **)outCurrency inputValue:(double *)value {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *incode = [defaults stringForKey:@"input_currency"];
    NSString *outcode = [defaults stringForKey:@"output_currency"];
    Currency *inCur = [[Currency alloc] initWithCode:incode];
    Currency *outCur = [[Currency alloc] initWithCode:outcode];
    
    *value = [defaults doubleForKey:@"input_value"]>0?[defaults doubleForKey:@"input_value"]:1.00;
    if (inCur == nil) {
        inCur = [Currency defaultBaseCurrency];
        *value = 1.00;
    }
    if (outCur == nil) {
        outCur = [Currency defaultTargetCurrency];
    }
    
    *inCurrency = inCur;
    *outCurrency = outCur;
}


@end
