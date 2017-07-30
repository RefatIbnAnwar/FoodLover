//
//  Meal.swift
//  FoodLover
//
//  Created by Sium on 7/14/17.
//  Copyright © 2017 Sium. All rights reserved.
//

import Foundation
import UIKit
import os.log


class Meal: NSObject, NSCoding {
    
    //MARK: Properties
    
    struct PropertyKey {
        static let name = "name"
        static let photo = "photo"
        static let rating = "rating"
    }
    
    var name: String
    var photo: UIImage?
    var rating: Int
    
    //MARK: Archive Paths
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("Meals")
    
    init?(name: String,  photo: UIImage?, rating: Int)
    {
        /*if name.isEmpty || rating < 0{
         return nil
         */
        print("\(Meal.DocumentsDirectory)")
        guard !name.isEmpty else {
            return nil
        }
        
        self.name = name
        self.photo = photo
        self.rating = rating
    }
    
    
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: PropertyKey.name)
        aCoder.encode(photo, forKey: PropertyKey.photo)
        aCoder.encode(rating, forKey: PropertyKey.rating)
        
        
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        
        guard let name = aDecoder.decodeObject(forKey: PropertyKey.name) as? String else {
            os_log("Unable to Decode Name", log:OSLog.default, type: .debug)
            return nil
            
        }
        let photo = aDecoder.decodeObject(forKey: PropertyKey.photo) as? UIImage
        let rating = aDecoder.decodeInteger(forKey: PropertyKey.rating)
        self.init(name: name, photo: photo, rating: rating)
        
    }
    
}
