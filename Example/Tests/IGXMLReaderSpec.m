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
        it(@"should return attribute at index", ^{
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

    context(@"#attributeCount", ^{
        it(@"should return number of attributes for element tag", ^{
            reader = [[IGXMLReader alloc] initWithXMLString:@"<x xmlns:tenderlove='http://tenderlovemaking.com/'>\
                      <tenderlove:foo awesome='true' cool='true'>snuggles!</tenderlove:foo>\
                      </x>"];
            
            NSMutableArray* attributesArray = [NSMutableArray array];
            for (IGXMLReader* node in reader) {
                [attributesArray addObject:@([node attributeCount])];
            }
            [[attributesArray should] equal:@[@1, @0, @2, @0, @0, @0, @0]];
        });
    });
    
    context(@"#depth", ^{
        it(@"should return depth", ^{
            reader = [[IGXMLReader alloc] initWithXMLString:@"<x xmlns:tenderlove='http://tenderlovemaking.com/'>\
                      <tenderlove:foo>snuggles!</tenderlove:foo>\
                      </x>"];
            
            NSMutableArray* attributesArray = [NSMutableArray array];
            for (IGXMLReader* node in reader) {
                [attributesArray addObject:@([node depth])];
            }
            [[attributesArray should] equal:@[@0, @1, @1, @2, @1, @1, @0]];
        });
    });
    
    context(@"#value", ^{
        it(@"should return value", ^{
            reader = [[IGXMLReader alloc] initWithXMLString:@"<x xmlns:tenderlove='http://tenderlovemaking.com/'>\n\
    <tenderlove:foo>snuggles!</tenderlove:foo>\n\
</x>"];
            
            NSMutableArray* attributesArray = [NSMutableArray array];
            for (IGXMLReader* node in reader) {
                [attributesArray addObject:[node value] ?: [NSNull null]];
            }
            [[attributesArray should] equal:@[[NSNull null], @"\n    ", [NSNull null], @"snuggles!", [NSNull null], @"\n", [NSNull null]]];
        });
    });

    context(@"#type", ^{
        it(@"should return node type", ^{
            reader = [[IGXMLReader alloc] initWithXMLString:@"<x>\
                      <y>hello</y>\
                      </x>"];
            NSMutableArray* attributesArray = [NSMutableArray array];
            for (IGXMLReader* node in reader) {
                [attributesArray addObject:@([node type])];
            }
            [[attributesArray should] equal:@[@1, @14, @1, @3, @15, @14, @15]];
        });
    });
    
    context(@"#innerXML", ^{
        it(@"should return inner xml", ^{
            reader = [[IGXMLReader alloc] initWithXMLString:@"<x><y>hello</y></x>"];
            [reader nextObject];
            [[[reader innerXML] should] equal:@"<y>hello</y>"];
        });
    });
    
    context(@"#outerXML", ^{
        it(@"should return outer xml", ^{
            NSArray* strings = @[@"<x><y>hello</y></x>", @"<y>hello</y>", @"hello", @"<y/>", @"<x/>"];
            NSMutableArray* outerXMLs = [NSMutableArray array];
            reader = [[IGXMLReader alloc] initWithXMLString:[strings firstObject]];
            for (IGXMLReader* node in reader) {
                [outerXMLs addObject:[node outerXML]];
            }
            [[[outerXMLs copy] should] equal:strings];
        });

        it(@"should return outer xml with empty nodes", ^{
            NSArray* strings = @[@"<x><y/></x>", @"<y/>", @"<x/>"];
            NSMutableArray* outerXMLs = [NSMutableArray array];
            reader = [[IGXMLReader alloc] initWithXMLString:[strings firstObject]];
            for (IGXMLReader* node in reader) {
                [outerXMLs addObject:[node outerXML]];
            }
            [[[outerXMLs copy] should] equal:strings];
        });
    });
    
    context(@"#name", ^{
        it(@"should return name", ^{
            reader = [[IGXMLReader alloc] initWithXMLString:@"<x xmlns:edi='http://ecommerce.example.org/schema'>\
                      <edi:foo>hello</edi:foo>\
                      </x>"];
            NSMutableArray* names = [NSMutableArray array];
            for (IGXMLReader* node in reader) {
                [names addObject:[node name]];
            }
            [[names should] equal:@[@"x", @"#text", @"edi:foo", @"#text", @"edi:foo", @"#text", @"x"]];
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
