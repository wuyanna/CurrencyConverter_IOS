//
//  CountryListViewController.h
//  CurrencyConverter
//
//  Created by yutao on 13-3-17.
//  Copyright (c) 2013年 wyn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Currency.h"

@protocol CurrencyPickerViewControllerDelegate;
@interface CurrencyPickerViewController : UIViewController {
    NSArray *allCurrenciesList;
    NSArray *allCurrenciesIndexes;
    NSDictionary *currenciesDict;
}

@property (nonatomic,strong) IBOutlet UITableView *tableView;
@property (nonatomic, assign) id<CurrencyPickerViewControllerDelegate> currencyPickerDelegate;
@end


@protocol CurrencyPickerViewControllerDelegate <NSObject>
// delegate is responsible for dismissing the picker

- (void)currencyPickerViewController:(CurrencyPickerViewController *)picker didSelectCurrency:(Currency *)currency;


- (void)currencyPickerViewControllerDidCancel:(CurrencyPickerViewController *)picker;

@end