

#import "ViewController.h"
#import "AppDelegate.h"
#import "Person+CoreDataClass.h"

@interface ViewController ()

@property (nonatomic) AppDelegate *appDelegate;

@property (weak, nonatomic) IBOutlet UITextField *inputField;
@property (weak, nonatomic) IBOutlet UILabel *objectStorageLabel;
@property (weak, nonatomic) IBOutlet UILabel *objectCounterLabel;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [self updateLogList];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)addObjectTapped:(id)sender {
    Person *person = [self.appDelegate createPerson];
    person.person_Name = self.inputField.text;
    [self.appDelegate saveContext];
    [self updateLogList];
}

- (IBAction)deleteObject:(id)sender {
    NSManagedObjectContext *moc = self.appDelegate.managedObjectContext;
    NSFetchRequest *request =  [NSFetchRequest fetchRequestWithEntityName:@"Person"];
    
    NSError *error = nil;
    NSArray *results = [moc executeFetchRequest:request error:&error];
    if (!results) {
         NSLog(@"Error fetching Person objects %@\n%@", [error localizedDescription], [error userInfo]);
        abort();
    }
    for(Person *p in results) {
        [moc deleteObject:p];
    }
    [self.appDelegate saveContext];
    [self updateLogList];
    
}


- (void) updateLogList {
    NSManagedObjectContext *moc = self.appDelegate.managedObjectContext;
    NSFetchRequest *request =  [NSFetchRequest fetchRequestWithEntityName:@"Person"];
    
    NSError *error = nil;
    NSArray *results = [moc executeFetchRequest:request error:&error];
    if (!results) {
        NSLog(@"Error fetching Person objects %@\n%@", [error localizedDescription], [error userInfo]);
        abort();
    }
   
    NSMutableString *buffer = [NSMutableString stringWithString:@""];
    for(Person *p in results) {
        [buffer appendFormat:@"\n%@", p.person_Name, nil];
    }
    self.objectStorageLabel.text = buffer;
    self.objectCounterLabel.text = [NSString stringWithFormat:@"%lu", (signed long)[self countOfObject]];
}

- (NSUInteger) countOfObject {
    NSManagedObjectContext *moc = self.appDelegate.managedObjectContext;
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    request.entity = [NSEntityDescription entityForName:@"Person" inManagedObjectContext:moc];
    request.includesSubentities = NO;

    NSError *err;
    NSUInteger count = [moc countForFetchRequest:request error:&err];
        if (count == NSNotFound) {
            return 0;
        }
            return count;
}

@end
