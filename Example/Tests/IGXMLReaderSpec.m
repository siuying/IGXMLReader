//
//  IGXMLReaderSpec.m
//  IGXMLReaderTests
//
//  Created by Francis Chong on 02/08/2015.
//  Copyright (c) 2014 Francis Chong. All rights reserved.
//

#import "IGXMLReader.h"

SPEC_BEGIN(IGXMLReaderSpec)

describe(@"IGXMLReader", ^{
    __block IGXMLReader* reader;

    context(@"#isEmpty", ^{
        it(@"should return empty element if it is", ^{
            reader = [[IGXMLReader alloc] initWithXMLString:@"<xml><city>Paris</city><state/></xml>"];
            
            NSMutableArray* isEmptyArray = [NSMutableArray array];
            for (IGXMLReader* node in reader) {
                [isEmptyArray addObject:@([node isEmpty])];
            }
            
            [[isEmptyArray should] equal:@[@NO, @NO, @NO, @NO, @YES, @NO]];
        });
    });

    context(@"#hasAttributes", ^{
        it(@"should return YES when has attributes", ^{
            reader = [[IGXMLReader alloc] initWithXMLString:@"<x xmlns:tenderlove='http://tenderlovemaking.com/'>\
                      <tenderlove:foo awesome='true'>snuggles!</tenderlove:foo>\
                      </x>"];

            NSMutableArray* hasAttributesArray = [NSMutableArray array];
            for (IGXMLReader* node in reader) {
                [hasAttributesArray addObject:@([node hasAttributes])];
            }
            
            [[hasAttributesArray should] equal:@[@YES, @NO, @YES, @NO, @YES, @NO, @YES]];
        });
    });

    context(@"#attributes", ^{
        it(@"should return attributes maps", ^{
            reader = [[IGXMLReader alloc] initWithXMLString:@"<x xmlns:tenderlove='http://tenderlovemaking.com/'\
                      xmlns='http://mothership.connection.com/'\
                      >\
                      <tenderlove:foo awesome='true'>snuggles!</tenderlove:foo>\
                      </x>"];

            NSMutableArray* attributesArray = [NSMutableArray array];
            for (IGXMLReader* node in reader) {
                if ([node type] == IGXMLReaderNodeTypeElement) {
                    [attributesArray addObject:[node attributes]];
                }
            }
            [[attributesArray should] equal:@[@{@"xmlns:tenderlove": @"http://tenderlovemaking.com/", @"xmlns": @"http://mothership.connection.com/"},
                                              @{@"awesome": @"true"}]];
        });
    });
    
    context(@"#attributeWithName:", ^{
        it(@"should return attribute with name", ^{
            reader = [[IGXMLReader alloc] initWithXMLString:@"<x xmlns:tenderlove='http://tenderlovemaking.com/'>\
                      <tenderlove:foo awesome='true'>snuggles!</tenderlove:foo>\
                      </x>"];
            
            NSMutableArray* attributesArray = [NSMutableArray array];
            for (IGXMLReader* node in reader) {
                [attributesArray addObject:[node attributeWithName:@"awesome"] ?: [NSNull null]];
            }
            [[attributesArray should] equal:@[[NSNull null], [NSNull null], @"true", [NSNull null], @"true", [NSNull null], [NSNull null]]];
        });
    });

    context(@"#attributeAtIndex:", ^{
        it(@"should return attribute with name", ^{
            reader = [[IGXMLReader alloc] initWithXMLString:@"<x xmlns:tenderlove='http://tenderlovemaking.com/'>\
                      <tenderlove:foo awesome='true'>snuggles!</tenderlove:foo>\
                      </x>"];
            
            NSMutableArray* attributesArray = [NSMutableArray array];
            for (IGXMLReader* node in reader) {
                [attributesArray addObject:[node attributeAtIndex:0] ?: [NSNull null]];
            }
            [[attributesArray should] equal:@[@"http://tenderlovemaking.com/", [NSNull null], @"true", [NSNull null], @"true", [NSNull null], @"http://tenderlovemaking.com/"]];
        });
    });

    context(@"#nextObject", ^{
        describe(@"when at a start tag", ^{
            beforeEach(^{
                reader = [[IGXMLReader alloc] initWithXMLString:@"<document></document>"];
                [reader nextObject];
            });

            it(@"should return start element", ^{
                [[theValue([reader type]) should] equal:theValue(IGXMLReaderNodeTypeElement)];
            });

            it(@"should return tag name", ^{
                [[[reader name] should] equal:@"document"];
            });

            it(@"should return current depth", ^{
                [[theValue([reader depth]) should] equal:theValue(0)];
            });
        });
        
        describe(@"when at a end tag", ^{
            beforeEach(^{
                reader = [[IGXMLReader alloc] initWithXMLString:@"<document><item></item></document>"];
                [reader nextObject];
                [[theValue([reader type]) should] equal:theValue(IGXMLReaderNodeTypeElement)];

                [reader nextObject];
                [[theValue([reader type]) should] equal:theValue(IGXMLReaderNodeTypeElement)];
                [reader nextObject];
            });

            it(@"should return end element", ^{
                [[theValue([reader type]) should] equal:theValue(IGXMLReaderNodeTypeEndElement)];
            });

            it(@"should return tag name", ^{
                [[[reader name] should] equal:@"item"];
            });

            it(@"should return current depth", ^{
                [[theValue([reader depth]) should] equal:theValue(1)];
            });
        });
        
        describe(@"when at a text", ^{
            beforeEach(^{
                reader = [[IGXMLReader alloc] initWithXMLString:@"<content>text &quot;la&#x0A; la </content>"];
                [reader nextObject];
                [[theValue([reader type]) should] equal:theValue(IGXMLReaderNodeTypeElement)];
                
                [reader nextObject];
            });
            
            it(@"should return text element", ^{
                [[theValue([reader type]) should] equal:theValue(IGXMLReaderNodeTypeText)];
            });
            
            it(@"should return value", ^{
                [[[reader value] should] equal:@"text \"la\n la "];
            });
            
            it(@"should return current depth", ^{
                [[theValue([reader depth]) should] equal:theValue(1)];
            });
        });
        
        describe(@"when at a comment", ^{
            beforeEach(^{
                reader = [[IGXMLReader alloc] initWithXMLString:@"<!-- comment --><tag></tag>"];
                [reader nextObject];
            });
            
            it(@"should return comment", ^{
                [[theValue([reader type]) should] equal:theValue(IGXMLReaderNodeTypeComment)];
            });
            
            it(@"should return comment text", ^{
                [[[reader value] should] equal:@" comment "];
            });
            
            it(@"should return current depth", ^{
                [[theValue([reader depth]) should] equal:theValue(0)];
            });
        });
    });
    
});

SPEC_END
