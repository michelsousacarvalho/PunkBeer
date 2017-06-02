//
//  ImageCache.m
//  PunkBeer
//
//  Created by Michel de Sousa Carvalho on 31/05/17.
//  Copyright © 2017 Michel de Sousa Carvalho. All rights reserved.
//


#import "ImageCache.h"

@implementation ImageCache

static ImageCache *sharedInstance;

+(ImageCache *)sharedInstance
{
    if(!sharedInstance){
        sharedInstance = [[super allocWithZone:nil] init];
    }
    return sharedInstance;
}

+(id)allocWithZone:(struct _NSZone *)zone
{
    return [ImageCache sharedInstance];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.imageRequest = [[ImageRequest alloc] init];
    }
    return self;
}

@end
