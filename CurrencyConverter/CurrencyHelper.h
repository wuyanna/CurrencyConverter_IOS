//
//  CurrencyHelper.h
//  CurrencyConverter
//
//  Created by yutao on 13-3-16.
//  Copyright (c) 2013年 wyn. All rights reserved.
//
//  Get the latest rates from api. If network fails, use the latest version from local.


#import <Foundation/Foundation.h>
#import "Currency.h"
#import "CCApiTask.h"

@interface CurrencyHelper : NSObject <HttpTaskDelegate> 

+ (CurrencyHelper *)sharedInstance;

- (NSArray *)currenciesList;
- (void)refreshRate;
- (NSDictionary *)dictionaryOfCurrencies;
- (NSDictionary *)dictionaryOfRates;
- (void)initialize;
@end