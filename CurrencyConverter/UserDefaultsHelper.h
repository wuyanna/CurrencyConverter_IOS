//
//  UserDefaultsHelper.h
//  CurrencyConverter
//
//  Created by yutao on 13-3-16.
//  Copyright (c) 2013年 wyn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Currency.h"

@interface UserDefaultsHelper : NSObject {
    NSMutableArray *_userCurrencies;    // Array of Currency
}
+ (UserDefaultsHelper *)sharedInstance;

// Array of Currencies in Rate Table
- (NSArray *)userCurrencies;
- (BOOL)addUserCurrency:(Currency *)currency; // return NO when the selected currency is already in the list
- (BOOL)removeUserCurrency:(Currency *)currency; // retuen NO when there are less than 2 currencies in the list

// Base currency and value user selected in Rate Table
- (void)setBaseCurrency:(Currency *)currency baseValue:(double)value;
- (Currency *)baseCurrencyWithBaseValue:(double *)value;

// Currency and value entered by user in Quick Convert
- (void)setInputCurrency:(Currency *)inCurrency inputValue:(double)value outputCurrency:(Currency *)outCurrency;
- (void)loadInputCurrency:(Currency **)inCurrency outputCurrency:(Currency **)outCurrency inputValue:(double *)value;

@end
