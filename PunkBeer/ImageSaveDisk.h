//
//  ImageSaveDisk.h
//  PunkBeer
//
//  Created by Michel de Sousa Carvalho on 31/05/17.
//  Copyright © 2017 Michel de Sousa Carvalho. All rights reserved.
//


#import <Foundation/Foundation.h>

@interface ImageSaveDisk : NSObject

+(NSString *) filePathForImage:(NSString *) nameImage;
+(BOOL) imageExistsAtPath:(NSString*) nameImage;
+(NSData*) getImageByName:(NSString*) nameImage;
+(void)saveImageDisk:(NSData *)imageData andName:(NSString *)nameImage;
+(void) insertImageDisk:(NSString*) photoInString andPath:(NSString *) pathImage;

@end
