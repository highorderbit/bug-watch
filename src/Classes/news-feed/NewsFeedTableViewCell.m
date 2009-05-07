//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import "NewsFeedTableViewCell.h"
#import "NewsFeedItem.h"
#import "RoundedRectLabel.h"
#import "NSDate+StringHelpers.h"
#import "UILabel+DrawingAdditions.h"
#import "UIColor+BugWatchColors.h"

@interface NewsFeedTableViewCell (Private)

- (void)setAttributes:(NSDictionary *)attrs;

+ (UIColor *)dateLabelColor;

+ (UIColor *)colorForEntity:(NSString *)entity;
+ (UIColor *)messageEntityColor;

+ (NSDictionary *)entityColorMappings;

+ (void)setBackgroundColor:(UIColor *)color
        ofRoundedRectLabel:(RoundedRectLabel *)label;

@end

@implementation NewsFeedTableViewCell

@synthesize newsFeedItem;

- (void)dealloc
{
    [authorLabel release];
    [pubDateLabel release];
    [bodyLabel release];
    [entityTypeLabel release];

    [newsFeedItem release];

    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithFrame:frame reuseIdentifier:reuseIdentifier]) {
    }

    return self;
}

- (void)awakeFromNib
{
    UIImage * backgroundImage =
        [UIImage imageNamed:@"TableViewCellGradient.png"];
    self.backgroundView =
        [[[UIImageView alloc] initWithImage:backgroundImage] autorelease];
    self.backgroundView.contentMode =  UIViewContentModeBottom;
    entityTypeLabel.roundedCornerHeight = 5.0;
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    pubDateLabel.text = [newsFeedItem.published shortDescription];
    [pubDateLabel sizeToFit:UILabelSizeToFitAlignmentRight];

    authorLabel.text = newsFeedItem.author;
    [authorLabel
        sizeToFitWithinWidth:220.0 - pubDateLabel.frame.size.width - 5.0];

    NSString * body = newsFeedItem.title;

    CGFloat bodyHeight = [bodyLabel heightForString:body];
    CGRect bodyLabelFrame = bodyLabel.frame;
    bodyLabelFrame.size.height = bodyHeight;
    bodyLabel.frame = bodyLabelFrame;

    bodyLabel.text = body;

    NSString * type = newsFeedItem.type;
    entityTypeLabel.text = type;
    [[self class] setBackgroundColor:[[self class] colorForEntity:type]
                  ofRoundedRectLabel:entityTypeLabel];

    // FIXME: this has to be set here -- setting in awakeFromNib has no effect
    entityTypeLabel.font = [UIFont systemFontOfSize:12.0];
    entityTypeLabel.roundedCornerWidth = 5.0;
    entityTypeLabel.roundedCornerHeight = 5.0;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    if (selected) {
        authorLabel.textColor = [UIColor whiteColor];
        pubDateLabel.textColor = [UIColor whiteColor];
        bodyLabel.textColor = [UIColor whiteColor];
        //entityTypeLabel
    } else {
        authorLabel.textColor = [UIColor blackColor];
        pubDateLabel.textColor = [[self class] dateLabelColor];
        bodyLabel.textColor = [UIColor blackColor];
    }
}

+ (CGFloat)heightForContent:(NewsFeedItem *)item
{
    NSString * body = item.title;

    CGSize maxSize = CGSizeMake(211.0, 999999.0);
    UIFont * font = [UIFont systemFontOfSize:14.0];
    UILineBreakMode mode = UILineBreakModeWordWrap;

    CGSize size =
        [body sizeWithFont:font constrainedToSize:maxSize lineBreakMode:mode];

    return 34.0 + size.height;
}

+ (UIColor *)dateLabelColor
{
    return [UIColor bugWatchBlueColor];
}

+ (UIColor *)colorForEntity:(NSString *)entity
{
    return [UIColor colorForEntity:entity];
}

+ (void)setBackgroundColor:(UIColor *)color
        ofRoundedRectLabel:(RoundedRectLabel *)label
{
    label.roundedRectColor = color;
}

@end
