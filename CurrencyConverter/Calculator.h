//
//  Calculator.h
//  CurrencyConverter
//
//  Created by yutao on 13-4-3.
//  Copyright (c) 2013年 wyn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Calculator : NSObject {
    
}

- (void)pushOperand:(NSNumber*)numberStr;
- (void)pushOperator:(NSString*)operStr;
- (void)changeOperator:(NSString*)operStr;
- (double)result;
+ (Calculator *)defaultCalculator;
- (void)reset;
- (void)runResult;
@end

@interface NSMutableArray (Stack)

- (id)pop;
@end