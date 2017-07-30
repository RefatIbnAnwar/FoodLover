//
//  RatingControl.swift
//  FoodLover
//
//  Created by Sium on 7/13/17.
//  Copyright © 2017 Sium. All rights reserved.
//

import UIKit

@IBDesignable class RatingControl: UIStackView {
    
    //MARK: Properties
    
    private var ratingButtons = [UIButton]()
    
    var rating = 0 {
        didSet{
            updateButttonSelectedStates()
        }
    }
    
    @IBInspectable var starSize: CGSize = CGSize(width: 44.0, height: 44.0){
        didSet {
            setupButtons()
        }
    }
    @IBInspectable var starCount: Int = 5 {
        didSet {
            setupButtons()
        }
    }

    //MARK: Iitialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButtons()
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        setupButtons()
    }
    
    //MARK: Private methods
    
    private func setupButtons(){
        
        //clear any existing button
        for button in ratingButtons {
            removeArrangedSubview(button)
            button.removeFromSuperview()
        }
        ratingButtons.removeAll()
        
        //load button images
        
        let bundle = Bundle(for: type(of: self))
        
        let filledStar = UIImage(named: "filledStar", in: bundle, compatibleWith: self.traitCollection)
        let emptyStar = UIImage(named: "emptyStar", in: bundle, compatibleWith: self.traitCollection)
        let highlightedStar = UIImage(named: "highlightedStar", in: bundle, compatibleWith: self.traitCollection)
        
        
        
        for index in 0..<starCount {
            
            //create a button
            let button = UIButton()
            
            //set the button image
            button.setImage(emptyStar, for: .normal)
            button.setImage(filledStar, for: .selected)
            button.setImage(highlightedStar, for: .highlighted)
            button.setImage(highlightedStar, for: [.highlighted,.selected])
            
            //add constraints programmitacally
            button.translatesAutoresizingMaskIntoConstraints = false
            button.heightAnchor.constraint(equalToConstant: starSize.height).isActive = true
            button.widthAnchor.constraint(equalToConstant: starSize.width).isActive = true
            
            //set accessibility label
            button.accessibilityLabel = "Set \(1 + index) star rating"
            
            //Setup the button action
            button.addTarget(self, action: #selector(RatingControl.ratingButtonTaped(button:)), for: .touchUpInside)
            
            //add the buttons to the stack
            addArrangedSubview(button)
            
            //add the new button to the rating button array 
            ratingButtons.append(button)
            

        }
        
        updateButttonSelectedStates()
    }
    
    private func updateButttonSelectedStates()  {
        for (index, button) in ratingButtons.enumerated() {
            //if the index of a button is less than the rating , that button should be selected
            button.isSelected = index < rating
            
            //set the hint string for the currently selected star
            let hintString: String?
            if rating == index + 1 {
                hintString = "Tap to reset the rating to zero"
            } else {
                hintString = nil
            }
            
            //calculate the value string
            let valueString: String
            switch (rating) {
            case 0:
                valueString = "No rating set"
            case 1:
                valueString = "1 star set"
            default:
                valueString = "\(rating) stars set"
            }
            
            //assign the hint String and value string
            
            button.accessibilityHint = hintString
            button.accessibilityValue = valueString
            
            
        }
    }
    
    //MARK:  Button Action
    
    func ratingButtonTaped(button: UIButton) {
        guard let index = ratingButtons.index(of: button) else {
            fatalError("the button , \(button),  is not in the rating array: \(ratingButtons)")
        }
        
        //calculating the rating of the selected button
        
        let selectedRating = index + 1
        
        if selectedRating == rating {
            rating = 0 // if the selected star represent the current rating , reset the rating to 0
        }
        else{
            //otherwise set the value to the selected star
            
            rating = selectedRating
        }
    }
    
    

}
