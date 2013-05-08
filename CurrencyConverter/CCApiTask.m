//
//  CCApiTask.m
//  CurrencyConverter
//
//  Created by yutao on 13-3-18.
//  Copyright (c) 2013年 wyn. All rights reserved.
//

#import "CCApiTask.h"
#import "JSONParser.h"

@implementation CCApiTask

- (id)initWithURL:(NSURL *)url delegate:(id<HttpTaskDelegate>)delegate {
    self = [self initWithURL:url delegate:delegate parser:[JSONParser parser]];
    if (self) {
        
    }
    return self;
}

- (void)taskDidFinish {
    if (![self.result valueForKey:@"error"]) {
        _apiStatus = ApiStatusError;
    }
}


- (ApiStatus)apiStatus {
    return _apiStatus;
}

@end
