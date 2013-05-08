//
//  NumPad.h
//  CurrencyConverter
//
//  Created by yutao on 13-3-26.
//  Copyright (c) 2013年 wyn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CalculatorInput.h"

@interface NumPad : UIView {

}

@property (nonatomic) id<CalculatorInput> input;

+ (NumPad *)defaultNumPad;

@end
