//
//  ViewController.swift
//  CKEditorExample
//
//  Created by Tobias Oho on 20.10.16.
//  Copyright © 2016 Tobias Oho. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var webView: UIWebView!
    
    let contentToEdit = "<div style='size:16px;'>change me!</div>"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let path = NSBundle.mainBundle().pathForResource("ckeditor/editor", ofType: "html")
        
        webView.keyboardDisplayRequiresUserAction = false
        webView.scrollView.scrollEnabled = false
        webView.scrollView.bounces = false
        
        
        var fileHtml = try! NSString(contentsOfFile: path!, encoding: NSUTF8StringEncoding)
        
        //if there is text to edit
        fileHtml = fileHtml.stringByReplacingOccurrencesOfString("<!--#CONTENT-->", withString: contentToEdit)
        
        webView.loadHTMLString(fileHtml as String, baseURL: NSURL.fileURLWithPath(path!))
        
        // NSNotificationCenter
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewController.resizeEditorHeight), name:UIKeyboardWillShowNotification, object: nil);
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewController.resizeEditorHeight), name:UIKeyboardWillHideNotification, object: nil);
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewController.resizeEditorHeight), name: UIDeviceOrientationDidChangeNotification, object: nil)
    }
    
    func getEditorContent() -> String {
        return self.webView.stringByEvaluatingJavaScriptFromString("CKEDITOR.instances.editor1.getData();")!
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.webView.stringByEvaluatingJavaScriptFromString("document.getElementsByClassName('cke_wysiwyg_div')[0].focus();")
    }

    func resizeEditorHeight() {
        self.webView.stringByEvaluatingJavaScriptFromString("CKEDITOR.instances.editor1.resize( '100%', window.innerHeight);")
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            return UIInterfaceOrientationMask.Portrait
        }
        else {
            return UIInterfaceOrientationMask.All
        }
    }
}

