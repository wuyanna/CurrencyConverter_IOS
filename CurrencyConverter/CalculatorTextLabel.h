//
//  CalculatorTextLabel.h
//  CurrencyConverter
//
//  Created by yutao on 13-4-1.
//  Copyright (c) 2013年 wyn. All rights reserved.
//

#import "FigureTextLabel.h"
#import "CalculatorInput.h"

@interface CalculatorTextLabel : FigureTextLabel<CalculatorInput> {
    BOOL shouldClearBeforeInsert;
    BOOL couldChangeOperator;
    NSString *previousText;
}
- (void)initialize;
@property (nonatomic, readwrite, strong) UIView *inputView;
@property (nonatomic, readwrite, strong) UIView *inputAccessoryView;

@end

