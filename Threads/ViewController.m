//
//  ViewController.m
//  Threads
//
//  Created by Directv on 11/24/14.
//  Copyright (c) 2014 Training. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITableView *table;
@property (strong,nonatomic) NSMutableArray *items;
@property (strong,nonatomic) NSOperationQueue *processingQueue;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.table.delegate = self;
    self.table.dataSource = self;
    self.items = [[NSMutableArray alloc]initWithCapacity:45];
    [self.items addObjectsFromArray:@[@"items-1",@"items-2",@"items-3",@"items-4",@"items-5"]];
    self.processingQueue = [[NSOperationQueue alloc]init];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    SEL task = @selector(performTask:);
    for (int i=0;i<5;i++) {
        
        NSNumber *iteration = [NSNumber numberWithInt:i];
        NSInvocationOperation *operation = [[NSInvocationOperation alloc]initWithTarget:self selector:task object:iteration];
        [operation setCompletionBlock:^{
            NSLog(@"Operation #%d  compleeted",i);
        }];
        
        [self.processingQueue addOperation:operation];
        //[self performSelectorInBackground:task withObject:[NSNumber numberWithInteger:i]];
     }
}

- (void)performTask:( id) object{
    NSNumber *iteration =  object;
    
    NSMutableArray *newArray = [[NSMutableArray alloc] initWithCapacity:10];
    for (int i=1 ;i<=10; i++) {
        [newArray addObject:[NSString stringWithFormat:@"Item - %@,%d",iteration,i]];
        [NSThread sleepForTimeInterval:.1];
        NSLog(@"Main added %@- %d",iteration,i) ;
        
    }
    
    //[self.items addObjectsFromArray:newArray];
    
    //[self.table reloadData];
    
    [self performSelectorOnMainThread:@selector(updateTableData:) withObject:newArray waitUntilDone:NO];
    
}

-(void) updateTableData:(NSArray *) newArray {
    
    
    [self.items addObjectsFromArray:newArray];
    [self.table reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.items count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView
                             dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleDefault
                reuseIdentifier:CellIdentifier];
    }
    cell.textLabel.text = self.items[indexPath.row];
    return cell;
    
}

@end
