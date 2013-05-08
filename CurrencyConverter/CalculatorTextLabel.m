//
//  CalculatorTextLabel.m
//  CurrencyConverter
//
//  Created by yutao on 13-4-1.
//  Copyright (c) 2013年 wyn. All rights reserved.
//

#import "CalculatorTextLabel.h"
#import "NumPad.h"

@implementation CalculatorTextLabel

@synthesize inputView = _inputView;
@synthesize inputAccessoryView = _inputAccessoryView;
@synthesize calculator = _calculator;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self initialize];
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

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initialize];
    }
    return self;
}

- (void)initialize {
    shouldClearBeforeInsert = YES;
    couldChangeOperator = NO;
}

- (void)equalsTo {
    [self.calculator pushOperand:[NSNumber numberWithDouble:[self.text doubleValue]]];
    [self.calculator runResult];
    self.text = [NSString stringWithFormat:@"%f",[self.calculator result]];
    couldChangeOperator = NO;
    shouldClearBeforeInsert = YES;
    [self.calculator reset];
}

- (void)operates:(Operator)oper {
    
    NSString *operStr = nil;
    switch (oper) {
        case OperatorPlus:
            operStr = @"+";
            break;
        case OperatorMinus:
            operStr = @"-";
            break;
        case OperatorMulti:
            operStr = @"*";
            break;
        case OperatorDivide:
            operStr = @"/";
            break;
        default:
            break;
    }
    if (couldChangeOperator == YES) {
        [self.calculator changeOperator:operStr];
    } else {
        [self.calculator pushOperand:[NSNumber numberWithDouble:[self.text doubleValue]]];
        [self.calculator pushOperator:operStr];
    }
    
    self.text = [NSString stringWithFormat:@"%f",[self.calculator result]];
    shouldClearBeforeInsert = YES;
    couldChangeOperator = YES;
}

- (void)insertText:(NSString *)text {
    if (shouldClearBeforeInsert) {
        self.text = @"";
    }
    if ([text isEqualToString:@"."]) {
        if ([self.text rangeOfString:@"."].location != NSNotFound) {
            return;
        }
        if ([self.text length] == 0) {
            self.text = @"0";
        }
    
    }
    if ([self.text isEqualToString:@"0"]) {
        if (![text isEqualToString:@"."]) {
            self.text = @"";
        }
    }
    
    [super insertText:text];
    couldChangeOperator = NO;
    shouldClearBeforeInsert = NO;
}

- (void)clears {
    self.text = @"0";
    [self.calculator reset];
    couldChangeOperator = NO;
    shouldClearBeforeInsert = YES;
}

- (UIView *)inputView {
    previousText = self.text;
    
    NumPad *numpad = [NumPad defaultNumPad];
    numpad.input = self;
    
    return numpad;
}

- (UIView *)inputAccessoryView {
    if (!_inputAccessoryView) {
        _inputAccessoryView = [[[NSBundle mainBundle] loadNibNamed:@"NumPad" owner:self options:nil] objectAtIndex:1];
        UIButton *cancelBtn = (UIButton *)[_inputAccessoryView viewWithTag:1];
        UIButton *doneBtn = (UIButton *)[_inputAccessoryView viewWithTag:2];
        [cancelBtn addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
        [doneBtn addTarget:self action:@selector(doneAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _inputAccessoryView;
}

- (void)cancelAction {
    self.text = previousText;
    [self resignFirstResponder];
}

- (void)doneAction {
    previousText = nil;
    [self resignFirstResponder];
}

@end
