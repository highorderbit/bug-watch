//
//  Copyright 2009 High Order Bit, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessageDetailsViewController : UITableViewController
{
    IBOutlet UIView * headerView;
    IBOutlet UIView * footerView;
    IBOutlet UIView * metaDataView;
    IBOutlet UIImageView * gradientImage;

    IBOutlet UILabel * authorLabel;
    IBOutlet UILabel * dateLabel;
    IBOutlet UILabel * projectLabel;
    IBOutlet UILabel * titleLabel;
    IBOutlet UILabel * commentLabel;
    
    NSDictionary * responses;
    NSDictionary * responseAuthors;
    NSString * authorName;
    NSDate * date;
    NSString * title;
    NSString * comment;
    NSString * link;
}

@property (nonatomic, copy) NSString * authorName;
@property (nonatomic, copy) NSDate * date;
@property (nonatomic, copy) NSString * title;
@property (nonatomic, copy) NSString * comment;
@property (nonatomic, copy) NSString * link;

- (void)setAuthorName:(NSString *)authorName date:(NSDate *)date
    projectName:(NSString *)projectName title:(NSString *)title
    comment:(NSString *)comment responses:(NSDictionary *)someResponses
    responseAuthors:(NSDictionary *)someResponseAuthors link:(NSString *)link;

- (IBAction)sendInEmail:(id)sender;
- (IBAction)openInBrowser:(id)sender;

@end
