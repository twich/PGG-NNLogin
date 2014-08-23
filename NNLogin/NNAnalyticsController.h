//
//  NNAnalyticsController.h
//  NNAnalyticsController
//
//  Created by Scott Twichel on 8/7/14.
//  Copyright (c) 2014 PepperGum Games. All rights reserved.
//

#import <Foundation/Foundation.h>

// TODO: Add all post types that will be sent to web server

/*!
 * @typedef NNPostType
 * @brief Possible data to post to web service
 * @constant NNPlayer Player profile data
 * @constant NNTouch Details around a players touch during game
 * @constant NNActionPrompt Player action prompt details
 */
typedef NS_ENUM(NSUInteger, NNPostType) {
    ///Player profile data
    NNPlayer,
    ///Details around a players touch during game
    NNTouch,
    ///Player action prompt details
    NNActionPrompt,
};

@interface NNAnalyticsController : NSObject<NSURLConnectionDelegate>

/*!
 * @discussion Posts data to a remote web service specified in the method
 * @param userData Serialized JSON String of the user's data to be transfered to the webservice
 * @param username Username credential to access the webservice
 * @param password Password credential to access the webservice
 * @return BOOL YES means the POST was successful
 */
+(BOOL)postUserDataToServer:(NSString*)userData usingUsername:(NSString*)username password:(NSString*)password;

// TODO: Once API data fields are finalized
// rework method to accept array of values. Create arrays for Keys based on NNPostType.
/*!
 * @discussion Serializes an NSDictionary into a JSON formatted NSString
 * @param userData The data to be serialized
 * @return NSString JSON formatted NSString
 */
+(NSString*)formatUserDataForUpload:(NSDictionary*) userData;

@end
