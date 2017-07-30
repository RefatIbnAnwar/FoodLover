//
//  ViewController.swift
//  FoodLover
//
//  Created by Sium on 7/12/17.
//  Copyright © 2017 Sium. All rights reserved.
//

import UIKit
import os.log // this import unified logging system

class MealViewController: UIViewController{

    //Mark: Property
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var ratingControl: RatingControl!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    //this value is either passed by 'MealTableViewController' in prepare(for: segue:)
    //or contructed as part of adding a new meal
    
    var meal: Meal?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up view if editing an existing meal
        
        if let meal = meal {
            navigationItem.title = meal.name
            nameTextField.text = meal.name
            ratingControl.rating = meal.rating
            photoImageView.image = meal.photo
        }
        
        // Enable the save button only if the text field has a valid meal name
        updateSaveButtonStates()
        
        
        

    }
    
    //Mark: Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        //Configure the destination view controller only when the save button is pressed
        guard let button = sender as? UIBarButtonItem, button === saveButton else {
            os_log("the save button was not pressed, cancelling", log: OSLog.default, type: .debug)
            return
        }
        
        let name = nameTextField.text ?? ""
        let photo = photoImageView.image
        let rating = ratingControl.rating
        
        //set the meal to be passed to MealTableViewController after the unwind segue
        meal = Meal(name: name, photo: photo, rating: rating)
    }
    
    //Mark: Actions
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        //depending on style of presentation (modal or push presentation) , this view controller needs to be dismissed in two different ways
        
        let isPresentingInAddMealMode = presentingViewController is UINavigationController
        
        if isPresentingInAddMealMode {
            dismiss(animated: true, completion: nil)
        }
        else if let owningNavigationController = navigationController{
            owningNavigationController.popViewController(animated: true)
        }
        
        else{
            fatalError("The mealViewController is not inside a navigation controller")
        }
        
}
    
    
    @IBAction func selectImageFromPhotoLibrary(_ sender: Any) {
        
        //Hide the keyboard
        nameTextField.resignFirstResponder()
        //UIImagePickerController is view controller that lets a user pick media from their photo library
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = .photoLibrary
        // to make sure viewcontroller is notified when the user picks an image
        imagePickerController.delegate = self
        present(imagePickerController, animated: true , completion: nil)
        
    }
   
    //Mark: methods
    func updateSaveButtonStates()  {
        // Disable the Save button if the text field is empty
        let text = nameTextField.text ?? ""
        saveButton.isEnabled = !text.isEmpty
    }
    
    
}

// UItextFieldDelegate implementation

extension MealViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //Hide the keyboard
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        updateSaveButtonStates()
        navigationItem.title = textField.text
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        //Disable the save button while editing
        saveButton.isEnabled = false
    }
    
    
    
}

// UIImagePickerControllerDelegate, UINavigationControllerDelegate implementation

extension MealViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        //dismiss the picker if the user canceled
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        //the info dictionary may contain multiple representation of the image. I want to use the original
        
        guard let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        // set the photo image to display the selected image
        photoImageView.image = selectedImage
        
        //dismiss the picker
        dismiss(animated: true, completion: nil)
    }
}

