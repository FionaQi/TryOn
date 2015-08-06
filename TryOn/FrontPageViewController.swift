//
//  FrontPageViewController.swift
//  TryOn
//
//  Created by QiFeng on 7/26/15.
//  Copyright © 2015 QiFeng. All rights reserved.
//

import UIKit
import CoreGraphics


class FrontPageViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    @IBOutlet weak var postRequestBtn: UIButton!
    var photo: UIImage!
    var imagePicker: UIImagePickerController!
    var takePhotoBtn: UIButton!
    var selectPhotoBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = ColorSpace.View.backgroundColor
        
        //take photo button
        takePhotoBtn = UIButton(frame: CGRectMake(self.view.frame.width/2 - 70, self.view.frame.height/2, 50, 50)) //TODO
        takePhotoBtn.setBackgroundImage(UIImage(named: "takephoto"), forState: UIControlState.Normal)
        takePhotoBtn.setBackgroundImage(UIImage(named:"selectphoto"), forState: UIControlState.Highlighted)
        takePhotoBtn.addTarget(self, action: "takePhotoTouchUp:", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(takePhotoBtn)
        
        //select photo button
        selectPhotoBtn = UIButton(frame: CGRectMake(self.view.frame.width/2 + 20, self.view.frame.height/2, 50, 50)) //TODO
        selectPhotoBtn.setBackgroundImage(UIImage(named:"selectphoto"), forState: UIControlState.Normal)
        selectPhotoBtn.setBackgroundImage(UIImage(named:"takephoto"), forState: UIControlState.Highlighted)
        selectPhotoBtn.addTarget(self, action: "selectPhotoTouchUp:", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(selectPhotoBtn)
        
        // Translucent nav bar
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.translucent = true
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "processPhoto") {
            let svc = segue.destinationViewController as! EditPageViewController
            svc.modalTransitionStyle = UIModalTransitionStyle.CrossDissolve
            svc.imagePassed = photo
        }
    }

    
    func takePhotoTouchUp(sender: AnyObject) {
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .Camera
        imagePicker.cameraDevice = .Front
        let cameraTransform: CGAffineTransform //= CGAffineTransformMakeScale(1.25, 1.25)
//        cameraTransform = CGAffineTransformMake(-1, 0, 0, 1, self.view.frame.size.width, 0)
//        imagePicker.cameraViewTransform = cameraTransform
        var transform:CATransform3D = CATransform3DIdentity
        transform.m34 = 1.0 / -500
        
        transform = CATransform3DRotate(transform, CGFloat( M_PI ), 0, CGFloat(1.0), 0)
        cameraTransform = CATransform3DGetAffineTransform(transform)
//        imagePicker.view.layer.transform = transform
        imagePicker.cameraViewTransform = cameraTransform
        presentViewController(imagePicker, animated: true, completion: nil) //TODO
    }
    
    @IBAction func clickSendPostRequest(sender: AnyObject) {
        let postimage = UIImage(named:"test")
        
       faceAPI.uploadImage(postimage)
    }
    func selectPhotoTouchUp(sender: AnyObject?) {
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .SavedPhotosAlbum
        presentViewController(imagePicker, animated: true, completion: nil) //TODO
        
    }
    
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        imagePicker.dismissViewControllerAnimated(true, completion: nil)
        photo = info[UIImagePickerControllerOriginalImage] as? UIImage
        performSegueWithIdentifier("processPhoto", sender: nil)
    }
}
