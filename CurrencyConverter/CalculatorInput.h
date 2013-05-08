//
//  CalculatorInput.h
//  CurrencyConverter
//
//  Created by yutao on 13-4-1.
//  Copyright (c) 2013年 wyn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Calculator.h"

typedef enum {
    OperatorPlus = 1,
    OperatorMinus,
    OperatorMulti,
    OperatorDivide,
    
}Operator;

@protocol CalculatorInput <UIKeyInput>

@property (nonatomic, strong) Calculator *calculator;
- (void)operates:(Operator)oper;
- (void)equalsTo;
- (void)clears;
@end