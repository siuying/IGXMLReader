//
//  IGXMLReader.m
//  IGXMLReader
//
//  Created by Chan Fai Chong on 8/2/15.
//  Copyright (c) 2015 Francis Chong. All rights reserved.
//

#import "IGXMLReader.h"
#import <libxml/xmlreader.h>

@interface IGXMLReader()
@property (nonatomic, unsafe_unretained) xmlTextReaderPtr reader;
@end

@implementation IGXMLReader

-(instancetype) initWithXMLString:(NSString *)XMLString
{
    return [self initWithXMLString:XMLString URL:nil];
}

-(instancetype) initWithXMLString:(NSString*)XMLString URL:(NSURL*)URL
{
    return [self initWithXMLData:[XMLString dataUsingEncoding:NSUTF8StringEncoding]
                             URL:URL
                        encoding:@"utf8"];
}

-(instancetype) initWithXMLData:(NSData*)data URL:(NSURL*)URL encoding:(NSString*)encoding
{
    self = [super init];
    return [self initWithXMLData:data URL:URL encoding:encoding options:XML_PARSE_NONET];
}

-(instancetype) initWithXMLData:(NSData*)data URL:(NSURL*)URL encoding:(NSString*)encoding options:(int)options
{
    NSParameterAssert(data);
    self = [super init];
    _reader = xmlReaderForMemory([data bytes], (int) [data length], [[URL absoluteString] UTF8String], [encoding UTF8String], options);
    return self;
}

-(void) dealloc
{
    xmlFreeTextReader(_reader);
    _reader = nil;
}

-(instancetype) nextObject
{
    int ret = xmlTextReaderRead(_reader);
    if (ret == 1) {
        return self;
    }
    return nil;
}

-(void) enumerateNodesUsingBlock:(void (^) (IGXMLReader* node))block
{
    int ret = xmlTextReaderRead(_reader);
    while (ret == 1) {
        block(self);
        ret = xmlTextReaderRead(_reader);
    }
}

@end


@implementation IGXMLReader (Node)

-(NSString*) attributeWithName:(NSString*)name
{
    xmlChar* attributeName = xmlTextReaderGetAttribute(_reader, (const xmlChar*) [name UTF8String]);
    if (attributeName) {
        NSString* attributeNameStr = [NSString stringWithUTF8String:(const char*) attributeName];
        xmlFree(attributeName);
        return attributeNameStr;
    } else {
        return nil;
    }
}

-(NSString*) attributeAtIndex:(NSUInteger)index
{
    xmlChar* attribute = xmlTextReaderGetAttributeNo(_reader, (int) index);
    if (attribute) {
        NSString* attributeStr = [NSString stringWithUTF8String:(const char*) attribute];
        xmlFree(attribute);
        return attributeStr;
    } else {
        return nil;
    }
}

-(NSInteger) attributeCount
{
    return (NSInteger) xmlTextReaderAttributeCount(_reader);
}

-(NSDictionary*) attributes
{
    int type = xmlTextReaderNodeType(_reader);
    if (type != IGXMLReaderNodeTypeElement) {
        return @{};
    }
    
    NSUInteger count = [self attributeCount];
    NSMutableDictionary* dictionary = [NSMutableDictionary dictionaryWithCapacity:count];
    for (NSInteger i = 0; i < count; i++) {
        xmlTextReaderMoveToAttributeNo(_reader, (int) i);
        NSString* name = [self name];
        NSString* value = [self value];
        if (name && value) {
            [dictionary setObject:value forKey:name];
        }
    }
    xmlTextReaderMoveToElement(_reader);
    return [dictionary copy];
}

-(IGXMLReaderNodeType) type
{
    return (IGXMLReaderNodeType) xmlTextReaderNodeType(_reader);
}

-(NSString*) typeDescription
{
    IGXMLReaderNodeType type = [self type];
    switch (type) {
        case IGXMLReaderNodeTypeNone:
            return @"None";
        case IGXMLReaderNodeTypeElement:
            return @"Element";
        case IGXMLReaderNodeTypeAttribute:
            return @"Attribute";
        case IGXMLReaderNodeTypeText:
            return @"Text";
        case IGXMLReaderNodeTypeCDATA:
            return @"CDATA";
        case IGXMLReaderNodeTypeEntityReference:
            return @"EntityReference";
        case IGXMLReaderNodeTypeEntity:
            return @"Entity";
        case IGXMLReaderNodeTypeProcessingInstruction:
            return @"ProcessingInstruction";
        case IGXMLReaderNodeTypeComment:
            return @"Comment";
        case IGXMLReaderNodeTypeDocument:
            return @"Document";
        case IGXMLReaderNodeTypeDocumentType:
            return @"DocumentType";
        case IGXMLReaderNodeTypeDocumentFragment:
            return @"DocumentFragment";
        case IGXMLReaderNodeTypeNotation:
            return @"Notation";
        case IGXMLReaderNodeTypeWhitespace:
            return @"Whitespace";
        case IGXMLReaderNodeTypeSignificantWhitespace:
            return @"SignificantWhitespace";
        case IGXMLReaderNodeTypeEndElement:
            return @"EndElement";
        case IGXMLReaderNodeTypeEndEntity:
            return @"EndEntity";
        case IGXMLReaderNodeTypeXmlDeclaration:
            return @"XMLDeclaration";
    }
}

-(NSString*) name
{
    xmlChar* name = xmlTextReaderName(_reader);
    if (name) {
        NSString* nameStr = [NSString stringWithUTF8String:(const char*) name];
        return nameStr;
    } else {
        return nil;
    }
}

-(NSString*) value
{
    const xmlChar* value = xmlTextReaderConstValue(_reader);
    if (value) {
        NSString* valueStr = [NSString stringWithUTF8String:(const char*) value];
        return valueStr;
    } else {
        return nil;
    }
}

-(NSInteger) depth
{
    return xmlTextReaderDepth(_reader);
}

-(BOOL) isEmpty
{
    return xmlTextReaderIsEmptyElement(_reader);
}

-(BOOL) hasValue
{
    return xmlTextReaderHasValue(_reader);
}

-(BOOL) hasAttributes
{
    return xmlTextReaderHasAttributes(_reader);
}

@end
