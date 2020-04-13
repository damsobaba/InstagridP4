//
//  ViewController.swift
//  InstagrigP4
//
//  Created by Adam Mabrouki on 16/03/2020.
//  Copyright © 2020 Adam Mabrouki. All rights reserved.
//

import UIKit

final class ViewController: UIViewController {
    
    // MARK: - propreties
    
    private var buttonTag: Int = 0 // to identify senders
    private let imagePickerController = UIImagePickerController()
    private var swipeGestureRecogniser: UISwipeGestureRecognizer?
    
    // MARK: - view life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePickerController.delegate = self
        imagePickerController.sourceType = .photoLibrary 
        shadowOnMainView(view: mainView)
        
        swipeGestureRecogniser = UISwipeGestureRecognizer(target: self, action: #selector(swipeAction))
        guard let swipeGestureRecogniser = swipeGestureRecogniser else { return }
        mainView.addGestureRecognizer(swipeGestureRecogniser)
        
        NotificationCenter.default.addObserver(self, selector: #selector(swipeDirectionHandler), name: UIDevice.orientationDidChangeNotification, object: nil) // notify witch orientation the phone is to change the direction
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    
    // MARK: - outlets
    
    @IBOutlet private weak var mainView: UIView!
    @IBOutlet private var plusButtons: [UIButton]!
    @IBOutlet private weak var topRightPlusButton: UIButton!
    @IBOutlet private weak var buttomRightPlusButton: UIButton!
    @IBOutlet private weak var leftLayoutButton: UIButton!
    @IBOutlet private weak var middleLayoutButton: UIButton!
    @IBOutlet private weak var rightLayoutButton: UIButton!
    @IBOutlet private weak var swipeLabel: UIStackView!
    
    
    
    
    
    // MARK: - actions
    
    @IBAction private func layoutButtonTapped(_ sender: UIButton) {
        [leftLayoutButton, middleLayoutButton, rightLayoutButton].forEach { $0?.isSelected = false }
        sender.isSelected = true // tell witch layout is selected
        switch sender.tag {
        case 0:
            topRightPlusButton.isHidden = true // hide the button of main view depending of layout
            buttomRightPlusButton.isHidden = false
        case 1:
            topRightPlusButton.isHidden = false
            buttomRightPlusButton.isHidden = true
        case 2:
            topRightPlusButton.isHidden = false
            buttomRightPlusButton.isHidden = false
        default:
            break
        }
    }
    
    
    @IBAction private func plusButtonTapped(_ sender: UIButton) {
        buttonTag = sender.tag
        present(imagePickerController, animated: true) // present the photo librairy when plus button is tapped
        
    }
    
    // MARK: - methods
    
    private func shadowOnMainView(view: UIView){    //  shadow for the main View
        mainView.layer.shadowColor = UIColor.black.cgColor
        mainView.layer.shadowOpacity = 3
        mainView.layer.shadowOffset = CGSize.zero
        mainView.layer.shadowRadius = 3
    }
    
    private func shareAction() { // enable to share the mainview
        let activityControiler = UIActivityViewController(activityItems: [mainView.asImage], applicationActivities: [])
        present(activityControiler, animated: true) // present the share options
        activityControiler.completionWithItemsHandler = { _, _, _, _ in
            UIView.animate(withDuration: 0.5, animations: {
                self.mainView.transform = CGAffineTransform.identity //
                self.swipeLabel.transform = CGAffineTransform.identity
            })
        }
    }
    
    /// animation when swiping
    @objc
    private func swipeAction() {
        print("swipe action")
        
        if UIDevice.current.orientation == .landscapeLeft || UIDevice.current.orientation == .landscapeRight {
            UIView.animate(withDuration: 0.5) {
                self.mainView.transform = CGAffineTransform(translationX: -self.view.frame.width, y: 0)
                self.swipeLabel.transform = CGAffineTransform(translationX: -self.view.frame.width, y: 0)
            }
        }else{
            UIView.animate(withDuration: 0.5) {
                self.mainView.transform = CGAffineTransform(translationX: 0, y: -self.view.frame.height)
                self.swipeLabel.transform = CGAffineTransform(translationX: 0, y: -self.view.frame.height)
            }
        }
        
        shareAction()
    }
    
    /// tell witch direction the swipe is
    @objc
    func swipeDirectionHandler() {
        if UIDevice.current.orientation == .landscapeLeft || UIDevice.current.orientation == .landscapeRight {
            swipeGestureRecogniser?.direction = .left
        }else {
            swipeGestureRecogniser?.direction = .up
        }
    }
}

// MARK: - imagePickerController

/// enable to acces the photo library
extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }// select image
        plusButtons[buttonTag].setImage(image, for: .normal) // the image selected goes on the plus button press
        picker.dismiss(animated: true , completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil) // when cancel accecing the photo librairy
    }
}

























