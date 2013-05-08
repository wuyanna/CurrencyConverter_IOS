//
//  CalViewController.m
//  CurrencyConverter
//
//  Created by yutao on 13-3-15.
//  Copyright (c) 2013年 wyn. All rights reserved.
//

#import "CalViewController.h"
#import "Currency.h"
#import "UserDefaultsHelper.h"
#import "CurrencyHelper.h"

@interface CalViewController ()

@end

@implementation CalViewController

- (id)init
{
    self = [super initWithNibName:@"Calculator" bundle:[NSBundle mainBundle]];
    if (self) {
        // Custom initialization
        self.title = @"Quick Convert";
        self.tabBarItem.image = [UIImage imageNamed:@"tab_1"];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(rateUpdated:) name:RateUpdatedNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(rateUpdated:) name:RateUpdateFailedNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(rateUpdated:) name:RateStartUpdateNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(rateUpdated:) name:RateCouldUpdateNotification object:nil];
    }
    return self;
}

- (void)rateUpdated:(NSNotification *)notification {
    NSString *name = notification.name;
    if ([name isEqualToString:RateCouldUpdateNotification]) {
        self.navigationItem.leftBarButtonItem.enabled = YES;
    } else if ([name isEqualToString:RateUpdatedNotification]) {
        [self outputValue];
        self.navigationItem.leftBarButtonItem.enabled = NO;
    } else if ([name isEqualToString:RateStartUpdateNotification]) {
        self.navigationItem.leftBarButtonItem.enabled = NO;
    } else if ([name isEqualToString:RateUpdateFailedNotification]) {
        self.navigationItem.leftBarButtonItem.enabled = YES;
    }
    
}
- (void)outputValue {
    double output = [currencyView.toCurrency rateAgainstCurrency:currencyView.fromCurrency]*[inputLbl.text doubleValue];
    outputLbl.text = [NSString stringWithFormat:@"%f",output];
}

- (void)currencyPickerViewControllerDidCancel:(CurrencyPickerViewController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)currencyPickerViewController:(CurrencyPickerViewController *)picker didSelectCurrency:(Currency *)currency {
    
    if (currencyState == CurrencySelectedFrom) {
        currencyView.fromCurrency = currency;
    } else {
        currencyView.toCurrency = currency;
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
    [self outputValue];
}

- (void)currencyView:(CalCurrencyView *)currencyView currencySelected:(CurrencySelected)selected {
    currencyState = selected;
    
    CurrencyPickerViewController *picker = [[CurrencyPickerViewController alloc] init];
    picker.currencyPickerDelegate = self;
    
    [self presentViewController:picker animated:YES completion:nil];
}

- (void)currencyViewDidSwitch:(CalCurrencyView *)currencyView {
    [self outputValue];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refreshRates)];
    Currency *inCur = nil;
    Currency *outCur = nil;
    double value = 1.00;
    currencyView.delegate = self;
    [[UserDefaultsHelper sharedInstance]loadInputCurrency:&inCur outputCurrency:&outCur inputValue:&value];
    [currencyView setFromCurrency:inCur];
    [currencyView setToCurrency:outCur];
    
    
    NSArray *views = [[NSBundle mainBundle] loadNibNamed:@"NumPad" owner:self options:nil];
    numPad = [views objectAtIndex:0];
    
    CGRect rect = numPad.frame;
    rect.origin.y = inputLbl.frame.origin.y + 40;
    numPad.frame = rect;
    [self.view addSubview:numPad];
    numPad.input = inputLbl;
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setFormatterBehavior:NSNumberFormatterBehavior10_4];
    [formatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    inputLbl.formatter = formatter;
    inputLbl.delegate = self;
    inputLbl.text = [NSString stringWithFormat:@"%f",value];
    Calculator *calc = [[Calculator alloc] init];
    inputLbl.calculator = calc;
}

- (void)refreshRates {
    [[CurrencyHelper sharedInstance]refreshRate];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)textLabelDidChange:(FigureTextLabel *)textLbl {
    [self outputValue];
}

@end
