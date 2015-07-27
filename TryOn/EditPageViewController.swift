//
//  EditPageViewController.swift
//  TryOn
//
//  Created by QiFeng on 7/26/15.
//  Copyright © 2015 QiFeng. All rights reserved.
//

import UIKit

class EditPageViewController: UIViewController, UIScrollViewDelegate, UINavigationControllerDelegate {


    let filterSelectors: [GlassesType: Selector] = [
        GlassesType.Hefe: "hefeFilter:",
        GlassesType.Proces: "procesFilter:",
        GlassesType.Dawn: "dawnFilter:",
        GlassesType.Arkh: "arkhFilter:",
        GlassesType.C1975: "c1975Filter:"
    ]
    
    let filterOrder = [
        GlassesType.C1975,
        GlassesType.Arkh,
        GlassesType.Dawn,
        GlassesType.Proces,
        GlassesType.Hefe,
    ]
    
    var cancelBtn: UIButton!
    var saveBtn: UIButton!
    var imagePassed: UIImage!
    var imageView: UIImageView!
    var scrollView: UIScrollView!
    var toolbar: UIToolbar!
    var filters: [UIBarButtonItem] = []
    var selectedFilter: UIButton!
    
    var savedFloatingView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.layer.backgroundColor = UIColor.yellowColor().CGColor
        //image view
        scrollView = UIScrollView(frame: CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height))
        self.view.addSubview(scrollView)
        
        imageView = UIImageView(image: imagePassed)
        self.automaticallyAdjustsScrollViewInsets = false;
        self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height);
        scrollView.delegate = self
        scrollView.addSubview(imageView)
        
        imageView.contentMode = UIViewContentMode.ScaleAspectFill
        imageView.userInteractionEnabled = false
        
        scrollView.contentSize = imagePassed.size
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
        
        //button
//        cancelBtn = UIButton(frame: CGRect(x:10, y:22, width:42, height:42))
//        cancelBtn.setBackgroundImage(UIImage(named:"cross"), forState: UIControlState.Normal)
//        cancelBtn.addTarget(self, action:"CancelBtnTouchUp:", forControlEvents:UIControlEvents.TouchUpInside)
//        self.view.addSubview(cancelBtn)
        saveBtn = UIButton(frame: CGRect(x:self.view.frame.width - 52, y:52, width:42, height:42))
        saveBtn.setBackgroundImage(UIImage(named:"check"), forState: UIControlState.Normal)
        saveBtn.setBackgroundImage(UIImage(named:"cross"), forState: UIControlState.Highlighted)
        saveBtn.addTarget(self, action:"SaveBtnTouchUp:", forControlEvents:UIControlEvents.TouchUpInside)
        self.view.addSubview(saveBtn)
        
        // nav bar
        let backBtnImg = UIImage(named:"cross")?.resizableImageWithCapInsets(UIEdgeInsetsMake(0, 0, 0, 0))
        UIBarButtonItem.appearance().setBackButtonBackgroundImage(backBtnImg, forState: UIControlState.Normal, barMetrics: UIBarMetrics.Default)
        self.navigationController?.navigationBar.backItem?.title = ""
        
        //bottom tool bar
        var toolbarItems: [UIBarButtonItem] = []
        for glassType in filterOrder {
            let filterBtn = BottomToolbarHelper.filterBtn(glassType, parentView: self, handler: filterSelectors[glassType]!)
            toolbarItems.append(filterBtn)
        }
        
        // Build scrollable bottom toolbar
        toolbar = ScrollableBottomToolbar.insertScrollableBottomToolbar(self, btnArray: toolbarItems)
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
         UIImageWriteToSavedPhotosAlbum(self.imagePassed, nil, nil, nil)
         SavedViewHelper.addFloatingView(self)
    }


}
