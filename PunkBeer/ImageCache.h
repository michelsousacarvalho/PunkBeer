//
//  ImageCache.h
//  PunkBeer
//
//  Created by Michel de Sousa Carvalho on 31/05/17.
//  Copyright © 2017 Michel de Sousa Carvalho. All rights reserved.
//



#import <Foundation/Foundation.h>
#import "ImageRequest.h"

@interface ImageCache : NSObject

+(ImageCache *) sharedInstance;

@property(nonatomic, strong) ImageRequest *imageRequest;

@end
