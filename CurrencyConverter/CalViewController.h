//
//  CalViewController.h
//  CurrencyConverter
//
//  Created by yutao on 13-3-15.
//  Copyright (c) 2013年 wyn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CurrencyPickerViewController.h"
#import "CalCurrencyView.h"
#import "CalculatorTextLabel.h"
#import "NumPad.h"

@interface CalViewController : UIViewController<CurrencyPickerViewControllerDelegate,FigureTextLabelDelegate,CalCurrencyViewDelegate> {
    
    IBOutlet CalCurrencyView        *currencyView;
    IBOutlet CalculatorTextLabel    *inputLbl;
    IBOutlet UILabel                *outputLbl;
    NumPad                          *numPad;
    CurrencySelected                currencyState;
    
}

@end
