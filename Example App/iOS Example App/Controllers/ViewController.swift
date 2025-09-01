// The MIT License (MIT)
//
// Copyright © 2022 Ivan Izyumkin
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

import UIKit
import MCEmojiPicker

class ViewController: UIViewController {
    
    // MARK: - Private Properties
    
    private var currentTheme: MCEmojiPickerTheme = .automatic
    
    private lazy var emojiButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 12
        if #available(iOS 13.0, *) {
            button.backgroundColor = .systemGray4
            button.layer.cornerCurve = .continuous
        } else {
            button.backgroundColor = UIColor(red: 209.0, green: 209.0, blue: 214.0, alpha: 1.0)
        }
        button.setTitle("🙋🏻‍♂️", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 65)
        button.addTarget(self, action: #selector(emojiButtonAction(_:)), for: .touchUpInside)
        button.addGestureRecognizer(
            UIPanGestureRecognizer(
                target: self,
                action: #selector(didPanEmojiButton(_:))
            )
        )
        return button
    }()
    
    private lazy var themeSegmentedControl: UISegmentedControl = {
        let items = ["Auto", "Light", "Dark"]
        let control = UISegmentedControl(items: items)
        control.translatesAutoresizingMaskIntoConstraints = false
        control.selectedSegmentIndex = 0
        control.addTarget(self, action: #selector(themeChanged(_:)), for: .valueChanged)
        return control
    }()
    
    private lazy var themeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Theme:"
        label.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        label.textAlignment = .center
        return label
    }()
    
    // MARK: - Initializers
    
    init() {
        super.init(nibName: nil, bundle: nil)
        setupBackgroundColor()
        setupEmojiButtonLayout()
        if #available(iOS 13.0, *) {
            setupThemeControls()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        showHintAlertIfNeeded()
    }
    
    // MARK: - Actions
    
    @objc private func emojiButtonAction(_ sender: UIButton) {
        let viewController = MCEmojiPickerViewController()
        viewController.delegate = self
        viewController.sourceView = sender
        if #available(iOS 13.0, *) {
            viewController.theme = currentTheme
        }
        present(viewController, animated: true)
    }
    
    @objc private func themeChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            currentTheme = .automatic
        case 1:
            currentTheme = .light
        case 2:
            currentTheme = .dark
        default:
            currentTheme = .automatic
        }
    }
    
    @objc private func didPanEmojiButton(
        _ gestureRecognizer: UIPanGestureRecognizer
    ) {
        emojiButton.center = gestureRecognizer.location(in: view)
    }
    
    // MARK: - Private Methods
    
    private func showHintAlertIfNeeded() {
        let firstLaunchKey = "firstLaunch"
        guard !UserDefaults.standard.bool(forKey: firstLaunchKey) else { return }
        UserDefaults.standard.set(true, forKey: firstLaunchKey)
        let hintAlert = UIAlertController(
            title: NSLocalizedString("hintAlertTitle", comment: ""),
            message: NSLocalizedString("hintAlertMessage", comment: ""),
            preferredStyle: .alert
        )
        hintAlert.addAction(.init(title: "OK", style: .default))
        present(hintAlert, animated: true)
    }
    
    private func setupBackgroundColor() {
        if #available(iOS 13.0, *) {
            view.backgroundColor = .systemGroupedBackground
        } else {
            view.backgroundColor = .white
        }
    }
    
    private func setupEmojiButtonLayout() {
        view.addSubview(emojiButton)
        
        NSLayoutConstraint.activate([
            emojiButton.widthAnchor.constraint(equalToConstant: 88),
            emojiButton.heightAnchor.constraint(equalToConstant: 88),
            emojiButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emojiButton.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -200)
        ])
    }
    
    private func setupThemeControls() {
        view.addSubview(themeLabel)
        view.addSubview(themeSegmentedControl)
        
        NSLayoutConstraint.activate([
            themeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            themeLabel.topAnchor.constraint(equalTo: emojiButton.bottomAnchor, constant: 80),
            
            themeSegmentedControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            themeSegmentedControl.topAnchor.constraint(equalTo: themeLabel.bottomAnchor, constant: 16),
            themeSegmentedControl.leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor, constant: 20),
            themeSegmentedControl.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -20)
        ])
    }
}

// MARK: - MCEmojiPickerDelegate

extension ViewController: MCEmojiPickerDelegate {
    func didGetEmoji(emoji: String) {
        emojiButton.setTitle(emoji, for: .normal)
    }
}
