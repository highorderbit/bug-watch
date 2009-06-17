//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import "LighthouseApiParser.h"
#import "LighthouseApiTypeConverter.h"
#import "NSDateLighthouseApiTypeConverter.h"
#import "NSNumberLighthouseApiTypeConverter.h"
#import "NSObject+RuntimeAdditions.h"

@interface LighthouseApiParser ()

- (void)resetContext;
- (void)resetCollection;

- (void)setValue:(NSString *)value forPath:(NSString *)path object:(id)object;
- (id)convert:(NSString *)value toType:(NSString *)type;

+ (LighthouseApiTypeConverter *)standardTypeConverter;
+ (NSDictionary *)typeConverters;
+ (NSSet *)primitiveTypes;

@property (nonatomic, retain) id obj;
@property (nonatomic, retain) NSMutableString * elementPath;
@property (nonatomic, retain) NSMutableString * elementValue;
@property (nonatomic, retain) NSMutableString * elementType;
@property (nonatomic, retain) NSMutableArray * elements;

@end

@implementation LighthouseApiParser

@synthesize className, attributeMappings, classElementType;
@synthesize classElementCollection;
@synthesize obj, elementPath, elementValue, elementType, elements;

+ (id)parser
{
    return [[[[self class] alloc] init] autorelease];
}

- (void)dealloc
{
    [className release];
    [attributeMappings release];
    [classElementType release];
    [classElementCollection release];

    [obj release];

    [elementPath release];
    [elementValue release];
    [elementType release];
    [elements release];

    [super dealloc];
}

- (id)init
{
    return (self = [super init]);
}

- (id)parse:(NSData *)xml
{
    [self resetContext];
    [self resetCollection];
    buildingObject = NO;

    NSXMLParser * parser = [[NSXMLParser alloc] initWithData:xml];
    parser.delegate = self;

    NSLog(@"Parsing began.");
    [parser parse];
    NSLog(@"Parsing finished.");

    [parser release];

    if (classElementCollection)
        return [[elements retain] autorelease];
    else
        return [[obj retain] autorelease];
}

- (void)parser:(NSXMLParser *)parser
    didStartElement:(NSString *)elementName
    namespaceURI:(NSString *)namespaceURI
    qualifiedName:(NSString *)qualifiedName
    attributes:(NSDictionary *)attributes
{
    [self resetContext];

    if ([elementName isEqualToString:self.classElementType]) {
        self.obj = [[[[NSObject classNamed:className] alloc] init] autorelease];
        buildingObject = YES;
    } else if ([elementName isEqualToString:self.classElementCollection]) {
        if ([[attributes objectForKey:@"type"] isEqualToString:@"array"])
            [self resetCollection];
    } else {
        if ([attributes objectForKey:@"type"])
            self.elementType = [attributes objectForKey:@"type"];
        [self.elementPath appendString:elementName];
    }
}

- (void)parser:(NSXMLParser *)parser
    didEndElement:(NSString *)elementName
    namespaceURI:(NSString *)namespaceURI
    qualifiedName:(NSString *)qualifiedName
{
    if (buildingObject)
        // HACK: Grabbing top level objects to support parsing errors, and I
        // don't want to spend the time to refactor properly.
        if (!attributeMappings) {
            if ([elementName isEqualToString:self.classElementType]) {
                [self setValue:self.elementValue
                       forPath:self.elementPath
                        object:self.obj];
                [self.elements addObject:self.obj];
            }
        } else {
            if ([elementName isEqualToString:self.classElementType]) {
                [self.elements addObject:self.obj];
                buildingObject = NO;
            } else
                [self setValue:self.elementValue
                       forPath:self.elementPath
                        object:self.obj];
        }
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)chars
{
    [self.elementValue appendString:chars];
}

- (void)resetContext
{
    self.elementPath = [NSMutableString stringWithCapacity:0];
    self.elementValue = [NSMutableString stringWithCapacity:0];
    self.elementType = @"";
}

- (void)resetCollection
{
    self.elements = [NSMutableArray arrayWithCapacity:0];
}

- (void)setValue:(NSString *)value forPath:(NSString *)path object:(id)object
{
    NSString * key = [attributeMappings objectForKey:path];
    if (key || !attributeMappings) {
        id val = [self convert:value toType:self.elementType];

        if ([[[self class] primitiveTypes] containsObject:self.className])
            self.obj = val;
        else
            [object setValue:val forKey:key];
    }
}

- (id)convert:(NSString *)value toType:(NSString *)type
{
    LighthouseApiTypeConverter * converter =
        [[[self class] typeConverters] objectForKey:type];
    if (!converter)
        converter = [[self class] standardTypeConverter];

    return [converter convert:value];
}

+ (LighthouseApiTypeConverter *)standardTypeConverter
{
    static LighthouseApiTypeConverter * converter;
    if (!converter)
        converter = [[LighthouseApiTypeConverter alloc] init];

    return converter;
}

+ (NSDictionary *)typeConverters
{
    static NSDictionary * converters = nil;

    if (!converters)
        converters =
            [[NSDictionary alloc] initWithObjectsAndKeys:
             [NSDateLighthouseApiTypeConverter converter], @"datetime",
             [NSNumberLighthouseApiTypeConverter converter], @"integer",
             nil];

    return converters;
}

+ (NSSet *)primitiveTypes
{
    static NSSet * primitiveTypes = nil;

    if (!primitiveTypes)
        primitiveTypes =
            [[NSSet alloc] initWithObjects:@"NSNumber", @"NSString", nil];

    return primitiveTypes;
}

@end
