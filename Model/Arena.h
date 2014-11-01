//
//  Arena.h
//  Robots
//
//  Created by Aijaz Ansari on 11/1/14.
//  Copyright (c) 2014 Euclid Software, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Player.h"

@interface Arena : NSObject

@property (readonly, nonatomic) NSInteger width;
@property (readonly, nonatomic) NSInteger height;
@property (readonly, nonatomic) NSInteger playerStartX;
@property (readonly, nonatomic) NSInteger playerStartY;


@property (strong, nonatomic) NSSet * robots;
@property (strong, nonatomic) NSSet * debris;
@property (strong, nonatomic) Player * player;

-(void) restartGame;

@end
