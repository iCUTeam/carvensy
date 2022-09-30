//
//  RepsProgress.swift
//  carvensy
//
//  Created by Kevin Gosalim on 27/06/22.
//

import UIKit

class RepsProgress: UIView {

    @IBInspectable public lazy var backgroundCircleColor: UIColor = CarvensyColor.greenMain ?? UIColor.green
    
    @IBInspectable public lazy var foregroundCircleColor: UIColor = CarvensyColor.greenMain ?? UIColor.green
    @IBInspectable public lazy var textColor: UIColor = UIColor.white
    
    private lazy var fillColor: UIColor = CarvensyColor.greenMain ?? UIColor.green
    
    private var backgroundLayer: CAShapeLayer!
    private var progressLayer: CAShapeLayer!
    public var textLayer: CATextLayer!
    
    
    public var progressMultiplier: CGFloat = 10
    

    public var progress: String = "0/2"

    
    
    public var animationDidStarted: (()->())?
    public var animationDidCanceled: (()->())?
    public var animationDidStopped: (()->())?
    
    private var timer: ProgressTimer?
    private var isAnimating = false
    
    private let tickInterval :TimeInterval = 1
    
    public var maxDuration: Int = 10
    
    public var useNormalText: Bool = false
    
    
    override func draw(_ rect: CGRect) {
      
      guard layer.sublayers == nil else {
        return
      }
      
      let lineWidth = min(frame.size.width, frame.size.height) * 0.1
      
      backgroundLayer = createCircularLayer(strokeColor: backgroundCircleColor.cgColor, fillColor: fillColor.cgColor, lineWidth: lineWidth)
      
      progressLayer = createCircularLayer(strokeColor: foregroundCircleColor.cgColor, fillColor: fillColor.cgColor, lineWidth: lineWidth)
   
      textLayer = createTextLayer(textColor: textColor)
      
      layer.addSublayer(backgroundLayer)
      layer.addSublayer(progressLayer)
      layer.addSublayer(textLayer)
    }
    
    private func createCircularLayer(strokeColor: CGColor, fillColor: CGColor, lineWidth: CGFloat) -> CAShapeLayer {
      
      let startAngle = -CGFloat.pi / 2
      let endAngle = 2 * CGFloat.pi + startAngle
      
      let width = frame.size.width
      let height = frame.size.height
      
      let center = CGPoint(x: width / 2, y: height / 2)
      let radius = (min(width, height) - lineWidth) / 2
      
      let circularPath = UIBezierPath(arcCenter: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
      
      let shapeLayer = CAShapeLayer()
      
      shapeLayer.path = circularPath.cgPath
      
      shapeLayer.strokeColor = strokeColor
      shapeLayer.lineWidth = lineWidth
      shapeLayer.fillColor = fillColor
      shapeLayer.lineCap = .round
      
      return shapeLayer
    }
    
    private func createTextLayer(textColor: UIColor) -> CATextLayer {
      
      let width = frame.size.width
      let height = frame.size.height
      let fontsize : CGFloat
      let offset = min(width, height) * 0.1
      
      let layer = CATextLayer()
      fontsize = min(width, height) / 4
      layer.string = progress
      layer.backgroundColor = UIColor.clear.cgColor
        
      if useNormalText
      {
          layer.foregroundColor = UIColor.clear.cgColor
      }
        
        else
        {
            layer.foregroundColor = textColor.cgColor
        }
    
      layer.fontSize = fontsize
      layer.frame = CGRect(x: 0, y: (height - fontsize - offset) / 2, width: width, height: height)
      layer.alignmentMode = .center
      
      return layer
    }
}
