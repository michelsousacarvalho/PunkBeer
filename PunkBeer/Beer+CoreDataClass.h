//
//  Beer+CoreDataClass.h
//  PunkBeer
//
//  Created by Michel de Sousa Carvalho on 31/05/17.
//  Copyright © 2017 Michel de Sousa Carvalho. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

NS_ASSUME_NONNULL_BEGIN

@interface Beer : NSManagedObject


/**
 @brief Retorna quantidade de cerveja que contém no core data
 **/
+(NSUInteger)countBeers;

/**
 @brief Cria nova cerveja
 **/
+(Beer *) createBeer;

/**
 @brief Verifica se possui cerveja com o mesmo nome
 **/
+(BOOL) verifyExistBeerWithName:(NSString *) name;

/**
 @brief Salva Beer no Core data
 **/
+(void) saveBeer:(Beer*) beer;


/**
 @brief Faz request de todas as cerveja no Core data
 **/

+(NSArray *) getAllBeers;

/**
 @brief Faz request de todas as cerveja no Core data ordenada por nome
 **/
+(NSArray *) getAllBeersOrdered;

@end

NS_ASSUME_NONNULL_END

#import "Beer+CoreDataProperties.h"
