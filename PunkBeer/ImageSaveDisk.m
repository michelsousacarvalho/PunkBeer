//
//  ImageSaveDisk.m
//  PunkBeer
//
//  Created by Michel de Sousa Carvalho on 31/05/17.
//  Copyright © 2017 Michel de Sousa Carvalho. All rights reserved.
//


#import "ImageSaveDisk.h"

@implementation ImageSaveDisk



+(NSString *)filePathForImage:(NSString *)nameImage{
    NSString *filePath = [NSTemporaryDirectory() stringByAppendingPathComponent:nameImage];
    return filePath;
}


+(NSData*) getImageByName:(NSString*) nameImage{
    return [NSData dataWithContentsOfFile:nameImage];
}

+(BOOL)imageExistsAtPath:(NSString *)pathImage{
    if(![[NSFileManager defaultManager] fileExistsAtPath:pathImage]){
        return false;
    } else {
        return true;
    }
    
}

+(void)saveImageDisk:(NSData *)imageData andName:(NSString *)nameImage{
    [imageData writeToFile:nameImage atomically:YES];
    
}

+(void) insertImageDisk:(NSString*) photoInString andPath:(NSString *) pathImage {
    NSData *imageData = [[NSData alloc] initWithBase64EncodedString:photoInString options:NSDataBase64DecodingIgnoreUnknownCharacters];
    if(imageData) {
        [ImageSaveDisk saveImageDisk:imageData andName:pathImage];
    }
}

@end
