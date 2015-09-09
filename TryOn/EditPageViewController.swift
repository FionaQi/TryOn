//
//  EditPageViewController.swift
//  TryOn
//
//  Created by QiFeng on 7/26/15.
//  Copyright © 2015 QiFeng. All rights reserved.
//

import UIKit


class EditPageViewController: UIViewController, UIScrollViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    var imagePicker: UIImagePickerController!
    var takePhotoBtn: UIButton!
    var selectPhotoBtn: UIButton!
    var savedImgView: UIImageView!
    var savedLabel: UILabel!
    
    let filterOrder = [
        GlassesType.round,
        GlassesType.Oval,
        GlassesType.Wayfares,
        GlassesType.Nerd,
        GlassesType.Geek,
        GlassesType.Fly,
        GlassesType.Grandpa,
        GlassesType.Hanjian,
        GlassesType.Cateye,
        GlassesType.Thick
    ]
    
    var cancelBtn: UIButton!
    var saveBtn: UIButton!
    var CurrentPhoto: UIImage!
    var imageView: UIImageView!
    var scrollView: UIScrollView!
    var toolbar: UIToolbar!
    var filters: [UIBarButtonItem] = []
    var selectedFilter: UIButton!

    //glass thing
    var fgimageView: UIImageView!
    var glassRect: CGRect!
    var landmarks: faceLandmarks!
    
    
    var spin:UIActivityIndicatorView!
    var savedFloatingView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.layer.backgroundColor = UIColor.grayColor().CGColor
        loadImageScrollView()
        loadButtons()
        loadBottomToolbar()
        initDefaultLandmarks()
    }
    
    func loadImageScrollView() {
        //image view
        scrollView = UIScrollView(frame: CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height))
        self.view.addSubview(scrollView)
        let defaultimg = UIImage(named: "default_image.jpg")!
        imageView = UIImageView(image: defaultimg)
        
        self.automaticallyAdjustsScrollViewInsets = false;
        self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height);
        scrollView.delegate = self
        scrollView.addSubview(imageView)
        
        imageView.contentMode = UIViewContentMode.ScaleAspectFill
        imageView.userInteractionEnabled = false
        
        scrollView.contentSize = defaultimg.size
        scrollView.contentMode = UIViewContentMode.ScaleAspectFill
        let scrollViewFrame = scrollView.frame
        let scaleWidth = scrollViewFrame.size.width / scrollView.contentSize.width
        let scaleHeight = scrollViewFrame.size.height / scrollView.contentSize.height
        let minScale = min(scaleHeight, scaleWidth)
        
        scrollView.minimumZoomScale = minScale
        scrollView.maximumZoomScale = 4
        scrollView.zoomScale = minScale
        scrollView.bounds = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)
        scrollView.decelerationRate = 0
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
    }
    
    func createButton( btnImg: UIImage, action: Selector, posX: CGFloat ) -> UIButton {
        let curButton: UIButton = UIButton(frame: CGRectMake(posX, 22, 45, 45))
        curButton.imageEdgeInsets = UIEdgeInsetsMake(12.0 , 12.0, 12.0 , 12.0)
        curButton.setImage(btnImg, forState:  UIControlState.Normal)
        curButton.layer.cornerRadius = curButton.frame.size.width/2
        curButton.backgroundColor = UIColor.whiteColor()

        
        curButton.addTarget(self, action: action, forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(curButton)
        return curButton
    }
    
    func loadButtons() {
        self.navigationController?.navigationBarHidden = true
        let gap = (self.view.frame.width - 24 - 45) / 3
        cancelBtn = createButton(UIImage(named:"cross")!, action: "CancelBtnTouchUp:", posX: 12)
        takePhotoBtn = createButton(UIImage(named:"takephoto")!, action: "takePhotoTouchUp:", posX: 12 + gap)
        selectPhotoBtn = createButton(UIImage(named:"selectphoto")!, action: "selectPhotoTouchUp:", posX: 12 + gap * 2)
        saveBtn = createButton(UIImage(named:"check")!, action: "SaveBtnTouchUp:", posX:  12 + gap * 3)
        
        cancelBtn.hidden = true
        saveBtn.hidden = true
    }
    func loadBottomToolbar() {
        var toolbarItems: [UIBarButtonItem] = []
        for glassType in filterOrder {
            let filterBtn = BottomToolbarHelper.filterBtn(glassType, parentView: self, handler: "glassItemClicked:")
            toolbarItems.append(filterBtn)
        }
        
        let beautyButton = BottomToolbarHelper.setBtnImgNatual(ImgLib.FiltersPhoto._Dawn!, parentView: self, handler: "beautyTab:")
        self.selectedFilter = beautyButton
        // Build scrollable bottom toolbar
        toolbar = ScrollableBottomToolbar.insertScrollableBottomToolbar(self, btnArray: toolbarItems)
    }
    func loadAnimation() {
        animBackground.addFloatingView(self)
        let animationLoader = FeHandwriting(view: self.view)
        self.view.addSubview(animationLoader)
        animationLoader.showWhileExecutingBlock({
            sleep(6)
            }, completion: {
                animationLoader.hidden = true
                animBackground.removeFloatingView(self)
        })
    }
    func calculateFace() {
        if( fgimageView !== nil ) {
            self.fgimageView.removeFromSuperview()
        }
        
        let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
        dispatch_async(dispatch_get_global_queue(priority, 0)) {
            self.landmarks = faceAPI.uploadImage(self.CurrentPhoto)
            self.glassRect = CGRectMake(50, 50,  100, 30)
            self.fgimageView = UIImageView(frame: CGRectMake(self.glassRect.origin.x, self.glassRect.origin.y, self.glassRect.width, self.glassRect.height))
            self.view.addSubview(self.fgimageView)
            dispatch_async(dispatch_get_main_queue()) {
                self.cancelBtn.hidden = false
                self.saveBtn.hidden = false
            }
        }
    }
    override func viewWillAppear(animated: Bool) {
        centerScrollViewContents()
    }
/* ***************
    scroll view helper
***************** */
    func centerScrollViewContents() {
        let boundsSize = scrollView.bounds.size
        var contentsFrame = imageView.frame
        
        if contentsFrame.size.width < boundsSize.width {
            contentsFrame.origin.x = (boundsSize.width - contentsFrame.size.width) / 2.0
        } else {
            contentsFrame.origin.x = 0.0
        }
        
        if contentsFrame.size.height < boundsSize.height {
            contentsFrame.origin.y = (boundsSize.height - contentsFrame.size.height) / 2.0
        } else {
            contentsFrame.origin.y = 0.0
        }
        
        imageView.frame = contentsFrame
    }
    
    func scrollViewDidZoom(scrollView: UIScrollView) {
        centerScrollViewContents()
    }
    
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

/* *************
    button click action
************* */
    func SaveBtnTouchUp(sender: AnyObject) {
         UIImageWriteToSavedPhotosAlbum(self.CurrentPhoto, nil, nil, nil)
         SavedViewHelper.addFloatingView(self)
        let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
        dispatch_async(dispatch_get_global_queue(priority, 0)) {
            sleep(2)
            dispatch_async(dispatch_get_main_queue()) {
                SavedViewHelper.removeFloatingView(self)
            }
        }
    }
    
    func CancelBtnTouchUp(sender: AnyObject) {
        self.cancelBtn.hidden = true
        self.saveBtn.hidden = true
    }
    
    
    func glassItemClicked(sender: UIButton) {
        if (!tabChangeOn(selectedFilter, newFilter: sender)) {
            return
        }
        selectedFilter = sender
        
        var bgimage : UIImage!
        let currentChoose = sender.currentTitle
        switch currentChoose {
        case GlassesType.round.simpleDesp() as String:
            bgimage = ImgLib.FiltersPhoto.round!
            break
        case GlassesType.Oval.simpleDesp() as String:
            bgimage = ImgLib.FiltersPhoto.Oval!
            break
        case GlassesType.Wayfares.simpleDesp() as String:
            bgimage = ImgLib.FiltersPhoto.Wayfares!
            break
        case GlassesType.Cateye.simpleDesp() as String:
            bgimage = ImgLib.FiltersPhoto.Cateye!
            break
        case GlassesType.Thick.simpleDesp() as String:
            bgimage = ImgLib.FiltersPhoto.Thick!
            break
        case GlassesType.Nerd.simpleDesp() as String:
            bgimage = ImgLib.FiltersPhoto.Nerd!
            break
        case GlassesType.Geek.simpleDesp() as String:
            bgimage = ImgLib.FiltersPhoto.Geek!
            break
        case GlassesType.Fly.simpleDesp() as String:
            bgimage = ImgLib.FiltersPhoto.Fly!
            break
        case GlassesType.Grandpa.simpleDesp() as String:
            bgimage = ImgLib.FiltersPhoto.Grandpa!
            break
        case GlassesType.Hanjian.simpleDesp() as String:
            bgimage = ImgLib.FiltersPhoto.Hanjian!
            break
        default:
            break
        }
        
        transformClickedGlass(bgimage)
        
    }
        
    func tabChangeOn(oldFilter: UIButton, newFilter: UIButton) -> Bool{
        if (oldFilter == newFilter) {
            return false
        }
        oldFilter.layer.backgroundColor = UIColor.clearColor().CGColor
        newFilter.layer.backgroundColor = ColorSpace.View.BarItemHighlightedBgColor.CGColor
        if( fgimageView !== nil ) {
            fgimageView.removeFromSuperview()
        }
        return true
    }
    
    func getAbsWidth(inputW: CGFloat) -> CGFloat {
        var imageWidth: CGFloat!
        if( self.CurrentPhoto == nil ) {
            imageWidth = 750.0
        } else {
            imageWidth = self.CurrentPhoto.size.width
        }
        return CGFloat(inputW) / imageWidth * 375.0
    }
    
    func getAbsHeight(inputH: CGFloat) -> CGFloat {
        var imageWidth: CGFloat!
        if( self.CurrentPhoto == nil ) {
            imageWidth = 750.0
        } else {
            imageWidth = self.CurrentPhoto.size.width
        }
        return CGFloat(inputH) / imageWidth * 375.0 + imageView.frame.origin.y
    }
    
    func transformClickedGlass(bgimage: UIImage) {
        //caculate rect
        let deltaX = self.getAbsWidth(self.landmarks.rightEyeOuter.x - self.landmarks.leftEyeOuter.x)
        let deltaY = self.getAbsHeight(self.landmarks.rightEyeOuter.y - self.landmarks.leftEyeOuter.y)
        let glassWidth :CGFloat = 1.3 * sqrt( deltaX * deltaX + deltaY * deltaY )
        let glassHeight: CGFloat = ( glassWidth / bgimage.size.width ) * bgimage.size.height
        NSLog("width = %f, height = %f", glassWidth, glassHeight)
       
        self.fgimageView = UIImageView(frame: CGRectMake(0, 0, glassWidth, glassHeight))
        let eye_centerX = self.getAbsWidth( ( landmarks.leftEyeOuter.x + landmarks.rightEyeOuter.x ) / 2 )
        let eye_centerY = self.getAbsHeight( ( landmarks.leftEyeOuter.y + landmarks.rightEyeOuter.y ) / 2 )
        self.fgimageView.center = CGPointMake(eye_centerX, eye_centerY)
        self.ThreeDtransform(bgimage, landmarks:self.landmarks, glassImageViewCenter: self.fgimageView.center)
        self.view.addSubview(self.fgimageView)
    }
    
    func ThreeDtransform(fgImage: UIImage, landmarks: faceLandmarks, glassImageViewCenter: CGPoint) {
        fgimageView.image = fgImage
        var transform:CATransform3D = CATransform3DIdentity
        transform.m34 = 1.0 / -500
        let pitch:CGFloat = landmarks.pitch
        let roll =  landmarks.roll
        let yaw = landmarks.yaw
        
        //translate
        let eye_centerX = self.getAbsWidth( ( landmarks.leftEyeOuter.x + landmarks.rightEyeOuter.x ) / 2 )
        let eye_centerY = self.getAbsHeight( ( landmarks.leftEyeOuter.y + landmarks.rightEyeOuter.y ) / 2 )
        let glass_originCenterX = glassImageViewCenter.x
        let glass_originCenterY = glassImageViewCenter.y
        NSLog("eye center: %f", eye_centerX)
        NSLog("glass center: %f , %f", glass_originCenterX, glass_originCenterY)
        transform = CATransform3DRotate(transform, CGFloat(Double(yaw) * M_PI / 180.0), 0, 1, 0)
        transform = CATransform3DRotate(transform, CGFloat(Double(pitch) * M_PI / 180.0), 1, 0, CGFloat(0.0))
        transform = CATransform3DRotate(transform, CGFloat(Double(roll) * M_PI / 180.0), 0, 0, CGFloat(1.0))
        transform = CATransform3DTranslate(transform, eye_centerX - glass_originCenterX  , eye_centerY - glass_originCenterY , 0.0 )

        transform = CATransform3DTranslate(transform, 0.0  , 0.0 , CGFloat(50) )
        fgimageView.layer.transform = transform
    }
    
    //************image picker************/
    func takePhotoTouchUp(sender: AnyObject) {
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .Camera
        imagePicker.cameraDevice = .Front
        let cameraTransform: CGAffineTransform //= CGAffineTransformMakeScale(1.25, 1.25)
        var transform:CATransform3D = CATransform3DIdentity
        transform.m34 = 1.0 / -500
        transform = CATransform3DRotate(transform, CGFloat( M_PI ), 0, CGFloat(1.0), 0)
        cameraTransform = CATransform3DGetAffineTransform(transform)
        imagePicker.cameraViewTransform = cameraTransform
        presentViewController(imagePicker, animated: true, completion: nil) //TODO
    }
    func selectPhotoTouchUp(sender: AnyObject?) {
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .SavedPhotosAlbum
        presentViewController(imagePicker, animated: true, completion: nil) //TODO
        
    }
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        imagePicker.dismissViewControllerAnimated(true, completion: nil)
        CurrentPhoto = info[UIImagePickerControllerOriginalImage] as? UIImage
      //  performSegueWithIdentifier("processPhoto", sender: nil)
        imageView.image = CurrentPhoto
        loadAnimation()
        calculateFace()
    }
    
    func initDefaultLandmarks() {
        self.landmarks = faceLandmarks()
        landmarks.initfaceLandmarks()
        self.landmarks.roll = -13.3
        self.landmarks.pitch = 0.0
        self.landmarks.yaw = -12.6
        self.landmarks.leftEyeOuter = CGPointMake(219, 427)
        self.landmarks.rightEyeOuter = CGPointMake(490, 335)
    }
}
