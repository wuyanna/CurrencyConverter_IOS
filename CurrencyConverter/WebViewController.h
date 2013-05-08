//
//  WebViewController.h
//  CurrencyConverter
//
//  Created by yutao on 13-4-4.
//  Copyright (c) 2013年 wyn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WebViewController : UIViewController<UIWebViewDelegate> {
    IBOutlet UIWebView *_webView;
    IBOutlet UIActivityIndicatorView *_indicator;
}

- (void)loadURl:(NSURL*)url;
@end
