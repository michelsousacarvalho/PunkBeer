//
//  ImageRequest.m
//  PunkBeer
//
//  Created by Michel de Sousa Carvalho on 31/05/17.
//  Copyright © 2017 Michel de Sousa Carvalho. All rights reserved.
//


#import "ImageRequest.h"
#import "ImageSaveDisk.h"

@implementation ImageRequest


-(id) init
{
    self = [super init];
    if(self)
    {
        self.imagesCache = [[NSMutableDictionary alloc] init];
        self.operationCache = [[NSMutableDictionary alloc] init];
        self.queue = [[NSOperationQueue alloc]init];
    }
    return self;
}

-(void) fetchImageWithUrl:(NSString *)url andNameImage:(NSString*)nameImage withcompletionBlock:(ImageRequestBlock)completionBlock
{
    UIImage *imageOfCache = self.imagesCache[nameImage];
    if(imageOfCache) {
        completionBlock(imageOfCache);
    } else {
        NSBlockOperation *retrievalBlock = [[NSBlockOperation alloc] init];
        __weak NSBlockOperation *weakOperation = retrievalBlock;
        [retrievalBlock addExecutionBlock:^{
            NSString *pathImage = [ImageSaveDisk filePathForImage:nameImage];
            NSData *imageData;
            UIImage *image;
            // se não existir imagem no device realizar request e armazenar imagem
            if(![ImageSaveDisk imageExistsAtPath:pathImage]){
                NSURL *urlImage = [NSURL URLWithString:url];
                imageData = [NSData dataWithContentsOfURL:urlImage];
                if(imageData) {
                    [ImageSaveDisk saveImageDisk:imageData andName:pathImage];
                    image = [UIImage imageWithData:imageData];
                }
            } else {
                imageData = [ImageSaveDisk getImageByName:pathImage];
                image = [UIImage imageWithData:imageData];
            }
            
            if(image) {
                if (self.imagesCache) {
                    
                    [self.imagesCache setObject:image forKey:nameImage];
                } else {
                    self.imagesCache = [[NSMutableDictionary alloc] init];
                    [self.imagesCache setObject:image forKey:nameImage];
                }
            }
            
            if(![weakOperation isCancelled]){
                NSBlockOperation *block = [[NSBlockOperation alloc] init];
                [block addExecutionBlock:^{
                    completionBlock(image);
                }];
                [[NSOperationQueue mainQueue] addOperation:block];
            }
        }];
        if(retrievalBlock && url){
            [self.operationCache setObject:retrievalBlock forKey:url];
            [self.queue addOperation:retrievalBlock];
        }
    }
}

-(void)cancelImageDownloadWithURL:(NSString *)url withCompletionBlock:(void (^)(void))completionBlock
{
    NSBlockOperation *blockOperation = self.operationCache[url];
    if(blockOperation){
        [blockOperation cancel];
        completionBlock();
    }
}

@end
