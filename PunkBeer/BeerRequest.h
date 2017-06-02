//
//  BeerRequest.h
//  PunkBeer
//
//  Created by Michel de Sousa Carvalho on 31/05/17.
//  Copyright © 2017 Michel de Sousa Carvalho. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BeerRequest : NSObject

/**
 @brief Faz request de cervejas e salva no core data com completion quando termina de fazer as operacoes
 **/
+(void) requestBeerAndSaveCoreDataWithCompletion:(void (^) (void)) completion;

/**
 @brief Faz request verifica se cerveja já contém no core data e salva, metodo usado para background fetch
 **/
+(void) requestBeerBackgroundFetch:(void(^) (BOOL newData)) completion;

@end
