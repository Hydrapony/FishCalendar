//
//  Iconimg+CoreDataProperties.h
//  FishCalendar
//
//  Created by Hydra on 17/2/25.
//  Copyright © 2017年 Hydra. All rights reserved.
//

#import "Iconimg+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Iconimg (CoreDataProperties)

+ (NSFetchRequest<Iconimg *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *imgname;

@end

NS_ASSUME_NONNULL_END
