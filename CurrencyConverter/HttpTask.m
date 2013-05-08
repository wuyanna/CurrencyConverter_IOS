//
//  HttpTask.m
//  CurrencyConverter
//
//  Created by yutao on 13-3-18.
//  Copyright (c) 2013年 wyn. All rights reserved.
//

#import "HttpTask.h"

@implementation HttpTask

@synthesize bytes = _recvData;
@synthesize result = _result;

- (id)initWithURL:(NSURL *)url delegate:(id<HttpTaskDelegate>)delegate {
    self = [self initWithURL:url delegate:delegate parser:nil];
    if (self) {
        
    }
    return self;
}

- (id)initWithURL:(NSURL *)url delegate:(id<HttpTaskDelegate>)delegate parser:(id<Parsing>)parser {
    self = [self initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60 delegate:delegate parser:parser];
    if (self) {
        
    }
    return self;
}

- (id)initWithURL:(NSURL *)url
      cachePolicy:(NSURLRequestCachePolicy)cachePolicy
  timeoutInterval:(NSTimeInterval)timeoutInterval
         delegate:(id<HttpTaskDelegate>)delegate
           parser:(id<Parsing>)parser{
    self = [super init];
    if (self) {
        _conn = [[NSURLConnection alloc] initWithRequest:[NSURLRequest requestWithURL:url cachePolicy:cachePolicy timeoutInterval:timeoutInterval] delegate:self];
        _delegate = delegate;
        _parser = parser;
    }
    return self;
}

- (void)start {
    [_conn start];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    _buf = nil;
    _recvData = nil;
    if ([_delegate respondsToSelector:@selector(httpTask:didFailWithError:)]) {
        [_delegate httpTask:self didFailWithError:error];
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
    NSLog(@"response:%@\nlength:%lld",[httpResponse allHeaderFields],[httpResponse expectedContentLength]);
    long long length = [httpResponse expectedContentLength];
    if (length == NSURLResponseUnknownLength) {
        length = 5000;
    }
    _buf = [[NSMutableData alloc] initWithCapacity:length];
    _response = httpResponse;

}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [_buf appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    _recvData = _buf;
    _buf = nil;
    
    if ([_parser respondsToSelector:@selector(parseWithData:)]) {
        _result = [_parser parseWithData:_recvData];
    } else {
        _result = _recvData;
    }
    
    [self taskDidFinish];
    if ([_delegate respondsToSelector:@selector(httpTaskDidFinish:)]) {
        [_delegate httpTaskDidFinish:self];
    }
}

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection willCacheResponse:(NSCachedURLResponse *)cachedResponse {
    return nil;
}

- (void)taskDidFinish {
    // base class, do nothing
}
@end
