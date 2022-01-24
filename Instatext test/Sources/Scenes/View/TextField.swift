//
//  ViewController.swift
//  Instatext test
//
//  Created by 111 on 23.01.2022.
//

import UIKit

class TextField: UIViewController {

    //MARK: - Properties

    let myTextFieldView: UITextView = {
        let textView = UITextView(frame: CGRect(x: 30, y: 260, width: 375, height: 380))
        textView.textAlignment = .left
        textView.textColor = .black
        textView.backgroundColor = .white
        textView.spellCheckingType = .yes
        textView.autocorrectionType = .no
        textView.isScrollEnabled = false
        textView.layer.borderWidth = 3
        textView.layer.borderColor = UIColor.systemGray6.cgColor
        textView.font = UIFont.systemFont(ofSize: 15)

        return textView
    }()

    //MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(nitification:)), name: UIResponder.keyboardWillHideNotification, object: nil)

        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Сохранить", style: .plain, target: self, action: #selector(buttonAction))
//        checkTextField()

        view.addSubview(myTextFieldView)
        view.backgroundColor = .white
    }

    //MARK: - Actions

    @objc func checkTextField() {
        if myTextFieldView.text.isEmpty {
            navigationItem.rightBarButtonItem?.isEnabled = false
        } else {
            navigationItem.rightBarButtonItem?.isEnabled = true
        }
    }

    @objc func buttonAction() -> UIImage {

        UIGraphicsBeginImageContextWithOptions(self.myTextFieldView.bounds.size, false, 0)
        let context = UIGraphicsGetCurrentContext()
        for photoObject : AnyObject in UIApplication.shared.windows {
            if let window = photoObject as? UIWindow {
                if window.responds(to: #selector(getter: UIWindow.screen)) || window.screen == UIScreen.main {
                    context!.saveGState();
                    context!.translateBy(x: window.center.x,
                                         y: window.center.y);
                    context!.concatenate(window.transform);
                    context!.translateBy(x: -window.bounds.size.width * window.layer.anchorPoint.x,
                                         y: -window.bounds.size.height * window.layer.anchorPoint.y);
                    window.layer.render(in: context!)
                    context!.restoreGState();
                }
            }
        }

        guard let image = UIGraphicsGetImageFromCurrentImageContext() else { return UIImage() }
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)

        return image
    }

    @objc func keyboardWillShow(notification: NSNotification) {
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }

        self.view.frame.origin.y = 200 - keyboardSize.height
    }

    @objc func keyboardWillHide(nitification: NSNotification) {
        self.view.frame.origin.y = 0
    }
}
