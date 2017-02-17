# SynqObjC

[![Build Status](https://www.bitrise.io/app/defc9f57a429cadb.svg?token=2J7owYPfYjtBvRmaFOXbCw&branch=master)](https://www.bitrise.io/app/defc9f57a429cadb)
[![Version](https://img.shields.io/cocoapods/v/SynqObjC.svg?style=flat)](http://cocoapods.org/pods/SynqObjC)
[![License](https://img.shields.io/cocoapods/l/SynqObjC.svg?style=flat)](http://cocoapods.org/pods/SynqObjC)
[![Platform](https://img.shields.io/cocoapods/p/SynqObjC.svg?style=flat)](http://cocoapods.org/pods/SynqObjC)

This is the SYNQ mobile SDK for iOS. It lets you easily integrate your mobile app with the SYNQ platform and the [SYNQ Video API](https://www.synq.fm).

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first. The example project features an app that utilizes the features of the SDK, and this shows how parts of the SDK are to be used.

## Installation

SynqObjC is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "SynqObjC"
```

The SDK is comprised of two parts: SynqUploader - for uploading videos to SYNQ, and SynqStreamer - for streaming live video.
__Please note: The streaming functionality is not fully implemented yet, it will be finished soon!__

## SynqUploader

This part consists of classes for fetching videos from the Photos library, exporting and uploading them to SYNQ. The SDK uses [AFNetworking 3](https://github.com/AFNetworking/AFNetworking) for communicating with the server. It utilizes a background configured NSURLSession to manage video uploads. This makes the upload continue regardless of whether the app is in the foreground or background.

### Import the SynqUploader header

```objective-c
#import <SynqUploader/SynqUploader.h>
```

### Create a SQVideoUpload object of each PHAsset to be uploaded

```objective-c
SQVideoUpload *video = [[SQVideoUpload alloc] initWithPHAsset:asset];
```

### Set upload parameters for the SQVideoUpload object

To do this, you must do two things: 
1. Create a video object in the SYNQ API
2. Fetch upload parameters from the API for the created video object
In the example project, the SynqHttpLib pod and the example server (SYNQ-Nodejs-example-server) performs these two functions in one step via the function "createVideoAndGetParamsWithSuccess:" 

```objective-c
[video setUploadParameters:parameters];
```

### Add each SQVideoUpload object to a NSArray and call the upload function

```objective-c
[[SynqUploader sharedInstance] uploadVideoArray:videoArray
                            exportProgressBlock:^(double exportProgress) 
{
    // Report progress to UI
    [self.progressView setProgress:exportProgress];
}
uploadProgressBlock:^(double uploadProgress) 
{
    // uploadProgress is between 0.0 and 100.0
    // Report progress to UI
    [self.progressView setProgress:uploadProgress];
}];
```


## SynqStreamer

<img src="https://www.synq.fm/wp-content/uploads/2017/01/gh_screen-s.jpg" height="610" width="500" >

__This part of the SDK is not fully implemented yet__


## Important note

The example project is dependant on access to the SYNQ API to be able to create a video object and to fetch the upload parameters needed when calling the upload function. You will need to get an API key from the SYNQ admin panel, and insert the key into the SynqAPI class. **Caution: this is not the proper way of doing this, and your api key might get exposed to others!** In a real world scenario, this should be handled by your own backend. The backend should then give your app the upload parameters.

For more info, please read the [projects and api keys](https://docs.synq.fm/#projects-and-api-keys) section in the docs.

## Requirements

This SDK requires iOS 9 or above

## Author

Kjartan Vestvik, kjartan@synq.fm

## License

SynqObjC is available under the MIT license. See the LICENSE file for more info.
