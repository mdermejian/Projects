//
//  StarShapeView.swift
//  Projects
//
//  Created by Marc Dermejian on 16/11/2016.
//  Copyright © 2016 Marc Dermejian. All rights reserved.
//

import UIKit

@IBDesignable
class StarShapeView: UIView {

	let starLayer = CAShapeLayer()

	let pointsOnStar = 5
	
	@IBInspectable var lineWidth: CGFloat = 0.5 {
		didSet {
			configure()
		}
	}

	@IBInspectable var strokeColor: UIColor = UIColor.clear {
		didSet {
			configure()
		}
	}
	
	@IBInspectable var strokeColorDisabled: UIColor = Utility.lightGray {
		didSet {
			configure()
		}
	}

	@IBInspectable var fillColor: UIColor = Utility.yellow {
		didSet {
			configure()
		}
	}

	@IBInspectable var isEnabled: Bool = false {
		didSet {
			configure()
		}
	}

	override func awakeFromNib() {
		super.awakeFromNib()
		setup()
		configure()
	}
	
	override func prepareForInterfaceBuilder() {
		super.prepareForInterfaceBuilder()
		setup()
		configure()
	}

	private func setup() {
	
		backgroundColor = UIColor.clear
		
		// Setup background layer
		starLayer.fillColor = nil
		starLayer.strokeEnd = 1
		layer.addSublayer(starLayer)
		
	}

	
	private func configure() {
		starLayer.strokeColor = isEnabled ? strokeColor.cgColor : strokeColorDisabled.cgColor
		starLayer.fillColor = isEnabled ? fillColor.cgColor : nil
	}

	
	override func layoutSubviews() {
		super.layoutSubviews()
		setupShapeLayer(shapeLayer: starLayer)
	}

	
	private func setupShapeLayer(shapeLayer:CAShapeLayer) {
		shapeLayer.frame = bounds
		
		let path = starPathInRect(rect: bounds)
		path.lineWidth = lineWidth
		shapeLayer.path = path.cgPath
	}

	
	private func pointFrom(angle: CGFloat, radius: CGFloat, offset: CGPoint) -> CGPoint {
		return CGPoint(x: radius * cos(angle) + offset.x, y: radius * sin(angle) + offset.y)
	}
	
	private func starPathInRect(rect: CGRect) -> UIBezierPath {
		let path = UIBezierPath()
		
		let starExtrusion:CGFloat = rect.width / 5.0
		
		let center = CGPoint(x: rect.width / 2.0, y: rect.height / 2.0)
		
		var angle = -CGFloat(M_PI / 2.0)
		let angleIncrement = CGFloat(M_PI * 2.0 / Double(pointsOnStar))
		let radius = rect.width / 2.0
		
		var firstPoint = true
		
		for _ in 1...pointsOnStar {
			
			let point = pointFrom(angle: angle, radius: radius, offset: center)
			let nextPoint = pointFrom(angle: angle + angleIncrement, radius: radius, offset: center)
			let midPoint = pointFrom(angle: angle + angleIncrement / 2.0, radius: starExtrusion, offset: center)
			
			if firstPoint {
				firstPoint = false
				path.move(to: point)
			}
			
			path.addLine(to: midPoint)
			path.addLine(to: nextPoint)
			
			angle += angleIncrement
		}
		
		path.close()
		
		return path
	}

}
