//
//  WebViewController.h
//  EMO News
//
//  Created by Kohei Hayakawa on 6/21/14.
//  Copyright (c) 2014 Kohei Hayakawa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WebViewController : UIViewController

@property (strong, nonatomic) id detailItem;

@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end
