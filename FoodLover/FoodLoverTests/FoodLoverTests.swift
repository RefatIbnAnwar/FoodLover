//
//  FoodLoverTests.swift
//  FoodLoverTests
//
//  Created by Sium on 7/12/17.
//  Copyright © 2017 Sium. All rights reserved.
//

import XCTest
@testable import FoodLover

class FoodLoverTests: XCTestCase {
    
    //MARK: Meal class test
    
    // Confirm that the Meal initializer returns a Meal object when passed valid parameters.
    func testMealInitializationSucceeds() {
        
        //zero rating
        let zeroRatingMeal = Meal.init(name: "zero", photo: nil, rating: 0)
        XCTAssertNotNil(zeroRatingMeal)
        
        //Highest positive rating
        let positiveRatingMeal = Meal.init(name: "Positive", photo: nil, rating: 5)
        XCTAssertNotNil(positiveRatingMeal)
    }
    
    //Confirms that the meal initializer returms nil when passed a negative rating.
    func testMealInitializationfails()  {
        
        //Nmagetive rating
        let nagativeRatingMeal = Meal.init(name: "Negative", photo: nil, rating: -1)
        XCTAssertNil(nagativeRatingMeal)
        
        //Rating exceeds maximum
        let largeRatingMeal = Meal.init(name: "Large", photo: nil, rating: 6)
        XCTAssertNil(largeRatingMeal)
        
        //Empty String
        let emptyStringMeal = Meal.init(name: "", photo: nil, rating: 1)
        XCTAssertNil(emptyStringMeal)
    }
    
}
