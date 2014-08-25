//
//  NNAnalyticsController.m
//  NNAnalyticsController
//
//  Created by Scott Twichel on 8/7/14.
//  Copyright (c) 2014 PepperGum Games. All rights reserved.
//

#import "NNAnalyticsController.h"


@implementation NNAnalyticsController

+(BOOL)formatDataToJSONAndPost:(NSArray*) userData postType:(NNPostType)postType{
    
    NSArray *postDataKeys = [NSArray new];
    NSString *apiEndPointURL;
    
    // TODO: request that web designer notify of any future alterations
    switch (postType) {
        case NNUserPost:
            postDataKeys = @[@"username",
                             @"first_name",
                             @"last_name",
                             @"email",
                             @"groups",
                             @"user_permissions"];
            apiEndPointURL = @"http://safe-depths-8610.herokuapp.com/api/v1/users/";
            break;
            
        case NNWordManipulationPost:
            postDataKeys = @[@"session",
                             @"user",
                             @"word_manipulated",
                             @"active_powerups",
                             @"shape_match",
                             @"sm_direction",
                             @"sm_distance",
                             @"sm_shape_match",
                             @"sm_hair_match",
                             @"network_manipulation",
                             @"nm_scaffolding_of_word",
                             @"nm_color_level",
                             @"nm_network_connection",
                             @"nm_network_combo",
                             @"nm_network_combo_type"];
            apiEndPointURL = @"http://safe-depths-8610.herokuapp.com/api/v1/word-manipulations/";
            break;
            
        case NNSessionsPost:
            postDataKeys = @[@"user",
                             @"start_time",
                             @"end_time",
                             @"total_time"];
            apiEndPointURL = @"http://safe-depths-8610.herokuapp.com/api/v1/sessions/";
            break;
            
        case NNTimePlayingPost:
            postDataKeys = @[@"session",
                             @"user",
                             @"screen",
                             @"time_on_screen"];
            apiEndPointURL = @"http://safe-depths-8610.herokuapp.com/api/v1/time-playings/";
            break;
            
        case NNTranslationFilterUsagesPost:
            postDataKeys = @[@"session",
                             @"user",
                             @"level",
                             @"quantity_filter_used",
                             @"total_time_used"];
            apiEndPointURL = @"http://safe-depths-8610.herokuapp.com/api/v1/translation-filter-usages/";
            break;
        default:
            break;
    }
    
    NSDictionary *postData = [[NSDictionary alloc]initWithObjects:userData forKeys:postDataKeys];
    
    NSString *jsonString = [self createJSONStringFrom:postData];
    if (jsonString == nil) {
        return NO;
    }
    BOOL postedSuccessfully =[self postUserDataToServer:jsonString
                                                     to:apiEndPointURL
                                          usingUsername:@"username"
                                               password:@"password"];
    if (postedSuccessfully) {
        return YES;
    }
    return NO;
}
    
+(NSString*)createJSONStringFrom:(NSDictionary*)data{
    NSError *error = nil;
    
    //Serialize the JSON data
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:data
                                                       options:0
                                                         error:&error];
    
    if ([jsonData length] > 0 && error == nil) {
        //Create a string from the JSON Data
        NSString *jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
        NSLog(@"JSON String = %@",jsonString);
        return jsonString;
    }
    else if ([jsonData length] == 0 && error == nil){
        NSLog(@"No data was returned after the serialization");
    }
    else if (error != nil){
        NSLog(@"An error happened = %@",error);
    }
    return nil;
}

+(BOOL)postUserDataToServer:(NSString*)jsonString to:(NSString*)apiEndPointUrl usingUsername:(NSString*)username password:(NSString*)password{

    //Formatting the URL
    NSURL *url = [NSURL URLWithString:apiEndPointUrl];
    
    //Formatting authentication credentials
    NSString *authStr = [NSString stringWithFormat:@"%@:%@", username, password];
    NSData *authData = [authStr dataUsingEncoding:NSASCIIStringEncoding];
    NSString *authValue = [authData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    
    //Structuring the URL request
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
    [urlRequest setTimeoutInterval:30.0f];
    [urlRequest setHTTPMethod:@"POST"];
    [urlRequest setHTTPBody:[jsonString dataUsingEncoding:NSUTF8StringEncoding]];
    [urlRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [urlRequest setValue:[NSString stringWithFormat:@"Basic %@",authValue] forHTTPHeaderField:@"Authorization"];
    
    
    NSOperationQueue *queue = [[NSOperationQueue alloc]init];

    //Create the URL Connection
    [NSURLConnection sendAsynchronousRequest:urlRequest
                                       queue:queue
                           completionHandler:^(NSURLResponse *response,
                                               NSData *data,
                                               NSError *connectionError) {
                               if ([data length] >0 && connectionError == nil) {
                                   //TODO: Get a list of possible return strings (Duplucate user name, invalid value, success, invalid authorization, .etc
                                   NSString *html = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                   NSLog(@"HTML = %@",html);
                               }
                               else if (connectionError !=nil){
                                   NSLog(@"Error happened = %@",connectionError);
                               }
                           }];
    return YES;


}
//-(void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge{
//    if([challenge previousFailureCount]==0){
//        NSURLCredential *credential = [NSURLCredential credentialWithUser:@"ontario" password:@"Iew5Pear" persistence:NSURLCredentialPersistenceForSession];
//        
//        [[challenge sender] useCredential:credential forAuthenticationChallenge:challenge];
//        NSLog(@"Credentials provided");
//    }
//    else{
//        NSLog(@"Credential failure");
//    }
//}


@end
