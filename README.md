# SynqObjC

[![CI Status](http://img.shields.io/travis/kjartanvest/SynqObjC.svg?style=flat)](https://travis-ci.org/kjartanvest/SynqObjC)
[![Version](https://img.shields.io/cocoapods/v/SynqObjC.svg?style=flat)](http://cocoapods.org/pods/SynqObjC)
[![License](https://img.shields.io/cocoapods/l/SynqObjC.svg?style=flat)](http://cocoapods.org/pods/SynqObjC)
[![Platform](https://img.shields.io/cocoapods/p/SynqObjC.svg?style=flat)](http://cocoapods.org/pods/SynqObjC)

SynqObjC is an Objective-C SDK that lets you easily integrate your mobile app with the [SYNQ Video API](https://www.synq.fm).

The SDK uses [AFNetworking 3](https://github.com/AFNetworking/AFNetworking) for communicating with the server. It utilizes a background configured NSURLSession to manage video uploads. This makes the upload continue regardless of whether the app is in the foreground or background.

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

SynqObjC is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "SynqObjC"
```

## Requirements

This SDK requires iOS 9 or above

## Author

Kjartan Vestvik, kjartan@synq.fm

## License

SynqObjC is available under the MIT license. See the LICENSE file for more info.
