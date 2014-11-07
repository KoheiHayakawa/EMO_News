//
//  ArticleCustomCell.h
//  EMO News
//
//  Created by Kohei Hayakawa on 6/21/14.
//  Copyright (c) 2014 Kohei Hayakawa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ArticleCustomCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *body;
@property (weak, nonatomic) IBOutlet UIImageView *iv;

@property (weak, nonatomic) IBOutlet UILabel *happy_label;
@property (weak, nonatomic) IBOutlet UILabel *joy_label;
@property (weak, nonatomic) IBOutlet UILabel *surprise_label;
@property (weak, nonatomic) IBOutlet UILabel *anger_label;
@property (weak, nonatomic) IBOutlet UILabel *sadness_label;
@property (weak, nonatomic) IBOutlet UILabel *dislike_label;

@property (weak, nonatomic) IBOutlet UILabel *happy_score;
@property (weak, nonatomic) IBOutlet UILabel *joy_score;
@property (weak, nonatomic) IBOutlet UILabel *surprise_score;
@property (weak, nonatomic) IBOutlet UILabel *anger_score;
@property (weak, nonatomic) IBOutlet UILabel *sadness_score;
@property (weak, nonatomic) IBOutlet UILabel *dislike_score;


@end
