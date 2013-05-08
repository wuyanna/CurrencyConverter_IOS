//
//  Calculator.m
//  CurrencyConverter
//
//  Created by yutao on 13-4-3.
//  Copyright (c) 2013年 wyn. All rights reserved.
//

#import "Calculator.h"

@interface Calculator () {
    NSMutableArray *_calcNumStack;
    NSMutableArray *_calcOperStack;
    NSArray *_bakNumStack;
    NSArray *_bakOperStack;
    double _lastOperand;
    double _lastResult;
    NSString *_lastOper;
}

@end

@implementation Calculator

+ (Calculator *)defaultCalculator {
    static Calculator *ins = nil;
    if (ins ==  nil) {
        ins = [[Calculator alloc] init];
    }
    return ins;
}

- (id) init {
    self = [super init];
    if (self) {
        _calcNumStack = [NSMutableArray arrayWithCapacity:10];
        _calcOperStack = [NSMutableArray arrayWithCapacity:5];
    }
    return self;
}

- (void)reset {
    [_calcOperStack removeAllObjects];
    [_calcNumStack removeAllObjects];
}

- (double)repeatEquals {
    return [self operate:_lastOper lOperand:_lastResult rOperand:_lastOperand];
}

- (void)pushOperand:(NSNumber*)numberStr {
    _lastOperand = [numberStr doubleValue];
    [_calcNumStack addObject:numberStr];
}

- (void)pushOperator:(NSString*)operStr {
    _lastOper = operStr;
    _bakNumStack = [NSArray arrayWithArray:_calcNumStack];
    _bakOperStack = [NSArray arrayWithArray:_calcOperStack];
    while ([self isOperator:[_calcOperStack lastObject] priorOrEqualToOperator:operStr]) {
        [self runResult];
    }
    [_calcOperStack addObject:operStr];
    
}

- (void)runResult {
    NSString *topStackOper = [_calcOperStack pop];
    double operB = [[_calcNumStack pop] doubleValue];
    double operA = [[_calcNumStack pop] doubleValue];
    NSNumber *numResult = [NSNumber numberWithDouble:[self operate:topStackOper lOperand:operA rOperand:operB]];
    [self pushOperand:numResult];
}

- (void)changeOperator:(NSString *)operStr {
    if (![operStr isEqualToString:[_calcOperStack lastObject]]) {
        [_calcOperStack removeLastObject];
        _calcNumStack = [NSMutableArray arrayWithArray:_bakNumStack];
        _calcOperStack = [NSMutableArray arrayWithArray:_bakOperStack];
        [self pushOperator:operStr];
    }
    
}

- (double)operate:(NSString *)oper lOperand:(double)lOperand rOperand:(double)rOperand {
    if ([oper isEqualToString:@"+"]) {
        return lOperand + rOperand;
    } else if ([oper isEqualToString:@"-"]) {
        return lOperand - rOperand;
    } else if ([oper isEqualToString:@"*"]) {
        return lOperand * rOperand;
    } else if ([oper isEqualToString:@"/"]) {
        return lOperand / rOperand;
    }
    return 0;
}

- (double)result {
    return [[_calcNumStack lastObject] doubleValue];
}



// priority larger than or equal to
- (BOOL)isOperator:(NSString *)operStrA priorOrEqualToOperator:(NSString *)operStrB {
    if (operStrA == nil || operStrB == nil) {
        return NO;
    }
    if ([operStrA isEqualToString:@"*"] || [operStrA isEqualToString:@"/"]) {
        return YES;
    }else {
        if ([operStrB isEqualToString:@"+"] || [operStrB isEqualToString:@"-"]) {
            return YES;
        }
    }
    return NO;
}

@end

@implementation NSMutableArray (Stack)

- (id)pop {
    id obj = [self lastObject];
    [self removeLastObject];
    return obj;
}

@end
