//
//  IndicatorViewAppearence.swift
//  Budget Tracker
//
//  Created by Mikhailo Dovhyi on 31.03.2022.
//  Copyright © 2022 Misha Dovhiy. All rights reserved.
//

import UIKit


extension AlertViewLibrary {
    func setBacground(higlight:Bool, ai:Bool) {
        
        DispatchQueue.main.async {
            let higlighten = {
                UIView.animate(withDuration: 0.3) {
                    self.backgroundView.backgroundColor = ai ? self.appearence.colors.normal.background : self.appearence.colors.accent.background
                }
            }
            if higlight {
                UIView.animate(withDuration: 0.3) {
                    self.mainView.layer.shadowOpacity = 0.9
                    self.titleLabel.font = .systemFont(ofSize: 32, weight: .bold)
                    self.backgroundView.backgroundColor = self.appearence.colors.accent.higlight
                } completion: { _ in
                    higlighten()
                }
            } else {
                higlighten()
            }
            
        }
    }
    
    enum ImagePosition:Int {
        case left = 0
        case middle = 1
    }
    
    func setImage(hidden:Bool, isImage:ImagePosition?, imageName:String?) {
        let imgs:[Any] = [imageView!, (imageView.superview ?? UIView()), middleImageView!, middleImageSuperview ?? UIView()]
        imgs.forEach { object in
            let selectedTag = isImage?.rawValue ?? -1
            if let image = object as? UIImageView {
                image.isHidden = image.tag == selectedTag ? hidden : true
                if let imageName = imageName,
                   let sel = isImage
                {
                    image.image = sel.rawValue == image.tag ? .init(named: imageName) : nil
                }
            } else if let view = object as? UIView {
                view.isHidden = view.tag == selectedTag ? hidden : true
            }

        }

    }
    
    
    func setLabel(normal:String? = nil,
                  attributed:NSMutableAttributedString? = nil,
                  aligment:NSTextAlignment,
                  label:UILabel,
                  color:UIColor
                  
    ) {
        
        label.textColor = color
        let hideLabel = normal == nil && attributed == nil
        label.textAlignment = aligment
        if label.isHidden != hideLabel {
            label.isHidden = hideLabel
        }
        if !hideLabel {
            if let text = normal {
                label.text = text
            }
            if let attr = attributed {
                label.attributedText = attr
            }
        }
    }
    
    struct AlertStyle {
        var type:ViewType = .standard
        var textAligment:NSTextAlignment = .center
        var imgPosition:ImagePosition = .left
        var needCoints:String? = nil
    }
    
    
    func setTitleSize(_ type:ViewType) {
        switch type {
        case .error, .succsess, .internetError:
            self.titleLabel.font = .systemFont(ofSize: 24, weight: .semibold)
        case .standard, .standardError, .ai:
            self.titleLabel.font = normalTitleSize
        }
    }
    
    func buttonStyle(_ button:UIButton, type:Button) {
        DispatchQueue.main.async {
            button.setTitleColor(self.buttonToColor(type.style), for: .normal)
            button.setTitle(type.title, for: .normal)
            button.backgroundColor = self.buttonBackground(type.style)
            button.titleLabel?.font = self.buttonToFont(type.style)
            if button.isHidden != false {
                button.isHidden = false
            }
            if button.superview?.isHidden != false {
                button.superview?.isHidden = false
            }
        }
    }
    
    private func buttonToFont(_ type:ButtonType) -> UIFont {
        switch type {
        case .error, .link, .regular: return .systemFont(ofSize: 15, weight: .medium)
        case .linkBackground, .grey: return .systemFont(ofSize: 16, weight: .bold)
        }
    }
    
    private func buttonToColor(_ type:ButtonType) -> UIColor {
        switch type {
        case .error: return .red
        case .link: return appearence.colors.buttom.link
        case .regular: return appearence.colors.buttom.normal
        case.grey: return .gray//K.Colors.Text.grey
        case .linkBackground: return .white//K.Colors.Text.white
        }
    }
    
    private func buttonBackground(_ type:ButtonType) -> UIColor {
        switch type {
        case .error, .link, .regular: return .clear
        case .linkBackground: return .blue//K.Colors.Interface.blue
        default: return .clear
        }
    }
    
    func getAlertImage(image:UIImage?, type:ViewType) -> UIImage? {
        if let image = image {
            return image
        } else {
            if type == .error || type == .internetError {
                return .init(named: "warning", in: .main, compatibleWith: nil)
            } else {
                if type == .succsess {
                    return .init(named: "success", in: .main, compatibleWith: nil)
                } else {
                    return nil
                }
            }
                                                   
        }
        
    }

    
}
