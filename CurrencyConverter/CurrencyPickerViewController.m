//
//  CountryListViewController.m
//  CurrencyConverter
//
//  Created by yutao on 13-3-17.
//  Copyright (c) 2013年 wyn. All rights reserved.
//

#import "CurrencyPickerViewController.h"
#import "CurrencyHelper.h"

@interface CurrencyPickerViewController ()

@end

@implementation CurrencyPickerViewController
@synthesize currencyPickerDelegate;
- (id)init
{
    self = [super initWithNibName:@"CurrencyPickerViewController" bundle:nil];
    if (self) {
        // Custom initialization
        self.title = @"Currency Select";
        allCurrenciesList = [[CurrencyHelper sharedInstance] currenciesList];

        
        NSMutableDictionary *tempDict = [[NSMutableDictionary alloc] initWithCapacity:26];
        for (Currency *currency in allCurrenciesList) {
            NSString *initial = [currency.code substringToIndex:1];
            NSMutableArray *indexList = [tempDict objectForKey:initial];
            if (indexList == nil) {
                indexList = [NSMutableArray arrayWithCapacity:10];
                [tempDict setObject:indexList forKey:initial];
            }
            [indexList addObject:currency];
    
        }
        currenciesDict = [NSDictionary dictionaryWithDictionary:tempDict];
        allCurrenciesIndexes = [[tempDict allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (Currency *)currencyAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    return [[currenciesDict objectForKey:[allCurrenciesIndexes objectAtIndex:section]] objectAtIndex:row];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return [currenciesDict count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [[currenciesDict objectForKey:[allCurrenciesIndexes objectAtIndex:section]] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CurrencyCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.textLabel.font = [UIFont systemFontOfSize:15];
    }
    Currency *currency = [self currencyAtIndexPath:indexPath];
    cell.textLabel.text = [NSString stringWithFormat:@"%@ - %@",currency.code,currency.currencyName];
    cell.imageView.image = currency.flag;
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

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
    Currency *currency = [self currencyAtIndexPath:indexPath];
    if ([self.currencyPickerDelegate respondsToSelector:@selector(currencyPickerViewController:didSelectCurrency:)]) {
        [self.currencyPickerDelegate currencyPickerViewController:self didSelectCurrency:currency];
    }
    
}



- (IBAction)cancelPicker:(id)sender {
    if ([self.currencyPickerDelegate respondsToSelector:@selector(currencyPickerViewControllerDidCancel:)]) {
        [self.currencyPickerDelegate currencyPickerViewControllerDidCancel:self];
    }
}

@end
