//
//  TimerProgressBar.swift
//  carvensy
//
//  Created by Kathleen Febiola Susanto on 14/06/22.
//

import UIKit

class TimerProgressBar: UIView {

    
    //ini warna background circular barnya
    @IBInspectable public lazy var backgroundCircleColor: UIColor = UIColor.lightGray
    
    //ini warna foregroundnya, nanti kalau udh ada set warnanya monggo ganti
    @IBInspectable public lazy var foregroundCircleColor: UIColor = CarvensyColor.greenMain ?? UIColor.green
    @IBInspectable public lazy var textColor: UIColor = UIColor.black
    
    private lazy var fillColor: UIColor = UIColor.clear
    
    private var backgroundLayer: CAShapeLayer!
    private var progressLayer: CAShapeLayer!
    private var textLayer: CATextLayer!
    
    public var isHour: Bool = false
    
    //ini buat set ditextnya ntar dia tampilannya berapa (misal countdown dari 50 ntar di controllernya ganti progressMultipliernya jadi 50
    
    public var progressMultiplier: CGFloat = 10
    
    //ini buat kalau labelnya bentuknya jam:menit:detik
    
    public var selectedTime: Double = 0
    
    //ini progress awalnya dia dari berapa (antara 0 atau 1 biasanya)
    public var progress: CGFloat = 1 {
      didSet {
        didProgressUpdated()
      }
    }
    
    public var animationDidStarted: (()->())?
    public var animationDidCanceled: (()->())?
    public var animationDidStopped: (()->())?
    
    private var timer: ProgressTimer?
    private var isAnimating = false
    
    //ini cepet atau lamanya timernya (default 1 buat 1 detik)
    private let tickInterval :TimeInterval = 1
    
    //ini berapa lama durasi countdownnya
    public var maxDuration: Int = 10
    
    
    override func draw(_ rect: CGRect) {
      
      guard layer.sublayers == nil else {
        return
      }
      
      let lineWidth = min(frame.size.width, frame.size.height) * 0.1
      
      backgroundLayer = createCircularLayer(strokeColor: backgroundCircleColor.cgColor, fillColor: fillColor.cgColor, lineWidth: lineWidth)
      
      progressLayer = createCircularLayer(strokeColor: foregroundCircleColor.cgColor, fillColor: fillColor.cgColor, lineWidth: lineWidth)
      progressLayer.strokeEnd = progress
   
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
      
      let fontSize = min(width, height) / 4 - 5
      let offset = min(width, height) * 0.1
      
      let layer = CATextLayer()
        
        if isHour
        {
            let intTime = Int(selectedTime)
            let hour = intTime/3600
            let min = (intTime % 3600) / 60
            let sec = (intTime % 3600) % 60
            
            var timeString = ""
            timeString += String(format: "%02d", hour)
            timeString += ":"
            timeString += String(format: "%02d", min)
            timeString += ":"
            timeString += String(format: "%02d", sec)
            
            layer.string = timeString
            
            
        }
        
        else
        {
            layer.string = "\(Int(progress * progressMultiplier))"
        }
        
    
      layer.backgroundColor = UIColor.clear.cgColor
      layer.foregroundColor = textColor.cgColor
      layer.fontSize = fontSize
      layer.frame = CGRect(x: 0, y: (height - fontSize - offset) / 2, width: width, height: height)
      layer.alignmentMode = .center
      
      return layer
    }
    
    
    private func didProgressUpdated() {
      
      textLayer?.string = "\(Int(progress * progressMultiplier))"
      progressLayer?.strokeEnd = progress
    }
  }

  // Animation

  extension TimerProgressBar {
    
    func startAnimation(duration: TimeInterval) {
      
      print("Start animation")
      isAnimating = true
      
      progressLayer.removeAllAnimations()
      
      let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
      basicAnimation.duration = duration
      basicAnimation.toValue = progress
      
      basicAnimation.delegate = self
      
      timer = ProgressTimer(duration: maxDuration, tickInterval: tickInterval)
      
      timer?.timerFired = { [weak self] value in
        self?.textLayer.string = "\(value)"
      }
      
      timer?.timerStopped = { [weak self] in
        self?.textLayer.string = ""
      }
      
      timer?.timerCompleted = {}
      
      progressLayer.add(basicAnimation, forKey: "recording")
      timer?.start()
    }
    
    func stopAnimation() {
      timer?.stop()
      progressLayer.removeAllAnimations()
    }
    
  }

  extension TimerProgressBar: CAAnimationDelegate {
    
    func animationDidStart(_ anim: CAAnimation) {
      animationDidStarted?()
    }
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
      isAnimating = false
      flag ? animationDidStopped?() : animationDidCanceled?()
    }
}
