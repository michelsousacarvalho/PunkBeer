//
//  HTTPRequest.m
//  PunkBeer
//
//  Created by Michel de Sousa Carvalho on 31/05/17.
//  Copyright © 2017 Michel de Sousa Carvalho. All rights reserved.
//

#import "HTTPRequest.h"

@implementation HTTPRequest

+(void) makeGETRequestToURL: (NSString *)urlString
      withCompletionHandler:(void (^)(id result, NSError *error))completion {
    NSURLSession *session = [HTTPRequest newSession];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    urlRequest.HTTPMethod = @"GET";
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:urlRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        id resultRequest;
        if(data){
            resultRequest = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
        }
        
        NSLog(@"STATUS CODE: %ld", (long)response.description);
        NSLog(@"Erro retornado: %@", error.description);
        completion(resultRequest, error);
    }];
    
    [dataTask resume];
}


+ (NSURLSession *) newSession{
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    return session;
}


@end
