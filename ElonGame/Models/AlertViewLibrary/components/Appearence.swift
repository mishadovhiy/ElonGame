//
//  AlertDefaultText.swift
//  AlertView
//
//  Created by Misha Dovhiy on 06.06.2022.
//

import UIKit


public struct AIAppearence {
    let text:Text
    let colors:Colors
    
    public var zPosition:CGFloat?
    
    public init(text:Text, colors:Colors) {
        self.text = text
        self.colors = colors
    }
    
    public struct Text {
        var loading:String
        var done:String
        var internetError:(title:String, description:String)
        var error:String
        var okButton:String
        var success:String
        public init(loading:String? = nil, done:String? = nil, internetError:(title:String, description:String)? = nil, error:String? = nil, okButton:String? = nil, success:String? = nil) {
            self.loading = loading ?? "Loading"
            self.done = done ?? "Done"
            self.internetError = internetError ?? (title:"Internet error", description:"Try again later")
            self.error = error ?? "Error"
            self.okButton = okButton ?? "OK"
            self.success = success ?? "Success"
        }
    }

    public struct Colors {
        var accent:(background:UIColor, view:UIColor, higlight:UIColor)
        var normal:(background:UIColor, view:UIColor)
        var buttom:(link:UIColor, normal:UIColor)
        var texts:(title:UIColor, description:UIColor)
        var separetor:UIColor
        public init(accent:(background:UIColor, view:UIColor, higlight:UIColor)? = nil,
                    normal:(background:UIColor, view:UIColor)? = nil,
                    buttom:(link:UIColor, normal:UIColor)? = nil,
                    texts:(title:UIColor, description:UIColor)? = nil,
                    separetor:UIColor? = nil
        ) {
            

            let blackColor = UIColor.black//K.Colors.Interface.primaryBackground.darker()
            let defViewColor = UIColor.darkGray//K.Colors.Interface.secondaryBackground
            
            let defAccent = (background: blackColor.withAlphaComponent(0.6),
                             view: defViewColor,
                             higlight: UIColor.red)
            
            let defNormal = (background: blackColor.withAlphaComponent(0.2),
                             view: defViewColor)
            
            let defButtom = (link: UIColor.blue,
                             normal: UIColor.white)
            
            let defTexts = (title: UIColor.white,
                            description: UIColor.lightGray)
            
            self.accent = accent ?? defAccent
            self.normal = normal ?? defNormal
            self.buttom = buttom ?? defButtom
            self.texts = texts ?? defTexts
            self.separetor = separetor ?? .gray
        }
    }
    
    
    
}


/*
extension CALayer {
    func createLine(_ lines:[CGPoint], color:UIColor, width:CGFloat = 0.5, opacity:Float = 0.2) -> CAShapeLayer {
        let line = CAShapeLayer()
        line.path = createPath(lines).cgPath
        line.fillColor = nil
        line.opacity = opacity
        line.lineWidth = width
        line.strokeColor = (color).cgColor
        self.addSublayer(line)
        return line
    }
    
    func drawLine(_ lines:[CGPoint], color:UIColor, width:CGFloat = 0.5, opacity:Float = 0.2) {
        let _ = createLine(lines, color: color, width: width, opacity: opacity)
    }
    
    
    private func createPath(_ lines:[CGPoint]) -> UIBezierPath {
        let linePath = UIBezierPath()
        var liness = lines
        linePath.move(to: liness.first!)
        liness.removeFirst()
        liness.forEach { line in
            linePath.addLine(to: line)
        }
        return linePath
    }
    
    
    func shadow() {
        self.shadowColor = UIColor.black.cgColor
        self.shadowOffset = .zero
        self.shadowRadius = 16
        self.shadowOpacity = 0.6
    }
}
*/
