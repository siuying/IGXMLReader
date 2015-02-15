# IGXMLReader

[![CI Status](http://img.shields.io/travis/siuying/IGXMLReader.svg?style=flat)](https://travis-ci.org/Francis Chong/IGXMLReader)
[![Version](https://img.shields.io/cocoapods/v/IGXMLReader.svg?style=flat)](http://cocoadocs.org/docsets/IGXMLReader)
[![License](https://img.shields.io/cocoapods/l/IGXMLReader.svg?style=flat)](http://cocoadocs.org/docsets/IGXMLReader)
[![Platform](https://img.shields.io/cocoapods/p/IGXMLReader.svg?style=flat)](http://cocoadocs.org/docsets/IGXMLReader)

The ``IGXMLReader`` allows you to effectively pull parse an XML document. Once instantiated, call #nextObject to iterate over each node. **Note that you may only iterate over the document once!**

``IGXMLReader`` parses an XML document similar to the way a cursor would move. The Reader is given an XML document, and return a node (an IGXMLReader object) to each calls to ``nextObject``.

```objective-c
IGXMLReader* reader = [[IGXMLReader alloc] initWithXMLString:@"<x xmlns:edi='http://ecommerce.example.org/schema'>\
                      <edi:foo>hello</edi:foo>\
                      </x>"];
for (IGXMLReader* node in reader) {
    NSLog(@"node name: %@", node.name);
}
```

## Usage

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

IGXMLReader is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

    pod "IGXMLReader"

## Author

Francis Chong, francis@ignition.hk

## License

IGXMLReader is available under the MIT license. See the LICENSE file for more info.

