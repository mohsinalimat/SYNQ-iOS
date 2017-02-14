//
//  SQServerController.h
//  SynqObjC
//
//  Created by Kjartan Vestvik on 14.02.2017.
//  Copyright © 2017 kjartanvest. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SQServerController : NSObject

- (void) createUser;
- (void) loginUser;

- (void) getUserVideos;
- (void) createVideoWithSuccessBlock:(void (^)(NSDictionary *))successBlock
                    httpFailureBlock:(void (^)(NSURLSessionDataTask *, NSError *))httpFailureBlock;

@end
