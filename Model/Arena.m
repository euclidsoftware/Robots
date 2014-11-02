//
//  Arena.m
//  Robots
//
//  Created by Aijaz Ansari on 11/1/14.
//  Copyright (c) 2014 Euclid Software, LLC. All rights reserved.
//

#import "Arena.h"
#import "Item.h"
#import "Robot.h"

@interface Arena ()

@property (assign, nonatomic) NSInteger level;
@property (strong, nonatomic) NSMutableArray *board;


@end


@implementation Arena

- (instancetype)init
{
    self = [super init];
    if (self) {
        _player = [[Player alloc] init];
        _playerStartX = 9;
        _playerStartY = 9;
        _width = 19;
        _height = 19;
        
        _board = [NSMutableArray arrayWithCapacity:_height];
        for (NSInteger h = 0; h < _height; h++) {
            NSMutableArray * row = [NSMutableArray arrayWithCapacity:_width];
            for (NSInteger w = 0; w < _width; w++) {
                [row addObject:[NSNull null]];
            }
            [_board addObject:row];
        }
        
        [self restartGame];
    }
    return self;
}


-(void)restartGame {
    self.level = 1;
    [self startLevel:1];
}

-(void) startLevel: (NSInteger) level {
    [self.player moveToX:self.playerStartX y:self.playerStartY];
    
    NSInteger numRobots = 10 + ((level - 1) * 3);
    self.robots = [NSMutableSet setWithCapacity:numRobots];
    self.debris = [NSMutableSet setWithCapacity:numRobots / 2];
    
    while (numRobots > 0) {
        NSInteger randomX = arc4random_uniform((UInt32) self.width);
        NSInteger randomY = arc4random_uniform((UInt32) self.height);
        
        if (self.board[randomY][randomX] == [NSNull null]) {
            // This is an empty spot. It's okay to move here
            Robot * robot = [[Robot alloc] init];
            [self moveItem:robot toX:randomX y:randomY];
            numRobots--;
            [self.robots addObject:robot];
        }
        else {
            // There was already something in that spot
            // Try another spot - don't decrement numRobots
        }
    }
}


-(void) moveItem: (Item *) item toX: (NSInteger) x y: (NSInteger) y {
    
    // set the attributes of the object
    [item moveToX:x y:y];
    
    self.board[y][x] = item;
}

@end
