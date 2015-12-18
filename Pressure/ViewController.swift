import UIKit

class ViewController: UIViewController {
    var lrRed: CGFloat = 0.0
    var lrGreen: CGFloat = 0.0
    var lrBlue: CGFloat = 0.0
    var lrAlpha: CGFloat = 0.0
    var divideBy: CGFloat = 0.020833333

    @IBOutlet weak var weight: UILabel!
    @IBOutlet weak var sensitivity: UILabel!
    var currentForce: CGFloat! = 0
    var tareForce: CGFloat! = 0

    func updateSensitivityText() {
        let defaults: NSUserDefaults = NSUserDefaults.standardUserDefaults()
        if(defaults.valueForKey("sensitivity") as? String == "" || defaults.valueForKey("sensitivity") == nil) {
        } else {
            sensitivity.text = defaults.valueForKey("sensitivity") as? String
        }
    }

    @IBAction func button() {
        let testView = self.view
//        testView.backgroundColor = UIColor.greenColor()
//        self.view.addSubview(testView)

        let transformAnim            = CAKeyframeAnimation(keyPath:"transform")
        transformAnim.values         = [NSValue(CATransform3D: CATransform3DMakeRotation(3 * CGFloat(M_PI/180), 12, 12, -1)),
//        NSValue(CATransform3D: CATransform3DConcat(CATransform3DMakeScale(0.02, 0.02, 1), CATransform3DMakeRotation(3 * CGFloat(M_PI/180), 0, 0, 1))),
        NSValue(CATransform3D: CATransform3DMakeScale(0.002, 1, 1)),
        NSValue(CATransform3D: CATransform3DConcat(CATransform3DMakeScale(0.06, 0.002, 1), CATransform3DMakeRotation(-8 * CGFloat(M_PI/180), 0, 0, 1)))]
//        transformAnim.keyTimes       = [0, 0.349, 0.618, 1]
        transformAnim.duration       = 6

        testView.layer.addAnimation(transformAnim, forKey: "transform")
    }

    override func viewDidLoad() {
//        let defaults: NSUserDefaults = NSUserDefaults.standardUserDefaults()
//        defaults.setValue(nil, forKey: "sensitivity")
//        defaults.synchronize()
        let recognizer: UITapGestureRecognizer = UITapGestureRecognizer()
        recognizer.addTarget(self, action: Selector("tapAction"))
        recognizer.numberOfTapsRequired = 1
        weight.addGestureRecognizer(recognizer)
        let recognizer2: UITapGestureRecognizer = UITapGestureRecognizer()
        recognizer2.addTarget(self, action: Selector("tapActionSensitivity"))
        recognizer2.numberOfTapsRequired = 1
        sensitivity.addGestureRecognizer(recognizer2)
        view.multipleTouchEnabled = true
        weight.text = "0 grams"
        updateSensitivityText()
    }

    func tapActionSensitivity() {
        let defaults: NSUserDefaults = NSUserDefaults.standardUserDefaults()
        if(defaults.valueForKey("sensitivity") == nil) {
			sensitivity.text = "Light"
        } else if(defaults.valueForKey("sensitivity") as? String == "Light") {
            sensitivity.text = "Medium"
        } else if(defaults.valueForKey("sensitivity") as? String == "Medium") {
            sensitivity.text = "Firm"
        } else if(defaults.valueForKey("sensitivity") as? String == "Firm") {
            sensitivity.text = "Light"
        }
        defaults.setValue(sensitivity.text, forKey: "sensitivity")
        defaults.synchronize()
        updateSensitivityText()
    }

    func tapAction() {
        tareForce = currentForce
        weight.text = "0 grams"
//        self.view.layer.transform = CATransform3DMakeScale(0.3, 0.3, 0.3)
//		self.view.layer.transform = CATransform3DRotate(CATransform3DIdentity, 45.0, 0, 0, 0)
//		[self scaleUnitSquareToSize:NSMakeSize(2.0, 2.0)];

    }

    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
		touchy(touches)
        let touch = touches.first as UITouch?
        currentForce = touch!.force
        weight.text = "\(currentForce.grams(tareForce))g"
    }

    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        touchy(touches)

        let touch = touches.first as UITouch?
        currentForce = touch!.force
        weight.text = "\(currentForce.grams(tareForce))g"
        self.view.bringSubviewToFront(weight)
        self.view.bringSubviewToFront(sensitivity)
    }

    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        currentForce = 0
        weight.text = "\(tareForce > 0 ? "-" : "")\(tareForce.grams(0))g"
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        NSLog("override func didReceiveMemoryWarning() {")
    }

    func touchy(touches: Set<UITouch>) {
        var touchPoint: CGPoint = CGPoint()
        var size: CGFloat = CGFloat()
        var touch: UITouch = UITouch()

        var i: Int = 0;
        for obj in touches {
			if(obj.force == obj.maximumPossibleForce && obj.maximumPossibleForce > 1) {
                for sublayer in self.view.layer.sublayers! {
                    if(sublayer.valueForKey("tag") as? String == "99") {
                        sublayer.removeFromSuperlayer()
                    }
                }
				self.view.layer.backgroundColor = UIColor.whiteColor().CGColor
                return
            }
            touch = obj
            i++

            touchPoint = touch.locationInView(self.view)
            size = touch.force*2.6 / CGFloat(0.020000)

	        let touchView: CAShapeLayer = CAShapeLayer()
            touchView.setValue("99", forKey: "tag")
	        if(touch.maximumPossibleForce <= 1) { size = 10 + (touch.locationInView(self.view).x + touch.locationInView(self.view).y)/2 }

            if(lrRed == 0) {
                lrRed = (CGFloat(arc4random()) / 0x100000000)
                lrGreen = (CGFloat(arc4random()) / 0x100000000)
                lrBlue = (CGFloat(arc4random()) / 0x100000000)
                lrAlpha = touch.force/6;
            }

            lrRed = ((lrRed + (CGFloat(arc4random()) / 0x100000000) + touch.force/32) / 2) - touch.force/24
            lrGreen = ((lrGreen + (CGFloat(arc4random()) / 0x100000000) + touch.force/32) / 2) - touch.force/24
            lrBlue = ((lrBlue + (CGFloat(arc4random()) / 0x100000000) + touch.force/32) / 2) - touch.force/24
            lrAlpha = ((lrAlpha + (CGFloat(arc4random()) / 0x100000000) + touch.force/32) / 2) - touch.force/24

            touchView.backgroundColor = UIColor(red:lrRed , green:lrGreen, blue:lrBlue, alpha:1.0).CGColor

//uncomment the following code to draw rings instead of circles
//            touchView.backgroundColor = UIColor.clearColor().CGColor
//            touchView.borderWidth = size/6
//            if(size < 100) { touchView.borderWidth = 100 }
//            touchView.borderColor = UIColor(red:lrRed , green:lrGreen, blue:lrBlue, alpha:1.0).CGColor

//            touchView.shouldRasterize = true

            touchView.frame = CGRectMake(touchPoint.x-(size/2), touchPoint.y-(size/2), size, size)
            touchView.cornerRadius = size/2;
            self.view.layer.addSublayer(touchView)
        }
    }
}

extension CGFloat {		//var forceConversions = [0.020833333, 0.0166666, 0.0138888883369941];
    func grams(tare: CGFloat) -> String {
        let defaults: NSUserDefaults = NSUserDefaults.standardUserDefaults()

        if(defaults.valueForKey("sensitivity") == nil) {
            return String(format: "%.0f", (self - tare) / CGFloat(0.020833333))
        } else if(defaults.valueForKey("sensitivity") as? String == "Light") {
            return String(format: "%.0f", (self - tare) / CGFloat(0.020833333))
        } else if(defaults.valueForKey("sensitivity") as? String == "Medium") {
            return String(format: "%.0f", (self - tare) / CGFloat(0.0166666))
        } else if(defaults.valueForKey("sensitivity") as? String == "Firm") {
            return String(format: "%.0f", (self - tare) / CGFloat(0.0138888883369941))
        }
        return String(format: "%.0f", (self - tare) / CGFloat(0.020833333))
    }
}