//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UpdateMessageDescription : NSObject
{
    NSString * title;
    NSString * body;
}

+ (id)description;
- (id)init;

@property (nonatomic, copy) NSString * title;
@property (nonatomic, copy) NSString * body;

- (NSString *)xmlDescription;

@end