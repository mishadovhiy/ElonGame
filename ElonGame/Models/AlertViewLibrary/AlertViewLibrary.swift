import UIKit

public protocol AlertViewProtocol {
    func alertViewWillAppear()
    func alertViewDidDisappear()
}

public class AlertViewLibrary: UIView {
    public var delegate:AlertViewProtocol?
    lazy var appearence = AIAppearence(text: .init(), colors: .init())
    
    @IBOutlet weak var actionStackAddView: UIView!
    @IBOutlet weak var cointsLabel: UILabel!
    @IBOutlet weak var middleImageSuperview: UIView!
    @IBOutlet weak var middleImageView: UIImageView!
    @IBOutlet private weak var actionsStack: UIStackView!
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var leftButton: UIButton!
    @IBOutlet private weak var rightButton: UIButton!
    
    @IBOutlet private weak var aiSuperView: UIView!
    @IBOutlet private weak var ai: UIActivityIndicatorView!

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var cointsView: UIView!
    
    private var canCloseOnSwipe = false
    public var isShowing = false
    
    private var anshowedAIS: [Any] = []
    private var rightFunc: (Any?, Bool)?
    private var leftFunc: (Any?, Bool)?
    /**
     - ai woudn't show when set so false
     */
    public var hideIndicatorBlockDesibled = true
    var normalTitleSize: UIFont = .systemFont(ofSize: 24, weight: .semibold)

    var drawCalled = false
    public override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        if drawCalled {
            return
        }
        drawCalled = true

        let actionStackFrame = actionsStack.layer.frame
      /*  let separetor1 = actionsStack.layer.drawLine([
            .init(x: -20, y: 0), .init(x: actionStackFrame.width + 40, y: 0)
        ], color: appearence.colors.separetor, width: 0.15, opacity: 1)
        
        let separetor2 = actionsStack.layer.drawLine([
            .init(x: actionStackFrame.width / 2, y: 0), .init(x: actionStackFrame.width / 2, y: actionStackFrame.height + 5)
        ], color: appearence.colors.separetor, width: 0.15, opacity: 1)
        self.separetor = (separetor1, separetor2)*/
        
        if !isShowing {
            self.titleLabel.textColor = appearence.colors.texts.title
            self.descriptionLabel.textColor = appearence.colors.texts.description
        } else {
            self.separetor?.0?.isHidden = true
            self.separetor?.1?.isHidden = true
        }
        
        if let zPoz = appearence.zPosition {
            self.layer.zPosition = zPoz
        }
        
        mainView.layer.masksToBounds = true
        mainView.layer.cornerRadius = 16
     //   mainView.layer.shadow()
        let window = UIApplication.shared.keyWindow ?? UIWindow()
     /*   let _ = self.backgroundView.addBluer(frame: .init(x: 0, y: 0, width: window.frame.width, height: window.frame.height),
                                             insertAt: 0)*/
    }
    private var separetor:(CALayer?, CALayer?)?
    public var notShowingCondition:(() -> (Bool))?
    
    
    
    public func show(title: String? = nil, description: String? = nil, appeareAnimation: Bool = false, notShowIfLoggedUser:Bool = false, completion: @escaping (Bool) -> ()) {
        
        if notShowIfLoggedUser && (notShowingCondition?() ?? false) {
            completion(true)
            return
        }
        if !self.hideIndicatorBlockDesibled {
            return
        }
        if !self.isShowing {
            self.isShowing = true
        }
        self.canCloseOnSwipe = false
        let hideTitle = title == nil ? true : false
        self.cointsView.superview?.isHidden = true
        let hideDescription = (description == "" || description == nil) ? true : false
        self.setBacground(higlight: false, ai: true)

        let window = UIApplication.shared.keyWindow ?? UIWindow()
        self.frame = window.frame
        window.addSubview(self)
        self.setImage(hidden: true, isImage: nil, imageName: nil)
        self.alpha = 1
        self.backgroundView.alpha = 1
        if self.isHidden {
            self.isHidden = false
        }
        self.titleLabel.text = title
        self.descriptionLabel.text = description
        self.backgroundView.layer.transform = CATransform3DTranslate(CATransform3DIdentity, 0, 0, 0)
        if !self.actionsStack.isHidden {
            self.actionsStack.isHidden = true
        }
        self.ai.startAnimating()
        UIView.animate(withDuration: appeareAnimation ? 0.25 : 0.1) {
            self.mainView.backgroundColor = self.self.appearence.colors.normal.view
            if self.titleLabel.isHidden != hideTitle {
                self.titleLabel.isHidden = hideTitle
            }
            if self.descriptionLabel.isHidden != hideDescription {
                self.descriptionLabel.isHidden = hideDescription
            }
            if self.aiSuperView.isHidden {
                self.aiSuperView.isHidden = false
            }
            
        } completion: { (_) in
            UIView.animate(withDuration: 0.15) {
                self.mainView.layer.transform = CATransform3DTranslate(CATransform3DIdentity, 0, 0, 0)
            } completion: { (_) in
                self.aiSuperView.layoutIfNeeded()
                completion(true)
            }
        }

    }
    
   
    
    func showAlert(buttons: (Button, Button?),
                   title: String? = "Done",
                   description: String? = "",
                   attributedDesription:NSMutableAttributedString? = nil,
                   image:String? = nil,
                   style:AlertStyle? = nil,
                   appearedCompletion:(()->())? = nil) {
        
        if !hideIndicatorBlockDesibled {
            let new = {
                self.showAlert(buttons: buttons, title: title, description: description, attributedDesription: attributedDesription, image: image, style: style, appearedCompletion: appearedCompletion)
            }
            self.anshowedAIS.append(new)
            if !self.isShowing {
                self.hideIndicatorBlockDesibled = true
                self.checkUnshowed()
            }
            return
        } else {
            let alertSyle = style ?? .init()
            setLabel(normal: title ?? (alertSyle.type == .internetError ? self.appearence.text.internetError.title : title),
                     aligment: alertSyle.textAligment,
                     label: titleLabel,
                     color: self.appearence.colors.texts.title)
            setLabel(normal: description ?? (alertSyle.type == .internetError ? self.appearence.text.internetError.description : description),
                     attributed: attributedDesription,
                     aligment: alertSyle.textAligment,
                     label: descriptionLabel,
                     color: self.appearence.colors.texts.description)
            setImage(hidden: image ?? "" == "",
                     isImage: alertSyle.imgPosition,
                     imageName: image)
            setTitleSize(alertSyle.type)

            let hideButtonSeparetor = buttons.1 == nil || alertSyle.textAligment == .center ? true : false
            let hideTopSeparetor = alertSyle.textAligment == .center ? true : false
            self.hideIndicatorBlockDesibled = false
            self.leftFunc = (buttons.0.action, buttons.0.close)
            self.cointsView.superview?.isHidden = ((alertSyle.needCoints ?? "") == "")
            self.actionsStack.axis = alertSyle.textAligment == .center ? .vertical : .horizontal
            self.buttonStyle(self.leftButton, type: buttons.0)
            if let right = buttons.1 {
                self.rightFunc = (right.action, right.close)
                self.buttonStyle(self.rightButton, type: right)
            }
            if buttons.1 == nil {
                self.rightButton.isHidden = true
            }
            self.aiSuperView.isHidden = true
            let needHiglight = alertSyle.type == .error || alertSyle.type == .internetError

            self.checkIfShowing(title: title ?? "", isBlack: false) { _ in
                self.setBacground(higlight: needHiglight, ai: false)
                self.separetor?.0?.isHidden = hideTopSeparetor
                self.separetor?.1?.isHidden = hideButtonSeparetor
                if alertSyle.type == .error {
                    UIImpactFeedbackGenerator().impactOccurred()
                }
                UIView.animate(withDuration: 0.20) {
                    self.mainView.backgroundColor = self.appearence.colors.accent.view
                    self.actionStackAddView.isHidden = !(alertSyle.textAligment == .center)
                    self.leftButton.superview?.superview?.isHidden = false
                } completion: { _ in
                    if let appearedCompletion = appearedCompletion {
                        appearedCompletion()
                    }
                }
                
            }
        }
    }
    
    
    
    
    
    
    private func checkIfShowing(title: String, isBlack: Bool, showed: @escaping (Bool) -> ()) {
        if !isShowing {
            isShowing = true
            if let addedToView = self.addedToView {
                self.frame = addedToView.frame
                addedToView.addSubview(self)
            } else {
                let window = UIApplication.shared.keyWindow ?? UIWindow()
                self.frame = window.frame
                window.addSubview(self)
                self.backgroundView.layer.transform = CATransform3DTranslate(CATransform3DIdentity, 0, window.frame.height + 100, 0)
            }
            
            self.alpha = 1
            self.backgroundView.alpha = 1
            if self.isHidden != false {
                self.isHidden = false
            }

            self.alpha = 1
            self.backgroundView.alpha = 1
            if self.backgroundView.isHidden != false {
                self.backgroundView.isHidden = false
            }
            

            self.backgroundView.backgroundColor = .clear
            if self.mainView.isHidden != false {
                self.mainView.isHidden = false
            }
            UIView.animate(withDuration: 0.65, delay: 0, usingSpringWithDamping: 0.75, initialSpringVelocity: 0, options: .allowAnimatedContent) {
                self.backgroundView.layer.transform = CATransform3DTranslate(CATransform3DIdentity, 0, 0, 0)
            } completion: { _ in
                UIApplication.shared.keyWindow?.endEditing(true)
                if let delegate = self.delegate {
                    delegate.alertViewWillAppear()
                }
                showed(true)
            }
        } else {
            showed(true)
        }
    }
    
    
    
    @IBAction private func closePressed(_ sender: UIButton) {
        fastHide()
    }
    
    @IBAction private func buttonPress(_ sender: UIButton) {
        hideIndicatorBlockDesibled = true
        switch sender.tag {
        case 0:
            if let function = leftFunc?.0 as? (Bool) -> () {
                if leftFunc?.1 == true {
                    fastHide { _ in
                        function(true)
                    }
                } else {
                    self.show(appeareAnimation:true) { _ in
                        function(true)
                    }
                }
            } else {
                fastHide()
            }
        case 1:
            if let function = rightFunc?.0 as? (Bool) -> () {
                if rightFunc?.1 == true {
                    fastHide { (_) in
                        function(true)
                    }
                } else {
                    self.show(appeareAnimation:true) { _ in
                        function(true)
                    }
                }
            } else {
                fastHide()
            }
        default:
            break
        }
    }
    
    public func fastHide() {
        fastHide { _ in
            
        }
    }
    
    public func fastHide(completionn: @escaping (Bool) -> ()) {
        if !isShowing {
            completionn(false)
            return
        }
        if !hideIndicatorBlockDesibled {
            return
        }

        let window = UIApplication.shared.keyWindow ?? UIWindow()
        UIView.animate(withDuration: 0.10) {
            self.backgroundView.backgroundColor = .clear
        } completion: { (_) in
            UIView.animate(withDuration: 0.25) {
                if self.actionsStack.isHidden != true {
                    self.actionsStack.isHidden = true
                }
                self.backgroundView.layer.transform = CATransform3DTranslate(CATransform3DIdentity, 0, window.frame.height + 100, 0)
            } completion: { (_) in
                self.removeFromSuperview()
                self.setAllHidden()
                completionn(true)
                
                if let delegate = self.delegate {
                    delegate.alertViewDidDisappear()
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
                    self.checkUnshowed()
                }

            }
        }

    }
    private var bannerBackgroundWas:Bool?
    
    public func checkUnshowed() {
        if let function = anshowedAIS.first as? () -> ()  {
            anshowedAIS.removeFirst()
            function()
        }
    }
    
    
    
    var addedToView:UIView? = nil
    public class func instanceFromNib(_ appearence:AIAppearence?, inView:UIView? = nil) -> AlertViewLibrary {
        
        
        if let result = UINib(nibName: "AlertView", bundle: Bundle.main).instantiate(withOwner: nil, options: nil).first as? AlertViewLibrary {
            if let appearence = appearence {
                result.appearence = appearence
            }
            result.addedToView = inView
            return result
        } else {
            if let supView = inView  {
                let view = AlertViewLibrary(frame: supView.frame)
                return view
            } else {
                let window = UIApplication.shared.keyWindow ?? UIWindow()
                let view = AlertViewLibrary(frame: window.frame)
                return view
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if canCloseOnSwipe {
            canCloseOnSwipe = false
            self.fastHide()
        }
    }
    
    
    public func setAllHidden() {
        canCloseOnSwipe = false
        isShowing = false
        if leftButton.superview?.isHidden != true {
            leftButton.superview?.isHidden = true
        }
    }
}
