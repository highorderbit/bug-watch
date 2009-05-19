//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject <NSCopying>
{
    NSString * name;
    NSString * job;
    NSString * websiteLink;
    NSString * avatarLink;
}

@property (nonatomic, copy, readonly) NSString * name;
@property (nonatomic, copy, readonly) NSString * job;
@property (nonatomic, copy, readonly) NSString * websiteLink;
@property (nonatomic, copy, readonly) NSString * avatarLink;

+ (id)userWithName:(NSString *)aName job:(NSString *)aJob
    websiteLink:(NSString *)aWebsiteLink avatarLink:(NSString *)anAvatarLink;
- (id)initWithName:(NSString *)aName job:(NSString *)aJob
    websiteLink:(NSString *)aWebsiteLink avatarLink:(NSString *)anAvatarLink;

@end
