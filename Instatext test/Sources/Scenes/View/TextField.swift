//
//  ViewController.swift
//  Instatext test
//
//  Created by 111 on 23.01.2022.
//

import UIKit

class TextFieldController: UIViewController {

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

        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Сохранить",
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(buttonAction))
        navigationItem.rightBarButtonItem?.isEnabled = false

        myTextFieldView.text = "Вставьте сюда текст или начните печатать"
        myTextFieldView.textColor = .systemGray4
        myTextFieldView.delegate = self
        Notificator()

        view.addSubview(myTextFieldView)
        view.backgroundColor = .white
    }

    //MARK: - Actions

    @objc func buttonAction() -> UIImage {

        UIGraphicsBeginImageContextWithOptions(self.myTextFieldView.bounds.size, false, 0)
        let context = UIGraphicsGetCurrentContext()
        for photoObject : AnyObject in UIApplication.shared.windows {
            if let window = photoObject as? UIWindow {
                if window.responds(to: #selector(getter: UIWindow.screen)) || window.screen == UIScreen.main {
                    context!.saveGState();
                    context!.translateBy(x: myTextFieldView.center.x,
                                         y: myTextFieldView.center.y);
                    context!.concatenate(window.transform);
                    context!.translateBy(x: (-window.bounds.size.width * 1.16) * window.layer.anchorPoint.x,
                                         y: (-window.bounds.size.height * 1.315) * window.layer.anchorPoint.y);
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

//MARK: - Extensions

extension TextFieldController: UITextViewDelegate {

    func Notificator() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow(notification:)),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide(nitification:)),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(textViewDidBeginEditing(_:)),
                                               name: UITextView.textDidBeginEditingNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(textViewDidChange(_:)),
                                               name: UITextView.textDidChangeNotification,
                                               object: nil)
    }

    func textViewDidChange(_ textView: UITextView) {
        if !myTextFieldView.text.isEmpty && myTextFieldView.text != "Вставьте сюда текст или начните печатать" {
            navigationItem.rightBarButtonItem?.isEnabled = true
        } else {
            navigationItem.rightBarButtonItem?.isEnabled = false
        }
    }

    func textViewDidBeginEditing(_ textView: UITextView) {
        if myTextFieldView.text == "Вставьте сюда текст или начните печатать" {
            myTextFieldView.text = " "
            myTextFieldView.textColor = .black
            navigationItem.rightBarButtonItem?.isEnabled = false
        } else {
            navigationItem.rightBarButtonItem?.isEnabled = true
        }
    }
}

