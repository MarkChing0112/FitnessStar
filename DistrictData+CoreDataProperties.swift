//
//  DistrictData+CoreDataProperties.swift
//  FypTest_APP

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
