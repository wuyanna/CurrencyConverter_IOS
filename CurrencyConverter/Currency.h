//
//  Currency.h
//  CurrencyConverter
//
//  Created by yutao on 13-3-15.
//  Copyright (c) 2013年 wyn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Currency : NSObject

@property (nonatomic, readonly) NSString    *code;
@property (nonatomic, readonly) NSString    *currencyName;
@property (nonatomic, readonly) double     rate;   // Against USD
@property (nonatomic, readonly) UIImage     *flag;


- (double)rateAgainstCurrency:(Currency *)currency;
- (id)initWithCode:(NSString *)code;
- (id)initWithCode:(NSString *)aCode name:(NSString *)aName;
+ (Currency *)defaultBaseCurrency;
+ (Currency *)defaultTargetCurrency;
@end
