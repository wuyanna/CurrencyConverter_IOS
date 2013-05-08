//
//  CCApiTask.h
//  CurrencyConverter
//
//  Created by yutao on 13-3-18.
//  Copyright (c) 2013年 wyn. All rights reserved.
//

#import "HttpTask.h"

typedef enum {
    ApiStatusNotReached = -2,
    ApiStatusError,
    ApiStatusSucceed,
    ApiStatusNotModified
}ApiStatus;

@interface CCApiTask : HttpTask {
    ApiStatus _apiStatus;
}
@property (nonatomic, readonly) ApiStatus apiStatus;
@end
