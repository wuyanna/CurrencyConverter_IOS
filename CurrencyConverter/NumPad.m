//
//  NumPad.m
//  CurrencyConverter
//
//  Created by yutao on 13-3-26.
//  Copyright (c) 2013年 wyn. All rights reserved.
//

#import "NumPad.h"

@implementation NumPad

@synthesize input;

+ (NumPad *)defaultNumPad {
    static NumPad *ins = nil;
    if (ins == nil) {
        ins = [[[NSBundle mainBundle] loadNibNamed:@"NumPad" owner:self options:nil] objectAtIndex:0];
    }
    return ins;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
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

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (IBAction)valueBtn:(id)sender {
    UIButton *btn = (UIButton *)sender;
    [input insertText:btn.titleLabel.text];
}

- (IBAction)operatorBtn:(id)sender {
    UIButton *btn = (UIButton *)sender;
    [input operates:btn.tag];
}

- (IBAction)equalsToBtn:(id)sender {
    [input equalsTo];
}

- (IBAction)backDelete:(id)sender {

    [input deleteBackward];
}

- (IBAction)clear:(id)sender {
    [input clears];
}

@end
