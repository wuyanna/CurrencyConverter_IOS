//
//  CurrencyConverterTests.m
//  CurrencyConverterTests
//
//  Created by yutao on 13-3-14.
//  Copyright (c) 2013年 wyn. All rights reserved.
//

#import "CurrencyConverterTests.h"

@implementation CurrencyConverterTests

- (void)setUp
{
    [super setUp];
    self.helper = [UserDefaultsHelper sharedInstance];
    
    [self setBaseCurrency];
    [self setInputCurrency];
}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}

- (void)testSharedInstance {
    UserDefaultsHelper *helper = [UserDefaultsHelper sharedInstance];
    STAssertNotNil(self.helper, @"UserDefaultsHelper sharedInstance failed");
    STAssertNotNil(helper, @"UserDefaultsHelper sharedInstance failed");
    STAssertEquals(helper, self.helper, @"UserDefaultsHelper sharedInstance failed, not singletone");
}

- (void)testUserCurrencies {
    NSArray *currencies = [self.helper userCurrencies];
    STAssertNotNil(currencies, @"testuserCurrencies fail");
    
    
}

- (void)setBaseCurrency {
    Currency *currency = [[Currency alloc]initWithCode:@"EUR"];
    [self.helper setBaseCurrency:currency baseValue:2.00];
}

- (void)testBaseCurrencyWithBaseValue {
    double value = 0.00;
    double value2 = 2.00;
    Currency *currency = [self.helper baseCurrencyWithBaseValue:&value];
    STAssertNotNil(currency, @"base currency is nil");
    
    STAssertTrue([@"EUR" isEqualToString:currency.code], @"base currency not equals to saved EUR");
    STAssertEquals(value, value2, @"base value not equals to saved 2.00");
}

- (void)setInputCurrency {
    Currency *currency = [[Currency alloc]initWithCode:@"EUR"];
    Currency *currency2 = [[Currency alloc]initWithCode:@"GBP"];
    [self.helper setInputCurrency:currency inputValue:2.00 outputCurrency:currency2];
}

- (void)testLoadInputCurrency {
    Currency *currency = nil;
    Currency *currency2 = nil;
    double value = 0.0;
    double value2 = 2.00;
    
    [self.helper loadInputCurrency:&currency outputCurrency:&currency2 inputValue:&value];
    STAssertNotNil(currency, @"input currency is nil");
    STAssertTrue([@"EUR" isEqualToString:currency.code], @"input currency not equals to saved EUR");
    
    STAssertNotNil(currency2, @"output currency is nil");
    STAssertTrue([@"GBP" isEqualToString:currency2.code], @"out currency not equals to saved GBP");
    
    STAssertEquals(value, value2, @"input value not equals to saved 2.00");
    
}

- (void)testExample
{
    //STFail(@"Unit tests are not implemented yet in CurrencyConverterTests");
}

@end
