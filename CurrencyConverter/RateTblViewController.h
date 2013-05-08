//
//  RateTblViewController.h
//  CurrencyConverter
//
//  Created by yutao on 13-3-16.
//  Copyright (c) 2013年 wyn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Currency.h"
#import "CurrencyPickerViewController.h"
#import "FigureTextLabel.h"

@interface RateTblViewController : UITableViewController<CurrencyPickerViewControllerDelegate,FigureTextLabelDelegate> {
    Currency *_baseCurrency;
    double _baseValue;
    NSInteger _selectedRow;
}

@end
