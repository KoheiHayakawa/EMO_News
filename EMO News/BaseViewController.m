//
//  BaseViewController.m
//  EMO News
//
//  Created by Kohei Hayakawa on 6/21/14.
//  Copyright (c) 2014 Kohei Hayakawa. All rights reserved.
//

#import "BaseViewController.h"
#import "ArticleTableViewController.h"

@interface BaseViewController () <ViewPagerDataSource, ViewPagerDelegate>

@property (nonatomic) NSUInteger numberOfTabs;

@end

@implementation BaseViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.dataSource = self;
    self.delegate = self;
    
    self.title = @"EMO News";
    
    UIImageView *titleImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo@2x.png"]];
    
    CGRect rect = CGRectMake(0, 0, self.view.frame.size.width, 40);
    titleImageView.frame = rect;
    
    self.navigationItem.titleView = titleImageView;
    
    // Keeps tab bar below navigation bar on iOS 7.0+
    // if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
    //     self.edgesForExtendedLayout = UIRectEdgeNone;
    // }
    
    //self.navigationItem.rightBarButtonItem = ({
    
    //    UIBarButtonItem *button;
    //    button = [[UIBarButtonItem alloc] initWithTitle:@"Tab #5" style:UIBarButtonItemStylePlain target:self action:@selector(selectTabWithNumberFive)];
    
    //    button;
    //});
    [self performSelector:@selector(loadContent) withObject:nil afterDelay:0.0];
    
    
}
- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
    //[self performSelector:@selector(loadContent) withObject:nil afterDelay:0.0];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Setters
- (void)setNumberOfTabs:(NSUInteger)numberOfTabs {
    
    // Set numberOfTabs
    _numberOfTabs = numberOfTabs;
    
    // Reload data
    [self reloadData];
    
}

#pragma mark - Helpers
- (void)selectTabWithNumberFive {
    [self selectTabAtIndex:5];
}
- (void)loadContent {
    self.numberOfTabs = 7;
}

#pragma mark - Interface Orientation Changes
- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    
    // Update changes after screen rotates
    [self performSelector:@selector(setNeedsReloadOptions) withObject:nil afterDelay:duration];
}

#pragma mark - ViewPagerDataSource
- (NSUInteger)numberOfTabsForViewPager:(ViewPagerController *)viewPager {
    return self.numberOfTabs;
}
- (UIView *)viewPager:(ViewPagerController *)viewPager viewForTabAtIndex:(NSUInteger)index {
    
    NSArray *arr = [NSArray arrayWithObjects:@"トップ", @"嬉しい", @"面白い", @"ビックリ", @"怒り", @"悲しい", @"嫌悪", nil];
    
    UILabel *label = [UILabel new];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:11.0];
    label.text = [NSString stringWithFormat:@"%@", [arr objectAtIndex:index]];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor blackColor];
    [label sizeToFit];
    
    return label;
}

- (UIViewController *)viewPager:(ViewPagerController *)viewPager contentViewControllerForTabAtIndex:(NSUInteger)index {
    
    NSArray *arr = [NSArray arrayWithObjects:@"top", @"happy", @"joy", @"surprise", @"anger", @"sadness", @"dislike", nil];
    
    ArticleTableViewController *cvc = [self.storyboard instantiateViewControllerWithIdentifier:@"ArticleTableViewController"];
    
    cvc.emoString = [NSString stringWithFormat:@"%@", [arr objectAtIndex:index]];
    
    return cvc;
}

#pragma mark - ViewPagerDelegate
- (CGFloat)viewPager:(ViewPagerController *)viewPager valueForOption:(ViewPagerOption)option withDefault:(CGFloat)value {
    
    switch (option) {
        case ViewPagerOptionStartFromSecondTab:
            return 0.0;
        case ViewPagerOptionCenterCurrentTab:
            return 1.0;
        case ViewPagerOptionTabLocation:
            return 0.0;
        case ViewPagerOptionTabHeight:
            return 49.0;
        case ViewPagerOptionTabOffset:
            return 36.0;
        case ViewPagerOptionTabWidth:
            //return UIInterfaceOrientationIsLandscape(self.interfaceOrientation) ? 128.0 : 96.0;
            //return UIInterfaceOrientationIsLandscape(self.interfaceOrientation) ? 96.0 : 72.0;
            return UIInterfaceOrientationIsLandscape(self.interfaceOrientation) ? 64.0 : 48.0;
            //return UIInterfaceOrientationIsLandscape(self.interfaceOrientation) ? 480.0 : 320.0;
        case ViewPagerOptionFixFormerTabsPositions:
            return 0.0;
        case ViewPagerOptionFixLatterTabsPositions:
            return 0.0;
        default:
            return value;
    }
}
- (UIColor *)viewPager:(ViewPagerController *)viewPager colorForComponent:(ViewPagerComponent)component withDefault:(UIColor *)color {
    
    switch (component) {
        case ViewPagerIndicator:
            return [[UIColor redColor] colorWithAlphaComponent:0.48];
        case ViewPagerTabsView:
            return [[UIColor lightGrayColor] colorWithAlphaComponent:0.16];
        case ViewPagerContent:
            return [[UIColor darkGrayColor] colorWithAlphaComponent:0.32];
        default:
            return color;
    }
}

@end
