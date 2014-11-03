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
#import "Debris.h"
#import "Player.h"

@interface Arena ()

@property (assign, nonatomic) NSInteger level;
@property (strong, nonatomic) NSMutableArray *board;


@end


@implementation Arena

- (instancetype)init
{
    self = [super init];
    if (self) {
        _width = 19;
        _height = 19;
        _playerStartX = 9;
        _playerStartY = 9;
        _player = [[Player alloc] init];
        
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
    [self moveItem: self.player toX:self.playerStartX y:self.playerStartY];
    
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
    
    _safeTeleportsLeft = level;
    _bombsLeft = level/2;
    NSLog(@"Board is: \n\n%@\n", self);
}

-(NSString *)description {
    return [self dumpBoard];
}

-(void) moveItem: (Item *) item toX: (NSInteger) x y: (NSInteger) y {
    // set the attributes of the object
    self.board[y][x] = item;
    [item moveToX:x y:y];
}

-(BOOL) isSpotEmptyWithXOffset: (NSInteger) xOffset yOffset: (NSInteger) yOffset {
    // reject invalid moves first
    if (self.player.x + xOffset < 0
        || self.player.x + xOffset >= self.width
        || self.player.y + yOffset < 0
        || self.player.y + yOffset >= self.height) {
        return NO;
    }
    if (self.board[self.player.y + yOffset][self.player.x + xOffset] == [NSNull null]) {
        return YES;
    }
    else {
        return NO;
    }
}


-(NSDictionary *)validMoves {
    NSMutableDictionary * dictionary = [NSMutableDictionary dictionaryWithCapacity:9];
 
    if ([self isSpotEmptyWithXOffset:-1 yOffset:-1]) { dictionary[@(1)] = @YES; }
    if ([self isSpotEmptyWithXOffset: 0 yOffset:-1]) { dictionary[@(2)] = @YES; }
    if ([self isSpotEmptyWithXOffset: 1 yOffset:-1]) { dictionary[@(3)] = @YES; }
    if ([self isSpotEmptyWithXOffset:-1 yOffset: 0]) { dictionary[@(4)] = @YES; }
    
    dictionary[@(5)] = @YES; // always ok to stay where you are
    
    if ([self isSpotEmptyWithXOffset: 1 yOffset: 0]) { dictionary[@(6)] = @YES; }
    if ([self isSpotEmptyWithXOffset:-1 yOffset: 1]) { dictionary[@(7)] = @YES; }
    if ([self isSpotEmptyWithXOffset: 0 yOffset: 1]) { dictionary[@(8)] = @YES; }
    if ([self isSpotEmptyWithXOffset: 1 yOffset: 1]) { dictionary[@(9)] = @YES; }
    
    return dictionary;
}


-(void)moveToSpot:(NSInteger)spot {
    
    // don't do anything if the player is already dead
    if (self.player.isDead) {
        return;
    }
    
    NSInteger xOffset = 0;
    NSInteger yOffset = 0;
 
    if (spot <= 3) {
        yOffset = -1;
    }
    else if (spot >= 7) {
        yOffset = 1;
    }
    if (spot == 1 || spot == 4 || spot == 7) {
        xOffset = -1;
    }
    else if (spot == 3 || spot == 6 || spot == 9) {
        xOffset = 1;
    }
    
    NSInteger newPlayerX = self.player.x + xOffset;
    NSInteger newPlayerY = self.player.y + yOffset;
    
    // "pick up player"
    self.board[self.player.y][self.player.x] = [NSNull null];
    [self moveItem:self.player toX:newPlayerX y:newPlayerY];
    
    // The set of robots may need to be changed if the robots
    // collide with anything after they move towards the player
    NSMutableSet * newRobotSet = [NSMutableSet setWithCapacity:[self.robots count]];

    // "Pick up" all the robots
    for (Robot * robot in self.robots) {
        self.board[robot.y][robot.x] = [NSNull null];
    }
    
    // now move all robots and check for collisions
    for (Robot * robot in self.robots) {
        NSInteger robotX = robot.x;
        NSInteger robotY = robot.y;
        
        if (robotX < newPlayerX) {
            robotX += 1; // the same as robotX = robotX + 1
        }
        else if (robotX > newPlayerX) {
            robotX -= 1;
        }
        
        if (robotY < newPlayerY) {
            robotY++; // the same as robotY = robotY + 1;
        }
        else if (robotY > newPlayerY) {
            robotY--;
        }
        
        // now that we know the new x and y coordinates of the robot, we need to know if the robot collided with anything or now.
        
        if (self.board[robotY][robotX]!= [NSNull null]) {
            // There's already something in that spot.
            if ([self.board[robotY][robotX] class] == [Player class]) {
                // there is the player there
                self.player.isDead = YES;
                robot.alreadyMoved = YES;
                // don't need to add the robot to the newRobotSet because the game is over
                // We'll show the dead player there instead
            }
            else if ([self.board[robotY][robotX] class] == [Robot class]) {
                // there's a robot there
                Robot * previousRobot = self.board[robotY][robotX];
                [newRobotSet removeObject:previousRobot];
                Debris * newDebris = [[Debris alloc] init];
                [self moveItem:newDebris toX:robotX y:robotY];
                [self.debris addObject:newDebris];
            }
            else if ([self.board[robotY][robotX] class] == [Debris class]) {
                // there is debris there
                // don't add this robot to the newRobotSet
            }
        }
        else {
            [self moveItem:robot toX:robotX y:robotY];
            [newRobotSet addObject:robot];
        }
        
        self.robots = newRobotSet;
        
    }
    
    NSLog(@"Board is: \n\n%@\n", self);
    
    
}

-(NSString *) dumpBoard {
    NSMutableArray * rows = [NSMutableArray arrayWithCapacity:self.height];

    for (int i = 0; i < self.height; i++) {
        NSMutableArray * row = [NSMutableArray arrayWithCapacity:self.width];
        for (int j = 0; j < self.width; j++) {
            if (self.board[i][j] == [NSNull null]) {
                [row addObject:@"."];
            }
            else {
                id item = self.board[i][j];
                [row addObject:[item description]];
            }
        }
        [rows addObject:[row componentsJoinedByString:@""]];
    }
    return [rows componentsJoinedByString:@"\n"];
}


-(void)teleport {
    while (true) {
        NSInteger randomX = arc4random_uniform((UInt32) self.width);
        NSInteger randomY = arc4random_uniform((UInt32) self.height);

        if (self.board[randomY][randomX] == [NSNull null]) {
            [self moveItem:self.player toX:randomX y:randomY];
            [self moveToSpot:5]; // record a move to the new location
            break; // get out this infinite loop
        }
    }
}

@end
