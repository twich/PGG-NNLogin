//
//  NNAnalyticsController.m
//  NNAnalyticsController
//
//  Created by Scott Twichel on 8/7/14.
//  Copyright (c) 2014 PepperGum Games. All rights reserved.
//

#import "NNAnalyticsController.h"


@implementation NNAnalyticsController

+(NSString*)formatUserDataForUpload:(NSDictionary*) userData{

    NSError *error = nil;
    
    //Serialize the JSON data
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:userData
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

+(BOOL)postUserDataToServer:(NSString*)jsonString usingUsername:(NSString*)username password:(NSString*)password{

    //Formatting the URL
    NSString *urlAsString = @"http://safe-depths-8610.herokuapp.com/users/";
    NSURL *url = [NSURL URLWithString:urlAsString];
    
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
