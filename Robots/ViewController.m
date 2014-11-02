//
//  ViewController.m
//  Robots
//
//  Created by Aijaz Ansari on 11/1/14.
//  Copyright (c) 2014 Euclid Software, LLC. All rights reserved.
//

#import "ViewController.h"

// Model
#import "Arena.h"
#import "Robot.h"

// View
#import "ArenaView.h"
#import "ItemLocation.h"

@interface ViewController ()

// Model
@property (strong, nonatomic) Arena * arena;

// View
@property (weak, nonatomic) IBOutlet ArenaView *arenaView;
@property (weak, nonatomic) IBOutlet UIButton *bnw;
@property (weak, nonatomic) IBOutlet UIButton *bn;
@property (weak, nonatomic) IBOutlet UIButton *bne;
@property (weak, nonatomic) IBOutlet UIButton *bw;
@property (weak, nonatomic) IBOutlet UIButton *bc;
@property (weak, nonatomic) IBOutlet UIButton *be;
@property (weak, nonatomic) IBOutlet UIButton *bsw;
@property (weak, nonatomic) IBOutlet UIButton *bs;
@property (weak, nonatomic) IBOutlet UIButton *bse;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    // Set up the model
    self.arena = [[Arena alloc] init];

    
    [self.arenaView setColumns:self.arena.width rows:self.arena.height];
    [self.arenaView setPlayerLocation:[[ItemLocation alloc] initWithColumn:self.arena.playerStartX row:self.arena.playerStartY]];
    
    NSMutableSet * robotLocations = [NSMutableSet setWithCapacity:[self.arena.robots count]];
    for (Robot * robot in self.arena.robots) {
        [robotLocations addObject:[[ItemLocation alloc] initWithColumn:robot.y row:robot.x]];
    }
    
    self.arenaView.robotLocations = robotLocations;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)handleMove:(UIButton *)sender {
}
@end
