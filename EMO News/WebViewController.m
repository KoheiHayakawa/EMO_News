//
//  WebViewController.m
//  EMO News
//
//  Created by Kohei Hayakawa on 6/21/14.
//  Copyright (c) 2014 Kohei Hayakawa. All rights reserved.
//

#import "WebViewController.h"

@interface WebViewController ()

- (void)configureView;

@property UIActivityIndicatorView *indicator;

@end

@implementation WebViewController

- (void)setDetailItem:(id)newDetailItem
{
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
        
        // Update the view.
        [self configureView];
    }
}

- (void)configureView
{
    // Update the user interface for the detail item.
    if (self.detailItem) {
        self.navigationItem.title = [self.detailItem valueForKey:@"title"];
    }
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self configureView];
    
    NSURLRequest* req = [NSURLRequest requestWithURL:[NSURL URLWithString:[self.detailItem valueForKey:@"url"]]];
    [_webView loadRequest:req];
    
    [self startActiviryIndicatorAnimation];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)actionButtonPressed:(id)sender
{
    
    if (![[self.detailItem valueForKey:@"emo-string"]  isEqual: @"top"]) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setObject:@"嬉しい" forKey:@"happy"];
        [dic setObject:@"面白い" forKey:@"joy"];
        [dic setObject:@"かわいい" forKey:@"kawaii"];
        [dic setObject:@"ビックリ" forKey:@"surprise"];
        [dic setObject:@"怒り" forKey:@"anger"];
        [dic setObject:@"悲しい" forKey:@"sadness"];
        [dic setObject:@"嫌悪" forKey:@"dislike"];
        
        NSString *ttl = [NSString stringWithFormat:@"【%@ニュース】%@ #EMO_News http://emo-news.jp", [dic objectForKey:[self.detailItem valueForKey:@"emo-string"]], [self.detailItem valueForKey:@"title"]];
        NSURL *url = [NSURL URLWithString:[self.detailItem valueForKey:@"url"]];
        
        NSArray *activityItems = [NSArray arrayWithObjects:ttl, url, nil];
        UIActivityViewController *activityView = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
        
        [self presentViewController:activityView animated:YES completion:^{
        }];
    } else {
        NSString *ttl = [NSString stringWithFormat:@"【%@ニュース】%@ #EMO_News http://emo-news.jp", [self.detailItem objectForKey:@"emo_string"], [self.detailItem valueForKey:@"title"]];
        NSURL *url = [NSURL URLWithString:[self.detailItem valueForKey:@"url"]];
        
        NSArray *activityItems = [NSArray arrayWithObjects:ttl, url, nil];
        UIActivityViewController *activityView = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
        
        [self presentViewController:activityView animated:YES completion:^{
        }];
    }

}

// ページ読込開始時にインジケータ表示
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    // ステータスバーのインジケータ表示
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

// ページ読込完了時にインジケータ非表示
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    // アクティビティインジケータ非表示
    [self stopActivityIndicatorAnimation];
    
    // ステータスバーのインジケータ非表示
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

#pragma mark - Activity Indicator

// アクティビティインジケータ表示
- (void)startActiviryIndicatorAnimation
{
    _indicator = [[UIActivityIndicatorView alloc] init];
    _indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    _indicator.frame = CGRectMake(0, 0, 20, 20);
    _indicator.center = self.view.center;
    _indicator.hidesWhenStopped = YES;
    [_indicator startAnimating];
    [self.view addSubview:_indicator];
}

// アクティビティインジケータ非表示
- (void)stopActivityIndicatorAnimation
{
    [_indicator stopAnimating];
}

@end

