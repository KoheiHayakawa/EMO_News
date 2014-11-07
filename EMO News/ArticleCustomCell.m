//
//  ArticleCustomCell.m
//  EMO News
//
//  Created by Kohei Hayakawa on 6/21/14.
//  Copyright (c) 2014 Kohei Hayakawa. All rights reserved.
//

#import "ArticleCustomCell.h"

@implementation ArticleCustomCell

@synthesize title = _title;
@synthesize body = _body;
@synthesize iv = _iv;

@synthesize happy_label = _happy_label;
@synthesize joy_label = _joy_label;
@synthesize surprise_label = _surprise_label;
@synthesize anger_label = _anger_label;
@synthesize sadness_label = _sadness_label;
@synthesize dislike_label = _dislike_label;

@synthesize happy_score = _happy_score;
@synthesize joy_score = _joy_score;
@synthesize surprise_score = _surprise_score;
@synthesize anger_score = _anger_score;
@synthesize sadness_score = _sadness_score;
@synthesize dislike_score = _dislike_score;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end