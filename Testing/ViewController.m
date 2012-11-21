//
//  ViewController.m
//  Testing
//
//  Created by ORGware on 9/26/12.
//  Copyright (c) 2012 ORGware. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    NSMutableString *str=[[NSMutableString alloc]init];
    /*
    EKEventStore *eventStoreObj = [[EKEventStore alloc] init];
    EKEvent *events = [EKEvent eventWithEventStore:eventStoreObj];
    NSArray *caleandarsArray = [[NSArray alloc] init];
    caleandarsArray = [eventStoreObj calendars];
    
    
    for (EKCalendar *iCalendars in caleandarsArray)
    {
        NSLog(@"Calendar Title : %@", iCalendars.title);
        [str appendString:iCalendars.title];
    }
    */
    EKEventStore *eventStore=[[EKEventStore alloc]init];
    
    NSString *startDateStr = [NSString stringWithFormat:@"%@T%@GMT",@"2011-01-01",@"08:00:00"];
   
    NSString *endDateStr = [NSString stringWithFormat:@"%@T%@GMT",@"2013-12-21",@"09:00:00"];
	
	NSDateFormatter *formater = [NSDateFormatter new];
    
	[formater setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss'GMT'"];
	
	//NSDate *startDate = [formater dateFromString:startDateStr];
	
	//NSDate *endDate=[formater dateFromString:endDateStr];
    
    NSDate *start = [formater dateFromString:startDateStr];
    
    NSDate *finish = [formater dateFromString:endDateStr];
    
    // use Dictionary for remove duplicates produced by events covered more one year segment
    NSMutableDictionary *eventsDict = [NSMutableDictionary dictionaryWithCapacity:1024];
    
    NSDate* currentStart = [NSDate dateWithTimeInterval:0 sinceDate:start];
    
    int seconds_in_year = 60*60*24*365;
    
    // enumerate events by one year segment because iOS do not support predicate longer than 4 year !
    while ([currentStart compare:finish] == NSOrderedAscending) {
        
        NSDate* currentFinish = [NSDate dateWithTimeInterval:seconds_in_year sinceDate:currentStart];
        
        if ([currentFinish compare:finish] == NSOrderedDescending) {
            currentFinish = [NSDate dateWithTimeInterval:0 sinceDate:finish];
        }
        NSPredicate *predicate = [eventStore predicateForEventsWithStartDate:currentStart endDate:currentFinish calendars:nil];
       /* [eventStore enumerateEventsMatchingPredicate:predicate
                                          usingBlock:^(EKEvent *event, BOOL *stop) {
                                              
                                              if (event) {
                                                  [eventsDict setObject:event forKey:event.eventIdentifier];
                                              }
                                              
                                          }];   */    
        currentStart = [NSDate dateWithTimeInterval:(seconds_in_year + 1) sinceDate:currentStart];
        NSArray *events=[eventStore eventsMatchingPredicate:predicate];
        NSLog(@"events Title %@",[[events objectAtIndex:0] title]);
        
    }
    
    //NSArray *events = [eventsDict allValues];
    
    NSArray *eventIds=[eventsDict allKeys];
    
    for (NSString *eventId in eventIds)
        [str appendString:eventId];
    
    UITextView *txtVw=[[UITextView alloc]initWithFrame:self.view.bounds];
    
    [txtVw setText:str];
    
    [self.view addSubview:txtVw];
    
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

-(IBAction)stepperTapped {

    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
