//
//  CalCurrencyView.m
//  CurrencyConverter
//
//  Created by yutao on 13-3-26.
//  Copyright (c) 2013年 wyn. All rights reserved.
//

#import "CalCurrencyView.h"

@implementation CalCurrencyView

@synthesize toCurrency = _toCurrency;
@synthesize fromCurrency = _fromCurrency;
@synthesize currencySelected;
@synthesize delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code

    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (IBAction)currencyBtnTouched:(id)sender {
    if (sender == toCurrencyBtn) {
        currencySelected = CurrencySelectedTo;
    } else {
        currencySelected = CurrencySelectedFrom;
    }
    if ([delegate respondsToSelector:@selector(currencyView:currencySelected:)]) {
        [delegate currencyView:self currencySelected:currencySelected];
    }
}

- (IBAction)switchCurrecny:(id)sender {
    Currency *temp = self.toCurrency;
    self.toCurrency = self.fromCurrency;
    self.fromCurrency = temp;
    if ([delegate respondsToSelector:@selector(currencyViewDidSwitch:)]) {
        [delegate currencyViewDidSwitch:self];
    }
}

- (void)setToCurrency:(Currency *)toCurrency {
    if (![_toCurrency isEqual:toCurrency]) {
        _toCurrency = toCurrency;
        [toCurrencyBtn setTitle:_toCurrency.code forState:UIControlStateNormal];
        [toCurrencyBtn setImage:_toCurrency.flag forState:UIControlStateNormal];
    }
    
}

- (void)setFromCurrency:(Currency *)fromCurrency {
    if (![_fromCurrency isEqual:fromCurrency]) {
        _fromCurrency = fromCurrency;
        [fromCurrencyBtn setTitle:_fromCurrency.code forState:UIControlStateNormal ];
        [fromCurrencyBtn setImage:_fromCurrency.flag forState:UIControlStateNormal];
    }
}

@end
