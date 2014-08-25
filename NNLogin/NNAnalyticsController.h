//
//  NNAnalyticsController.h
//  NNAnalyticsController
//
//  Created by Scott Twichel on 8/7/14.
//  Copyright (c) 2014 PepperGum Games. All rights reserved.
//

#import <Foundation/Foundation.h>

/*!
 * @typedef NNPostType
 * @brief Each type enumeration represents a separate API endpoint
 */
typedef NS_ENUM(NSUInteger, NNPostType) {
    ///Time Playing API endpoint
    NNTimePlayingPost,
    ///Word manipulation API endpoint
    NNWordManipulationPost,
    ///Translation filter usage API endpoint
    NNTranslationFilterUsagesPost,
    ///User details API endpoint
    NNUserPost,
    ///Session details API endpoint
    NNSessionsPost
};

@interface NNAnalyticsController : NSObject<NSURLConnectionDelegate>

// TODO: Once API data fields are finalized
// rework method to accept array of values. Create arrays for Keys based on NNPostType.
/*!
 * @discussion Serializes an NSDictionary into a JSON formatted NSString
 * @param userData The data to be serialized
 * @return NSString JSON formatted NSString
 */
+(BOOL)formatDataToJSONAndPost:(NSArray*) userData postType:(NNPostType)postType;

@end
