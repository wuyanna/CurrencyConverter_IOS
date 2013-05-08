//
//  HttpTask.h
//  CurrencyConverter
//
//  Created by yutao on 13-3-18.
//  Copyright (c) 2013年 wyn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Parsing.h"
@protocol HttpTaskDelegate,Parsing;
@interface HttpTask : NSObject <NSURLConnectionDataDelegate> {
    NSURLConnection *_conn;
    NSMutableData   *_buf;
    NSData          *_recvData;
    NSString        *_errMsg;
    NSHTTPURLResponse   *_response;
    id<HttpTaskDelegate> _delegate;
    id<Parsing>      _parser;
    id              _result;
}

@property (nonatomic, readonly) id result;
@property (nonatomic, readonly) NSString *errMsg;
@property (nonatomic, readonly) NSData *bytes;

- (id)initWithURL:(NSURL *)url delegate:(id<HttpTaskDelegate>)delegate;
- (id)initWithURL:(NSURL *)url delegate:(id<HttpTaskDelegate>)delegate parser:(id<Parsing>)parser;
- (id)initWithURL:(NSURL *)url cachePolicy:(NSURLRequestCachePolicy)cachePolicy timeoutInterval:(NSTimeInterval)timeoutInterval delegate:(id<HttpTaskDelegate>)delegate parser:(id<Parsing>)parser;
- (void)start;

- (void)taskDidFinish; // for overide
@end

@protocol HttpTaskDelegate <NSObject>

- (void)httpTaskDidFinish:(HttpTask *)httpTask;

- (void)httpTask:(HttpTask *)httpTask didFailWithError:(NSError *)error;

@end