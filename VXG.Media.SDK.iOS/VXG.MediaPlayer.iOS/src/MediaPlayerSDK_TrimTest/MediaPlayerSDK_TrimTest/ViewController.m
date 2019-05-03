//
//  ViewController.m
//  MediaPlayerSDK_TrimTest
//
//  Created by user on 18/05/2018.
//  Copyright © 2018 VXG Inc. All rights reserved.
//

#import "ViewController.h"
#import "Cells/videoListCell.h"
#import "PlayVideoVC.h"

@interface ViewController ()

@end

@implementation ViewController {
    
    __weak IBOutlet UITableView *tv_videoList;
    UITextField* tf_tmp;
    UITextField* tf_active;
    NSDictionary* current_info;
    NSArray<NSDictionary*>* recordList;
    NSString* recordsPath;
    UILongPressGestureRecognizer* LongTap;
}

-(NSArray<NSDictionary*>*) getVideoFileList {
    

    NSMutableArray<NSDictionary*>* filelist = [[NSMutableArray<NSDictionary*> alloc] init];
    
    
    NSArray* tmpDirectory = [[NSFileManager defaultManager] contentsOfDirectoryAtPath: recordsPath error:NULL];
    NSDictionary* rec;
    
    for (NSString *file in tmpDirectory) {
       rec = [NSDictionary dictionaryWithObjectsAndKeys: file, @"filename", [NSString stringWithFormat:@"%@/%@", recordsPath, file], @"fullpath", @"record", @"type", nil];
       [filelist addObject: rec];
    }
    
    //debug
    //NSDictionary* rec0 = [NSDictionary dictionaryWithObjectsAndKeys:@"1.file",@"filename", @"~/1.file", @"fullpath", @"record", @"type", nil];
    //[filelist addObject:rec0];
    //rec0 = [NSDictionary dictionaryWithObjectsAndKeys:@"2.file",@"filename", @"~/2.file", @"fullpath", @"record", @"type", nil];
    //[filelist addObject:rec0];
    //rec0 = [NSDictionary dictionaryWithObjectsAndKeys:@"3.file",@"filename", @"~/3.file", @"fullpath", @"record", @"type", nil];
    //[filelist addObject:rec0];
    //\debug
    
    return filelist;
}

-(void) handleLongPress:(UILongPressGestureRecognizer*) gestureRecognizer {
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        CGPoint p = [gestureRecognizer locationInView: tv_videoList];
        NSIndexPath *indexPath =[tv_videoList indexPathForRowAtPoint: p];
        if ((indexPath == nil) || (indexPath.section == 0))  {
            NSLog(@"miss!");
        } else {
            videoListCell * cell = [tv_videoList cellForRowAtIndexPath: indexPath];
            if (cell.isHighlighted) {
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Select action"
                                                                                         message:@""
                                                                                  preferredStyle:UIAlertControllerStyleActionSheet];
                
                alertController.popoverPresentationController.sourceView = cell;
                alertController.popoverPresentationController.sourceRect = cell.bounds;
                
                
                UIAlertAction *actionDelete = [UIAlertAction actionWithTitle:@"Delete" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action){
                    NSError* error;
                    [[NSFileManager defaultManager] removeItemAtPath: [cell.info objectForKey:@"fullpath"] error: &error];
                    [self viewDidAppear:NO];
                }];
                UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action){}];
                
                [alertController addAction:actionDelete];
                [alertController addAction:actionCancel];
                
                [self presentViewController:alertController animated:YES completion:nil];
            } else {
                NSLog(@"1");
            }
        }
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

   
    tf_tmp = nil;
    tf_active = nil;
    tv_videoList.dataSource = self;
    tv_videoList.delegate = self;
    
    NSError * error;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0]; // Get documents folder
    recordsPath = [documentsDirectory stringByAppendingPathComponent: @"Records"];
    [[NSFileManager defaultManager] createDirectoryAtPath:recordsPath withIntermediateDirectories:NO attributes:nil error:&error];
    
    LongTap = [[UILongPressGestureRecognizer alloc] initWithTarget: self action:@selector(handleLongPress:)];
    LongTap.minimumPressDuration = 1.0;
    LongTap.delegate = self;
    [tv_videoList addGestureRecognizer:LongTap];
}

- (void)viewDidAppear:(BOOL)animated {
    NSLog(@"<binary>Should update record list");
    recordList = [self getVideoFileList];
    [tv_videoList reloadData];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) showError: (NSString*) title msg: (NSString*) msg {
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertController* code = [UIAlertController alertControllerWithTitle:title message: msg preferredStyle: UIAlertControllerStyleAlert];
        UIAlertAction *confirmCancel = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action){}];
        [code addAction:confirmCancel];
        [self presentViewController:code animated:YES completion:nil];
    });
}

#pragma mark textfield

-(BOOL) textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

-(void) textFieldDidBeginEditing:(UITextField *)textField {
    tf_tmp = textField;
}

-(void) textFieldDidEndEditing:(UITextField *)textField {
    tf_tmp = nil;
    [textField resignFirstResponder];
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    return YES;
}

-(BOOL)textFieldShouldClear:(UITextField *)textField {
    return YES;
}
#pragma mark tableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        //[tableView deselectRowAtIndexPath: indexPath animated: NO];
    } else if (tf_tmp != nil) {
        [tf_tmp resignFirstResponder];
        tf_tmp = nil;
        //[tableView deselectRowAtIndexPath: indexPath animated: NO];
    } else if (indexPath.section == 1){
        current_info = [recordList objectAtIndex: indexPath.row];
        [self performSegueWithIdentifier:@"showVideo_segue" sender:self];
    }
    [tableView deselectRowAtIndexPath: indexPath animated: NO];
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"videoListCell";
    videoListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil)
    {
        NSLog(@"tabel_view: new cell here!");
        cell = [[videoListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    if (indexPath.section == 0) {
        cell.tf_linkVideo.delegate  = self;
        cell.tf_linkVideo.enabled   = YES;
        tf_active = cell.tf_linkVideo;
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    } else {
        cell.tf_linkVideo.delegate  = nil;
        cell.tf_linkVideo.enabled   = NO;
        
        NSDictionary* info = [recordList objectAtIndex: indexPath.row];
        
        [cell  hideGo];
        cell.info = info;
        cell.tf_linkVideo.text = (NSString*)[info objectForKey:@"filename"];
    }
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return @"Connect";
    } else if (section == 1) {
        return @"Records";
    }
    return nil;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    } else if (section == 1) {
        return [recordList count];
    }
    return 0;
}

#pragma mark Segues

- (IBAction)btnGO_click:(UIButton *)sender {
    NSLog(@"%s called\n", __func__);
    
    if (tf_active && ([[tf_active text] length] > 0)) {
        current_info = [NSDictionary dictionaryWithObjectsAndKeys: @"live",@"type",[tf_active text], @"fullpath", @"stream", @"filename", nil];
        [self performSegueWithIdentifier: @"showVideo_segue" sender: self];
    } else {
        [self showError:@"Error" msg: @"Empty video URL"];
    }
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showVideo_segue"]) {
        PlayVideoVC* des = segue.destinationViewController.childViewControllers[0];
        [des setVideoInfo: current_info];
        [des setRecordPath: recordsPath];
    }
}

#pragma mark ViewRotation

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(nonnull id<UIViewControllerTransitionCoordinator>)coordinator {
    return;
}


@end
