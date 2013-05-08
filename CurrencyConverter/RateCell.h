//
//  RateCell.h
//  CurrencyConverter
//
//  Created by yutao on 13-3-16.
//  Copyright (c) 2013年 wyn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CurrencyPair.h"
#import "CalculatorTextLabel.h"

@interface RateCell : UITableViewCell {
    
    IBOutlet CalculatorTextLabel *valueLbl;
    IBOutlet UILabel *rateLbl;
    IBOutlet UILabel *codeLbl;
    
    IBOutlet UIImageView *flagImg;
}

@property (nonatomic) IBOutlet CalculatorTextLabel *valueLbl;
@property (nonatomic, getter = isValueEditing) BOOL valueEditing;
@property (nonatomic, strong) CurrencyPair *pair;

- (void)setTarget:(id)target action:(SEL)selector;

@end
