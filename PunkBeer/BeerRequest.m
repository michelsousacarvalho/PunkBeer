//
//  BeerRequest.m
//  PunkBeer
//
//  Created by Michel de Sousa Carvalho on 31/05/17.
//  Copyright © 2017 Michel de Sousa Carvalho. All rights reserved.
//

#import "BeerRequest.h"
#import "Beer+CoreDataClass.h"
#import "HTTPRequest.h"

@implementation BeerRequest


+(void) requestBeerAndSaveCoreDataWithCompletion:(void (^) (void)) completion {
    if([Beer countBeers] == 0){
        [HTTPRequest makeGETRequestToURL:URLRequest withCompletionHandler:^(id result, NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                for(NSDictionary *eachBeer in result) {
                    Beer *beer = [Beer createBeer];
                    if([eachBeer objectForKey:@"abv"] != [NSNull null]){
                        beer.abv = [[eachBeer objectForKey:@"abv"] floatValue];
                    }
                    if([eachBeer objectForKey:@"ibu"] != [NSNull null]){
                        beer.ibu = [[eachBeer objectForKey:@"ibu"] floatValue];
                    }
                    beer.imageUrl = [eachBeer objectForKey:@"image_url"];
                    beer.name = [eachBeer objectForKey:@"name"];
                    beer.tagline = [eachBeer objectForKey:@"tagline"];
                    beer.descriptionBeer = [eachBeer objectForKey:@"description"];
                    [Beer saveBeer:beer];
                }
                completion();
            });
        }];
    } else {
        completion();
    }
}


+(void) requestBeerBackgroundFetch:(void(^) (BOOL newData)) completion {
    [HTTPRequest makeGETRequestToURL:URLRequest withCompletionHandler:^(id result, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            BOOL createNewData = false;
            for(NSDictionary *eachBeer in result) {
                if(![Beer verifyExistBeerWithName:[eachBeer objectForKey:@"name"]]){
                    Beer *beer = [Beer createBeer];
                    if([eachBeer objectForKey:@"abv"] != [NSNull null]){
                        beer.abv = [[eachBeer objectForKey:@"abv"] floatValue];
                    }
                    if([eachBeer objectForKey:@"ibu"] != [NSNull null]){
                        beer.ibu = [[eachBeer objectForKey:@"ibu"] floatValue];
                    }
                    beer.imageUrl = [eachBeer objectForKey:@"image_url"];
                    beer.name = [eachBeer objectForKey:@"name"];
                    beer.tagline = [eachBeer objectForKey:@"tagline"];
                    beer.descriptionBeer = [eachBeer objectForKey:@"description"];
                    [Beer saveBeer:beer];
                    createNewData = true;
                }
            }
            completion(createNewData);
        });
    }];
}



@end
