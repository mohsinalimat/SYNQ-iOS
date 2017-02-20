//
//  SQHttpClientExtension.h
//  Pods
//
//  Created by Kjartan Vestvik on 24.01.2017.
//
//  This is an extension for the SQHttpClient class to allow accessing
//  the private method getUploadFormFromParametersDictionary when running tests

#ifndef SQHttpClientExtension_h
#define SQHttpClientExtension_h


@interface SQHttpClient ()

- (NSDictionary *) getUploadFormFromParametersDictionary:(NSDictionary *)paramsDict;

@end

#endif /* SQHttpClientExtension_h */
