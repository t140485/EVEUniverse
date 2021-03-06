//
//  NCDonationViewController.m
//  Neocom
//
//  Created by Артем Шиманский on 06.03.14.
//  Copyright (c) 2014 Artem Shimanski. All rights reserved.
//

#import "NCDonationViewController.h"
#import "ASInAppPurchase.h"
#import "UIActionSheet+Block.h"
#import "NCDonationCell.h"
#import "UIColor+Neocom.h"

@interface NCDonationViewController ()<SKPaymentTransactionObserver>
@property (nonatomic, assign, getter = isAnAppActive) BOOL inAppActive;
@end

@implementation NCDonationViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	self.refreshControl = nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onUpgrade:(id)sender {
	SKPaymentQueue *paymentQueue = [SKPaymentQueue defaultQueue];
	if (paymentQueue.transactions.count > 0)
		return;
	
	[paymentQueue addTransactionObserver:self];
	SKMutablePayment *payment = [[SKMutablePayment alloc] init];
	payment.productIdentifier = NCInAppFullProductID;
	payment.quantity = 1;
	[paymentQueue addPayment:payment];
	self.inAppActive = YES;
}

- (IBAction)onDonate:(id)sender {
	[[UIActionSheet actionSheetWithStyle:UIActionSheetStyleBlackTranslucent
								   title:nil
					   cancelButtonTitle:NSLocalizedString(@"Cancel", nil)
				  destructiveButtonTitle:nil
					   otherButtonTitles:@[NSLocalizedString(@"Donate $1", nil), NSLocalizedString(@"Donate $5", nil), NSLocalizedString(@"Donate $10", nil)]
						 completionBlock:^(UIActionSheet *actionSheet, NSInteger selectedButtonIndex) {
							 if (selectedButtonIndex != actionSheet.cancelButtonIndex) {
								 SKPaymentQueue *paymentQueue = [SKPaymentQueue defaultQueue];
								 if (paymentQueue.transactions.count > 0)
									 return;

								 NSString* productId = nil;
								 if (selectedButtonIndex == 0)
									 productId = NCInAppDonate1ProductID;
								 else if (selectedButtonIndex == 1)
									 productId = NCInAppDonate5ProductID;
								 else if (selectedButtonIndex == 2)
									 productId = NCInAppDonate10ProductID;
								 
								 [paymentQueue addTransactionObserver:self];
								 SKMutablePayment *payment = [[SKMutablePayment alloc] init];
								 payment.productIdentifier = productId;
								 payment.quantity = 1;
								 [paymentQueue addPayment:payment];
								 
								 self.inAppActive = YES;

							 }
						 } cancelBlock:nil] showFromRect:[sender bounds] inView:sender animated:YES];
}

- (IBAction)onRestore:(id)sender {
	SKPaymentQueue *paymentQueue = [SKPaymentQueue defaultQueue];
	if (paymentQueue.transactions.count > 0)
		return;
	
	[paymentQueue addTransactionObserver:self];
	[paymentQueue restoreCompletedTransactions];
	
	self.inAppActive = YES;

}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	NCDonationCell* cell;
	if ([ASInAppPurchase inAppPurchaseWithProductID:NCInAppFullProductID].purchased)
		cell = [tableView dequeueReusableCellWithIdentifier:@"DonateCell"];
	else
		cell = [tableView dequeueReusableCellWithIdentifier:@"UpgradeCell"];
	if (self.inAppActive) {
		cell.userInteractionEnabled = NO;
		[cell.activityIndicatorView startAnimating];
	}
	else {
		cell.userInteractionEnabled = YES;
		[cell.activityIndicatorView stopAnimating];
	}
	return cell;
}

#pragma mark - Table view delegate

- (void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
	cell.backgroundColor = [UIColor appearanceTableViewCellBackgroundColor];
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
		return [ASInAppPurchase inAppPurchaseWithProductID:NCInAppFullProductID].purchased ? 86 : 104;
	else
		return [ASInAppPurchase inAppPurchaseWithProductID:NCInAppFullProductID].purchased ? 104 : 140;
}

#pragma mark SKPaymentTransactionObserver

- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions {
	for (SKPaymentTransaction *transaction in transactions)
	{
		switch (transaction.transactionState)
		{
			case SKPaymentTransactionStatePurchased:
			case SKPaymentTransactionStateRestored: {
				[[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
				self.inAppActive = NO;
				[self.tableView reloadData];
				break;
			}
			case SKPaymentTransactionStateFailed: {
				[[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
				self.inAppActive = NO;
				[self.tableView reloadData];
				break;
			}
			default:
				break;
		}
	}
}

- (void)paymentQueue:(SKPaymentQueue *)queue restoreCompletedTransactionsFailedWithError:(NSError *)error {
	UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", nil)
														message:NSLocalizedString(@"Sorry, but we haven't found your purchases.", nil)
													   delegate:nil
											  cancelButtonTitle:NSLocalizedString(@"Close", nil)
											  otherButtonTitles:nil];
	[alertView show];
	self.inAppActive = NO;
	[self.tableView reloadData];
}

- (void)paymentQueueRestoreCompletedTransactionsFinished:(SKPaymentQueue *)queue {
	if (queue.transactions.count == 0) {
		UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", nil)
															message:NSLocalizedString(@"Sorry, but we haven't found your purchases.", nil)
														   delegate:nil
												  cancelButtonTitle:NSLocalizedString(@"Close", nil)
												  otherButtonTitles:nil];
		[alertView show];
	}
	self.inAppActive = NO;
	[self.tableView reloadData];
}

#pragma mark - NCTableViewController

- (NSString*) recordID {
	return nil;
}

#pragma mark - Private

- (void) setInAppActive:(BOOL)inAppActive {
	_inAppActive = inAppActive;
	NCDonationCell* cell = (NCDonationCell*) [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
	if (inAppActive) {
		cell.userInteractionEnabled = NO;
		[cell.activityIndicatorView startAnimating];
	}
	else {
		cell.userInteractionEnabled = YES;
		[cell.activityIndicatorView stopAnimating];
	}
}

@end
