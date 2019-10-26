//
//  PlayingCardView.swift
//  PlayingCard
//
//  Created by Seokhwan Moon on 15/10/2019.
//  Copyright © 2019 Parannarae. All rights reserved.
//

// Create new CocoaTouch Class file since View (UIKit) is a CocoaTouch Class

import UIKit

// IBDesignable allows to see drawing in the storyboard, however it does not work with (imported) image
@IBDesignable
class PlayingCardView: UIView
{
    // rank and suit is not enum since it is general view who does not need to know about data
    // it is a controller's job to convert those
    
    // add this var to the storyborad inspector (to work with this, type should be set explicitly)
    @IBInspectable
    var rank: Int = 12 {
        // redraw when rank is changed
        // setNeedsLayout is required since we will have subViews, and they are needed to be re-arranged
        didSet { setNeedsDisplay(); setNeedsLayout()}
    }
    @IBInspectable
    var suit: String = "♥️" { didSet { setNeedsDisplay(); setNeedsLayout()}}
    @IBInspectable
    var isFaceUp: Bool = true { didSet { setNeedsDisplay(); setNeedsLayout()}}
    
    var faceCardScale: CGFloat = SizeRatio.faceCardImageSizeToBoundsSize { didSet { setNeedsDisplay() }}
    
    // pinch gesture to resize the card
    @objc func adjustFaceCardScale(byHandlingGestureRecognizedBy recognizer: UIPinchGestureRecognizer) {
        switch recognizer.state {
        case .changed, .ended:
            faceCardScale *= recognizer.scale
            recognizer.scale = 1.0  // reset the scale to make it discrete (not exponential)
        default: break
        }
    }
    
    // make a number to be center of the shape of a suit
    private func centeredAttributedString(_ string: String, fontSize: CGFloat) -> NSAttributedString {
        // preferredFont is used since it is an UI
        var font = UIFont.preferredFont(forTextStyle: .body).withSize(fontSize)
        // match to the text size scale in the iPhone accessibility menu
        font = UIFontMetrics(forTextStyle: .body).scaledFont(for: font)
        // work like a paragraph
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        // swift automatically infer the type to be NSAttributedString.key (on attributes argument)
        return NSAttributedString(string: string, attributes: [.paragraphStyle: paragraphStyle, .font:font])
    }
    
    private var cornerString: NSAttributedString {
        return centeredAttributedString(rankString + "\n" + suit, fontSize: conrnerFontSize)
    }
    
    // to show a demo for subView, instead of NSAttributedString, Label will be used instead
    // in initialization (setting default value), instance method cannot be called (so lazy needs to be used)
    private lazy var upperLeftCornerLabel = createCornerLabel()
    private lazy var lowerRightCornerLabel = createCornerLabel()
    
    private func createCornerLabel() -> UILabel {
        let label = UILabel()
        // make lines more than 1
        // 0 means use as many as I needed
        label.numberOfLines = 0
        addSubview(label) // to show in SuperView
        return label
    }
    
    private func configureCornerLabel(_ label: UILabel) {
        // draw suit and rank
        label.attributedText = cornerString
        label.frame.size = CGSize.zero  // clear out the size (which is initially defined) before resizing it
        label.sizeToFit()   // size Label to its contents
        label.isHidden = !isFaceUp  // show only when it is faced up
    }
    
    // redraw the font when the accessibility setting changes font size (to scale up responsively)
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        setNeedsDisplay()
        setNeedsLayout()
    }
    
    // label need to be re-positioned depending on the bound size
    // this is called by system (if required to manually redraw views, use `setNeedsLayout`)
    override func layoutSubviews() {
        super.layoutSubviews()
        
        configureCornerLabel(upperLeftCornerLabel)
        upperLeftCornerLabel.frame.origin = bounds.origin.offsetBy(dx: cornerOffSet, dy: cornerOffSet)
        
        configureCornerLabel(lowerRightCornerLabel)
        // diagram needs to be flipped
        // use affine transform
        // note that `rotate` work at the origin (not the center) of a label
        lowerRightCornerLabel.transform = CGAffineTransform.identity
            .translatedBy(x: lowerRightCornerLabel.frame.size.width, y: lowerRightCornerLabel.frame.height)
            .rotated(by: CGFloat.pi)
        // origin of lowerRightCornerLabel needs to consider the card size when offset
        lowerRightCornerLabel.frame.origin = CGPoint(x: bounds.maxX, y: bounds.maxY)
            .offsetBy(dx: -cornerOffSet, dy: -cornerOffSet)
            .offsetBy(dx: -lowerRightCornerLabel.frame.size.width, dy: -lowerRightCornerLabel.frame.size.height)
    }
    
    private func drawPips()
    {
        let pipsPerRowForRank = [[0],[1],[1,1],[1,1,1],[2,2],[2,1,2],[2,2,2],[2,1,2,2],[2,2,2,2],[2,2,1,2,2],[2,2,2,2,2]]
        
        func createPipString(thatFits pipRect: CGRect) -> NSAttributedString {
            let maxVerticalPipCount = CGFloat(pipsPerRowForRank.reduce(0) { max($1.count, $0) })
            let maxHorizontalPipCount = CGFloat(pipsPerRowForRank.reduce(0) { max($1.max() ?? 0, $0) })
            let verticalPipRowSpacing = pipRect.size.height / maxVerticalPipCount
            let attemptedPipString = centeredAttributedString(suit, fontSize: verticalPipRowSpacing)
            let probablyOkayPipStringFontSize = verticalPipRowSpacing / (attemptedPipString.size().height / verticalPipRowSpacing)
            let probablyOkayPipString = centeredAttributedString(suit, fontSize: probablyOkayPipStringFontSize)
            if probablyOkayPipString.size().width > pipRect.size.width / maxHorizontalPipCount {
                return centeredAttributedString(suit, fontSize: probablyOkayPipStringFontSize)
            } else {
                return probablyOkayPipString
            }
        }
        
        if pipsPerRowForRank.indices.contains(rank) {
            let pipsPerRow = pipsPerRowForRank[rank]
            var pipRect = bounds.insetBy(dx: cornerOffSet, dy: cornerOffSet).insetBy(dx: cornerString.size().width, dy: cornerString.size().height / 2)
            let pipString = createPipString(thatFits: pipRect)
            let pipRowSpacing = pipRect.size.height / CGFloat(pipsPerRow.count)
            pipRect.size.height = pipString.size().height
            pipRect.origin.y += (pipRowSpacing - pipRect.size.height) / 2
            for pipCount in pipsPerRow {
                switch pipCount {
                case 1:
                    pipString.draw(in: pipRect)
                case 2:
                    pipString.draw(in: pipRect.leftHalf)
                    pipString.draw(in: pipRect.rightHalf)
                default:
                    break
                }
                pipRect.origin.y += pipRowSpacing
            }
        }
    }

    // Note that view without draw function is very common since actual drawing is usually done in subviews
    override func draw(_ rect: CGRect) {
/* showing custom drawing
//        // context will never be returned as nil
//        if let context = UIGraphicsGetCurrentContext() {
//            // Angle is in radian
//            // 0 is off to the right (positive x-axis)
//            context.addArc(center: CGPoint(x: bounds.midX, y: bounds.midY), radius: 100.0, startAngle: 0, endAngle: 2 * CGFloat.pi, clockwise: true)
//            context.setLineWidth(5.0)
//            UIColor.green.setFill()
//            UIColor.red.setStroke()
//            context.strokePath()
//            // fill is not drawn since above stroke consumes the path (need to redefine another path)
//            context.fillPath()
//        }
        
        let path = UIBezierPath()
        path.addArc(withCenter: CGPoint(x: bounds.midX, y: bounds.midY), radius: 100.0, startAngle: 0, endAngle: 2 * CGFloat.pi, clockwise: true)
        path.lineWidth = 5.0
        UIColor.green.setFill()
        UIColor.red.setStroke()
        path.stroke()
        // path still exists (not consumed)
        path.fill()
        
        // Note when the screen rotate, circle becomes oval (when the screen rotated, views are stretched to fill the screen
        // check Content Mode in inspector view
*/
        let roundedRect = UIBezierPath.init(roundedRect: bounds, cornerRadius: 16.0)
        roundedRect.addClip()   // draw only inside this roundedRect
        UIColor.white.setFill()
        roundedRect.fill()
        // roundedRect is not shown since background is white as well
        // thus to make view transparent, Opague should be set to false
        
        // draw face card image
        if isFaceUp {
            // add `in` and compatiblewith parameters to use with IBDesignable
            if let faceCardImage = UIImage(named: rankString + suit, in: Bundle(for: self.classForCoder), compatibleWith: traitCollection) {
                // allow to change the card size
                faceCardImage.draw(in: bounds.zoom(by: faceCardScale))
//                // constant size
//                faceCardImage.draw(in: bounds.zoom(by: SizeRatio.faceCardImageSizeToBoundsSize))
            } else {
                drawPips()
            }
        } else {
            // back of the card
            if let cardBackImage = UIImage(named: "cardback", in: Bundle(for: self.classForCoder), compatibleWith: traitCollection) {
                cardBackImage.draw(in: bounds)
            }
        }
    }
}

extension PlayingCardView {
    // making constant values in Swift (using static let in struct)
    private struct SizeRatio {
        static let cornerFontSizeToBoundsHeight: CGFloat = 0.085
        static let cornerRadiusToBoundsHeight: CGFloat = 0.06
        static let cornerOffsetToCornerRadius: CGFloat = 0.33
        static let faceCardImageSizeToBoundsSize: CGFloat = 0.75
    }
    
    private var cornerRadius: CGFloat {
        return bounds.size.height * SizeRatio.cornerRadiusToBoundsHeight
    }
    private var cornerOffSet: CGFloat {
        return cornerRadius * SizeRatio.cornerOffsetToCornerRadius
    }
    private var conrnerFontSize: CGFloat {
        return bounds.size.height * SizeRatio.cornerFontSizeToBoundsHeight
    }
    private var rankString: String {
        switch rank {
        case 1: return "A"
        case 2...10: return String(rank)
        case 11: return "J"
        case 12: return "Q"
        case 13: return "K"
        default: return "?"
        }
    }
}

extension CGRect {
    var leftHalf: CGRect {
        return CGRect(x: minX, y: minY, width: width / 2, height: height)
    }
    var rightHalf: CGRect {
        return CGRect(x: midX, y: minY, width: width / 2, height: height)
    }
    func inset(by size: CGSize) -> CGRect {
        return insetBy(dx: size.width, dy: size.height)
    }
    func sized(to size: CGSize) -> CGRect {
        return CGRect(origin: origin, size: size)
    }
    func zoom(by scale: CGFloat) -> CGRect {
        let newWidth = width * scale
        let newHeight = height * scale
        return insetBy(dx: (width - newWidth) / 2, dy: (height - newHeight) / 2)
    }
}

extension CGPoint {
    func offsetBy(dx: CGFloat, dy: CGFloat) -> CGPoint {
        return CGPoint(x: x + dx, y: y + dy)
    }
}
