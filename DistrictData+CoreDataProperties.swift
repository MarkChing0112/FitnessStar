//
//  DistrictData+CoreDataProperties.swift
//  FypTest_APP
//
//  Created by Isaac Lee on 28/4/2022.
//
//

import Foundation
import CoreData


extension DistrictData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DistrictData> {
        return NSFetchRequest<DistrictData>(entityName: "DistrictData")
    }

    @NSManaged public var district: String?

}

extension DistrictData : Identifiable {

}
