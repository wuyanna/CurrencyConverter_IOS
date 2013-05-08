//
//  RateTblViewController.m
//  CurrencyConverter
//
//  Created by yutao on 13-3-16.
//  Copyright (c) 2013年 wyn. All rights reserved.
//

#import "RateTblViewController.h"
#import "UserDefaultsHelper.h"
#import "RateCell.h"
#import "CurrencyPickerViewController.h"
#import "Calculator.h"
#import "WebViewController.h"
#import "CurrencyHelper.h"

@interface RateTblViewController () 
@end

@implementation RateTblViewController

- (id)init
{
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
        // Custom initialization
        self.title = @"My Rate Table";
        self.tabBarItem.image = [UIImage imageNamed:@"tab_2"];
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
        [self.tableView reloadData];
        self.navigationItem.leftBarButtonItem.enabled = NO;
    } else if ([name isEqualToString:RateStartUpdateNotification]) {
        self.navigationItem.leftBarButtonItem.enabled = NO;
    } else if ([name isEqualToString:RateUpdateFailedNotification]) {
        self.navigationItem.leftBarButtonItem.enabled = YES;
    }
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refreshRates)];
    
    // Uncomment the following line to preserve selection between presentations.
    self.clearsSelectionOnViewWillAppear = YES;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    _baseCurrency = [[UserDefaultsHelper sharedInstance] baseCurrencyWithBaseValue:&_baseValue];
    _selectedRow = [self rowForCurrency:_baseCurrency];
}

- (void)refreshRates {
    [[CurrencyHelper sharedInstance]refreshRate];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [[[UserDefaultsHelper sharedInstance]userCurrencies]count]+1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    NSArray *userCurrencies = [[UserDefaultsHelper sharedInstance]userCurrencies];
    BOOL isRateCell = row < [userCurrencies count] ? true : false;

    static NSString *CellIdentifierRate = @"RateCell";
    static NSString *CellIdentifierAdd = @"AddCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:isRateCell?CellIdentifierRate:CellIdentifierAdd];
    if (cell == nil) {
        NSArray *cells = [[NSBundle mainBundle]loadNibNamed:@"RateCell" owner:nil options:nil];
        cell = (UITableViewCell *)[cells objectAtIndex:isRateCell?0:1];
    }
    
    if (isRateCell) {
        RateCell *rateCell = (RateCell *)cell;
        [rateCell setTarget:self action:@selector(pushWeb:)];
        rateCell.valueLbl.delegate = self;
        rateCell.valueLbl.calculator = [Calculator defaultCalculator];
        Currency *currency = [userCurrencies objectAtIndex:indexPath.row];
        rateCell.pair = [[CurrencyPair alloc] initWithBaseCurrency:_baseCurrency targetCurrency:currency baseVaule:_baseValue];
        rateCell.valueEditing = (_selectedRow == row)?YES:NO;
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
}


// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    if (indexPath.row >= [[[UserDefaultsHelper sharedInstance]userCurrencies] count]) {
        return NO;
    }
    return YES;
}



// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        Currency *currency = [self currencyAtRow:indexPath.row];
        if ([[UserDefaultsHelper sharedInstance] removeUserCurrency:currency]) {
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        } else {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Cannot Delete The Currency!" message:@"There should be at least 2 currencies in the table" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
        
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    NSArray *userCurrencies = [[UserDefaultsHelper sharedInstance]userCurrencies];
    if (row < [userCurrencies count]) {
        
        RateCell *oldCell = (RateCell *)[tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:_selectedRow inSection:0]];
        if (_selectedRow==indexPath.row) {
            [oldCell becomeFirstResponder];
            return;
        }
        
        if (oldCell.isValueEditing == YES) {
            oldCell.valueEditing = NO;
        }
        
        _selectedRow = row;
        
        RateCell *cell = (RateCell*)[tableView cellForRowAtIndexPath:indexPath];
        _baseCurrency = cell.pair.targetCurrency;
        _baseValue = cell.pair.targetValue;
        if (cell.isValueEditing == NO) {
            cell.valueEditing = YES;
        }
        
        [[UserDefaultsHelper sharedInstance] setBaseCurrency:_baseCurrency baseValue:_baseValue];
        [self.tableView reloadData];
        
    } else {
        CurrencyPickerViewController *picker = [[CurrencyPickerViewController alloc] init];
        picker.currencyPickerDelegate = self;
        [self.navigationController presentViewController:picker animated:YES completion:nil];
        [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
    
}

- (void)currencyPickerViewController:(CurrencyPickerViewController *)picker didSelectCurrency:(Currency *)currency {
    if ([[UserDefaultsHelper sharedInstance] addUserCurrency:currency]) {
        [self.tableView reloadData];
    }
    [picker dismissViewControllerAnimated:YES completion:nil];

}

- (void)currencyPickerViewControllerDidCancel:(CurrencyPickerViewController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (NSInteger)rowForCurrency:(Currency *)currency {
    NSInteger row = 0;
    for (Currency *cur in [[UserDefaultsHelper sharedInstance]userCurrencies]) {
        if ([currency.code isEqualToString:cur.code]) {
            row = [[[UserDefaultsHelper sharedInstance] userCurrencies] indexOfObject:cur];
        }
    }
    return row;
}

- (Currency *)currencyAtRow:(NSInteger)row {
    NSArray *currencies = [[UserDefaultsHelper sharedInstance]userCurrencies];
    if (row < [currencies count]) {
        return [currencies objectAtIndex:row];
    }
    return nil;
}

- (void)textLabelDidEndEditing:(FigureTextLabel *)textLbl {
    _baseValue = [textLbl.text doubleValue];
    if (_baseValue == 0) {
        _baseValue = 1;
        textLbl.text = @"1.00";
    }
    [[UserDefaultsHelper sharedInstance] setBaseCurrency:_baseCurrency baseValue:_baseValue];
    [self.tableView reloadData];
}
- (void)textLabelDidBeginEditing:(FigureTextLabel *)textLbl {
    CalculatorTextLabel *calbl = (CalculatorTextLabel *)textLbl;
    [calbl initialize];
}

- (void)pushWeb:(NSURL *)url {
    WebViewController *wikiView = [[WebViewController alloc] init];
    [self.navigationController pushViewController:wikiView animated:YES];
    wikiView.title = @"Wiki";
    [wikiView loadURl:url];
}

@end
