//
//  NCFittingShipMiscCell.h
//  Neocom
//
//  Created by Артем Шиманский on 30.01.14.
//  Copyright (c) 2014 Artem Shimanski. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NCFittingShipMiscCell : UITableViewCell
@property (nonatomic, weak) IBOutlet UILabel *targetsLabel;
@property (nonatomic, weak) IBOutlet UILabel *targetRangeLabel;
@property (nonatomic, weak) IBOutlet UILabel *scanResLabel;
@property (nonatomic, weak) IBOutlet UILabel *sensorStrLabel;
@property (nonatomic, weak) IBOutlet UILabel *speedLabel;
@property (nonatomic, weak) IBOutlet UILabel *alignTimeLabel;
@property (nonatomic, weak) IBOutlet UILabel *signatureLabel;
@property (nonatomic, weak) IBOutlet UILabel *cargoLabel;
@property (nonatomic, weak) IBOutlet UIImageView *sensorImageView;
@property (nonatomic, weak) IBOutlet UILabel *droneRangeLabel;
@property (nonatomic, weak) IBOutlet UILabel *warpSpeedLabel;

@end
