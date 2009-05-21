//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Project : NSObject <NSCopying>
{
    NSString * name;
}

@property (nonatomic, copy, readonly) NSString * name;

+ (id)projectWithName:(NSString *)aName;
- (id)initWithName:(NSString *)aName;

@end
