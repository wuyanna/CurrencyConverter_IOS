//
//  CurrencyHelper.m
//  CurrencyConverter
//
//  Created by yutao on 13-3-16.
//  Copyright (c) 2013年 wyn. All rights reserved.
//

#import "CurrencyHelper.h"

#define APP_ID @"d9515ef399ec4c7390502f1eb1fdda84"
#define LATEST_RATE_URL [NSString stringWithFormat:@"http://openexchangerates.org/api/latest.json?app_id=%@",APP_ID]
#define CODE_URL [NSString stringWithFormat:@"http://openexchangerates.org/api/currencies.json?app_id=%@",APP_ID]

@interface CurrencyHelper  () {
    CCApiTask *rateTask;
    CCApiTask *codeTask;
    NSInteger timestamp;
    NSDictionary *_rates;
    NSDictionary *_currenciesDict;
    NSArray *_currenciesList;
    NSTimer *_timer;
}
@end

@implementation CurrencyHelper

+ (CurrencyHelper *)sharedInstance {
    
    static CurrencyHelper *ins;
    if (ins == nil) {
        ins = [[CurrencyHelper alloc] init];
    }
    return ins;
}

- (id)init {
    self = [super init];
    if (self) {
        
        
        NSError *err = nil;
        NSString *path = [[NSBundle mainBundle] pathForResource:@"currencies" ofType:@"json"];
        NSData *currenciesData = [NSData dataWithContentsOfFile:path];
        _currenciesDict = [NSJSONSerialization JSONObjectWithData:currenciesData options:NSJSONReadingAllowFragments error:&err];
        if (err != nil) {
            return nil;
        }
        NSMutableArray *arr = [NSMutableArray arrayWithCapacity:[_currenciesDict count]];
        [_currenciesDict enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            Currency *cur = [[Currency alloc] initWithCode:key name:obj];
            [arr addObject:cur];
        }];
        _currenciesList = [NSArray arrayWithArray:arr];

        
        NSFileManager *manager = [NSFileManager defaultManager];
        NSString *rPath = [self pathForLocalLatestRates];
        _rates = [NSDictionary dictionaryWithContentsOfFile:[manager fileExistsAtPath:path]?rPath:[[NSBundle mainBundle] pathForResource:@"latestrates" ofType:@"plist"]];
    }
    return self;
}

- (void)initialize {
    [self refreshRate];
}

- (NSString *)pathForLocalLatestRates {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    return [NSString stringWithFormat:@"%@/latestrates.plist",[paths objectAtIndex:0]];
}

- (NSArray *)currenciesList {
    return _currenciesList;
}

- (void)refreshRate {
    [self getLatestRateFromApi];
}

- (void)getCurrenciesFromApi {
    codeTask = [[CCApiTask alloc] initWithURL:[NSURL URLWithString:CODE_URL] delegate:self];
    [codeTask start];
}

- (void)getLatestRateFromApi {
    [[NSNotificationCenter defaultCenter] postNotificationName:RateStartUpdateNotification object:nil userInfo:nil];
    rateTask = [[CCApiTask alloc] initWithURL:[NSURL URLWithString:LATEST_RATE_URL] delegate:self];
    [rateTask start];
    
}

- (NSDictionary *)dictionaryOfCurrencies {
    return _currenciesDict;
}
- (NSDictionary *)dictionaryOfRates {
    return _rates;
}

- (NSDate *)lastUpdatedTime {
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    return [def objectForKey:@"last_update_time"];
}

- (void)setLastUpdatedTime:(NSDate *)date {
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    [def setObject:date forKey:@"last_update_time"];
}

- (void)updateTimeLimitExpired {
    [[NSNotificationCenter defaultCenter] postNotificationName:RateCouldUpdateNotification object:nil userInfo:nil];
}

- (void)httpTaskDidFinish:(HttpTask *)httpTask {
    if (httpTask == codeTask) {
        
    }
    
    if (httpTask == rateTask) {
        NSDictionary *rateResult = rateTask.result;
        if ([rateResult valueForKey:@"rates"]) {
            _rates = [rateResult valueForKey:@"rates"];
            NSDate *now = [NSDate date];
            [self setLastUpdatedTime:now];
            [NSTimer scheduledTimerWithTimeInterval:60 target:self selector:@selector(updateTimeLimitExpired) userInfo:nil repeats:NO];
            
            NSError *err = nil;
            NSData *rateData = [NSPropertyListSerialization dataWithPropertyList:_rates format:NSPropertyListXMLFormat_v1_0 options:NSPropertyListMutableContainersAndLeaves error:&err];
            if (err == nil) {
                NSString *path = [self pathForLocalLatestRates];
                NSFileManager *manager = [NSFileManager defaultManager];
                if (![manager fileExistsAtPath:path]) {
                    if (![manager createFileAtPath:path contents:rateData attributes:nil]) {
                        NSLog(@"err create:%@",err);
                    } 
                } else {
                    [rateData writeToFile:path atomically:YES];
                }
            } else {
                NSLog(@"err:%@",err);
            }
            
            [[NSNotificationCenter defaultCenter] postNotificationName:RateUpdatedNotification object:nil userInfo:nil];
        }
        else {
            NSLog(@"Wrong data:%@",rateResult);
            [[NSNotificationCenter defaultCenter] postNotificationName:RateUpdateFailedNotification object:nil userInfo:nil];
        }
    }
}

- (void)httpTask:(HttpTask *)httpTask didFailWithError:(NSError *)error {
    if (httpTask == codeTask) {
        
    }
    
    if (httpTask == rateTask) {
        [[NSNotificationCenter defaultCenter] postNotificationName:RateUpdateFailedNotification object:nil userInfo:nil];
    }
}

@end
