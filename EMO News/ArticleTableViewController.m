//
//  ArticleTableViewController.m
//  EMO News
//
//  Created by Kohei Hayakawa on 6/21/14.
//  Copyright (c) 2014 Kohei Hayakawa. All rights reserved.
//

#import "ArticleTableViewController.h"
#import "ArticleCustomCell.h"
#import "WebViewController.h"

@interface ArticleTableViewController () {
    NSMutableArray *_articles;
}

@property UIActivityIndicatorView *indicator;

@end

@implementation ArticleTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)setEmoString:(id)newEmoString
{
    if (_emoString != newEmoString) {
        _emoString = newEmoString;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"ArticleCustomCell" bundle:nil]
         forCellReuseIdentifier:@"ArticleCustomCell"];
    
    //[self.tableView.inputView setHidden:YES];
    [self startActiviryIndicatorAnimation];
    [self getJSON];
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc]init];
    [refreshControl addTarget:self action:@selector(onRefresh:) forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refreshControl;
}

- (void)onRefresh:(id)sender
{
    [self.refreshControl beginRefreshing];
    [self getJSON];
    [self.refreshControl endRefreshing];
}

- (void)getJSON
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://153.121.66.117/article/%@", self.emoString]];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *jsonData, NSError *error) {
        
        // internet connection error
        if (jsonData == NULL) {
            
            NSDictionary *obj = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:@"通信エラー", @"ネットワーク通信状況をご確認ください。", @"http://emo-news.jp", nil] forKeys:[NSArray arrayWithObjects:@"title", @"summary", @"url", nil]];
            
            if (!_articles) {
                _articles = [[NSMutableArray alloc] init];
            }
            [_articles removeAllObjects];
            [_articles addObject:obj];
            
            [self.tableView reloadData];
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            [self stopActivityIndicatorAnimation];
            
            return;
        }
        
        NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:nil];
        
        if (!_articles) {
            _articles = [[NSMutableArray alloc] init];
        }
        [_articles removeAllObjects];
        for (NSDictionary *obj in jsonDictionary)
        {
            [_articles addObject:obj];
        }

        [self.tableView reloadData];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        [self stopActivityIndicatorAnimation];
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    //[self getJSON];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return _articles.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    /*
     UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
     
     cell.textLabel.text = self.labelString;
     return cell;
     */
    //static NSString *CellIdentifier = @"CustomCell";
    ArticleCustomCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ArticleCustomCell"
                                                       forIndexPath: indexPath];
    
    
    NSDictionary *dic = _articles[indexPath.row];
    
    cell.title.text = [dic objectForKey:@"title"];

    //[cell.title sizeToFit];
    cell.title.frame=CGRectMake(cell.title.frame.origin.x,cell.title.frame.origin.y,310, cell.title.frame.size.height);
    
    if (![[NSString stringWithFormat:@"%@", [dic objectForKey:@"summary"]]  isEqual: @"<null>"]) {
        cell.body.text = [dic objectForKey:@"summary"];
    } else {
        cell.body.text = @"";
    }
    
    NSNumber *happy = [dic objectForKey:@"score_happy"];
    NSNumber *joy = [dic objectForKey:@"score_joy"];
    NSNumber *surprise = [dic objectForKey:@"score_surprise"];
    NSNumber *anger = [dic objectForKey:@"score_anger"];
    NSNumber *sadness = [dic objectForKey:@"score_sadness"];
    NSNumber *dislike = [dic objectForKey:@"score_dislike"];
    cell.happy_score.text = [NSString stringWithFormat:@"%.0f%%", happy.floatValue * 100];
    cell.joy_score.text = [NSString stringWithFormat:@"%.0f%%", joy.floatValue * 100];
    cell.surprise_score.text = [NSString stringWithFormat:@"%.0f%%", surprise.floatValue * 100];
    cell.anger_score.text = [NSString stringWithFormat:@"%.0f%%", anger.floatValue * 100];
    cell.sadness_score.text = [NSString stringWithFormat:@"%.0f%%", sadness.floatValue * 100];
    cell.dislike_score.text = [NSString stringWithFormat:@"%.0f%%", dislike.floatValue * 100];
    
    [cell.iv setBackgroundColor:[UIColor clearColor]];
    //[cell.happy_label setTextColor:[UIColor clearColor]];
    if ([dic objectForKey:@"emo_string"] != NULL) {
        
        [cell.happy_label setTextColor:[UIColor darkGrayColor]];
        [cell.joy_label setTextColor:[UIColor darkGrayColor]];
        [cell.surprise_label setTextColor:[UIColor darkGrayColor]];
        [cell.anger_label setTextColor:[UIColor darkGrayColor]];
        [cell.sadness_label setTextColor:[UIColor darkGrayColor]];
        [cell.dislike_label setTextColor:[UIColor darkGrayColor]];
        
        if ([[dic objectForKey:@"emo_string"]  isEqual: @"嬉しい"]) {
            [cell.iv setBackgroundColor:[UIColor colorWithRed:1.0 green:0.827 blue:0.247 alpha:1.0]];
            [cell.happy_label setTextColor:[UIColor colorWithRed:1.0 green:0.827 blue:0.247 alpha:1.0]];
        } else if ([[dic objectForKey:@"emo_string"]  isEqual: @"面白い"]) {
            [cell.iv setBackgroundColor:[UIColor colorWithRed:0.953 green:0.596 blue:0.0 alpha:1.0]];
            [cell.joy_label setTextColor:[UIColor colorWithRed:0.953 green:0.596 blue:0.0 alpha:1.0]];
        } else if ([[dic objectForKey:@"emo_string"]  isEqual: @"ビックリ"]) {
            [cell.iv setBackgroundColor:[UIColor colorWithRed:0.0 green:0.804 blue:0.635 alpha:1.0]];
            [cell.surprise_label setTextColor:[UIColor colorWithRed:0.0 green:0.804 blue:0.635 alpha:1.0]];
        } else if ([[dic objectForKey:@"emo_string"]  isEqual: @"怒り"]) {
            [cell.iv setBackgroundColor:[UIColor colorWithRed:1.0 green:0.286 blue:0.341 alpha:1.0]];
            [cell.anger_label setTextColor:[UIColor colorWithRed:1.0 green:0.286 blue:0.341 alpha:1.0]];
        } else if ([[dic objectForKey:@"emo_string"]  isEqual: @"悲しい"]) {
            [cell.iv setBackgroundColor:[UIColor colorWithRed:0.0 green:0.455 blue:0.941 alpha:1.0]];
            [cell.sadness_label setTextColor:[UIColor colorWithRed:0.0 green:0.455 blue:0.941 alpha:1.0]];
        } else {
            [cell.iv setBackgroundColor:[UIColor colorWithRed:0.573 green:0.333 blue:0.694 alpha:1.0]];
            [cell.dislike_label setTextColor:[UIColor colorWithRed:0.573 green:0.333 blue:0.694 alpha:1.0]];
        }
    }
    
    if (_articles.count == 1) {
        cell.happy_label.text = @"";
        cell.joy_label.text = @"";
        cell.surprise_label.text = @"";
        cell.anger_label.text = @"";
        cell.sadness_label.text = @"";
        cell.dislike_label.text = @"";
        cell.happy_score.text = @"";
        cell.joy_score.text = @"";
        cell.surprise_score.text = @"";
        cell.anger_score.text = @"";
        cell.sadness_score.text = @"";
        cell.dislike_score.text = @"";
    } else {
        cell.happy_label.text = @"嬉しい";
        cell.joy_label.text = @"面白い";
        cell.surprise_label.text = @"ビックリ";
        cell.anger_label.text = @"怒り";
        cell.sadness_label.text = @"悲しい";
        cell.dislike_label.text = @"嫌悪";
    }
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath: (NSIndexPath*) indexPath{
    [self performSegueWithIdentifier:@"toWebView" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    NSMutableDictionary *object = [NSMutableDictionary dictionaryWithDictionary:_articles[indexPath.row]];
    [object setObject:self.emoString forKey:@"emo-string"];
    [[segue destinationViewController] setDetailItem:object];
}

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
    [self.tableView setHidden:NO];
    [_indicator stopAnimating];
}
/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 } else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
