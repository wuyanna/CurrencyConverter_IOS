//
//  RateCell.m
//  CurrencyConverter
//
//  Created by yutao on 13-3-16.
//  Copyright (c) 2013年 wyn. All rights reserved.
//

#import "RateCell.h"
#import "NumPad.h"

@interface RateCell () {
    id _target;
    SEL _action;
}
@end
@implementation RateCell

@synthesize pair;
@synthesize valueEditing;
@synthesize valueLbl;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        
    }
    return self;
}

- (BOOL)canBecomeFirstResponder {
    return [valueLbl canBecomeFirstResponder];
}

- (BOOL)becomeFirstResponder {
    return [valueLbl becomeFirstResponder];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setPair:(CurrencyPair *)aPair {
    pair = aPair;
    Currency *baseCurrency = aPair.baseCurrency;
    Currency *targetCurrency = aPair.targetCurrency;
    
    valueLbl.text = [NSString stringWithFormat:@"%.2f",aPair.targetValue];
    rateLbl.text = [NSString stringWithFormat:@"1 %@ = %.4f %@", baseCurrency.code, [targetCurrency rateAgainstCurrency:baseCurrency], targetCurrency.code];
    codeLbl.text = targetCurrency.code;
    
    flagImg.image = targetCurrency.flag;
}

- (void)setValueEditing:(BOOL)b {
    valueEditing = b;
    rateLbl.hidden = b;
    valueLbl.textColor = b ? [UIColor blueColor] : [UIColor blackColor];
    self.contentView.backgroundColor = b ? [UIColor lightGrayColor] : [UIColor whiteColor];

}

- (void)setTarget:(id)target action:(SEL)selector {
    _target = target;
    _action = selector;
}

- (IBAction)openWiki:(id)sender {
    if ([_target respondsToSelector:_action]) {
        [_target performSelector:_action withObject:[NSURL URLWithString:[NSString stringWithFormat:@"http://en.wikipedia.org/wiki/%@",pair.targetCurrency.code]]];
    }
}

@end
