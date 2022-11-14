//
//  ViewController.swift
//  Project27
//
//  Created by Ákos Morvai on 2022. 07. 18..
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet var imageView: UIImageView!
    
    var currentDrawType = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        drawRectangle()
    }

    @IBAction func redrawTapped(_ sender: UIButton) {
        currentDrawType += 1
        if currentDrawType > 7 {
            currentDrawType = 0
        }
        
        switch currentDrawType {
            case 0:
                drawRectangle()
            case 1:
                drawCircle()
            case 2:
                drawCheckerboard()
            case 3:
                drawRotatedSquares()
            case 4:
                drawLines()
            case 5:
                drawImagesAndText()
            case 6:
                drawSmiley()
            case 7:
                drawTwin()
            default:
                break
        }
    }
    
    func drawRectangle() {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
        
        let image = renderer.image { context in
            let rectangle = CGRect(x: 0, y: 0, width: 512, height: 512)
            
            context.cgContext.setFillColor(UIColor.red.cgColor)
            context.cgContext.setStrokeColor(UIColor.blue.cgColor)
            context.cgContext.setLineWidth(10)
            
            context.cgContext.addRect(rectangle)
            context.cgContext.drawPath(using: .fillStroke)
        }
        
        imageView.image = image
    }
    
    func drawCircle() {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
        
        let image = renderer.image { context in
            let rectangle = CGRect(x: 0, y: 0, width: 512, height: 512).insetBy(dx: 10, dy: 10)
            
            context.cgContext.setFillColor(UIColor.red.cgColor)
            context.cgContext.setStrokeColor(UIColor.blue.cgColor)
            context.cgContext.setLineWidth(10)
            
            context.cgContext.addEllipse(in: rectangle)
            context.cgContext.drawPath(using: .fillStroke)
        }
        
        imageView.image = image
    }
    
    func drawCheckerboard() {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
        
        let image = renderer.image { context in
            context.cgContext.setFillColor(UIColor.black.cgColor)
            for row in 0 ..< 8 {
                for col in 0 ..< 8 {
                    if (row + col).isMultiple(of: 2) {
                        context.cgContext.fill(CGRect(x: col * 64, y: row * 64, width: 64, height: 64))
                    }
                }
            }
        }
        
        imageView.image = image
    }
    
    func drawRotatedSquares() {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
        
        let image = renderer.image { context in
            context.cgContext.translateBy(x: 256, y: 256)
            
            let rotations = 16
            let amount = Double.pi / Double(rotations)
            
            for _ in 0 ..< rotations {
                context.cgContext.rotate(by: CGFloat(amount))
                context.cgContext.addRect(CGRect(x: -128, y: -128, width: 256, height: 256))
                
            }
            
            context.cgContext.setStrokeColor(UIColor.black.cgColor)
            context.cgContext.strokePath()
        }
        
        imageView.image = image
    }
    
    func drawLines() {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
        
        let image = renderer.image { context in
            context.cgContext.translateBy(x: 256, y: 256)
            var first = true
            var length: CGFloat = 256
            
            for _ in 0 ..< 256 {
                context.cgContext.rotate(by: .pi / 2)
                
                if first {
                    context.cgContext.move(to: CGPoint(x: length, y: 50))
                    first = false
                } else {
                    context.cgContext.addLine(to: CGPoint(x: length, y: 50))
                }
                
                length *= 0.99
            }
            
            context.cgContext.setStrokeColor(UIColor.black.cgColor)
            context.cgContext.strokePath()
        }
        
        imageView.image = image
    }
    
    func drawImagesAndText() {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
        
        let image = renderer.image { context in
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .center
            
            let attributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 36),
                .paragraphStyle: paragraphStyle
            ]
            
            let string = "The best align is the\nbest alignment mode"
            
            let attributedString = NSAttributedString(string: string, attributes: attributes)
            attributedString.draw(with: CGRect(x: 32, y: 32, width: 448, height: 448), options: .usesLineFragmentOrigin, context: nil)
            
            let mouse = UIImage(named: "mouse")
            mouse?.draw(at: CGPoint(x: 300, y: 150))
        }
        
        imageView.image = image
    }
    
    func drawSmiley() {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
        
        let image = renderer.image { context in
            context.cgContext.translateBy(x: 256, y: 256)

            context.cgContext.setFillColor(UIColor.init(red: 173/255, green: 216/255, blue: 230/255, alpha: 1).cgColor)
//            let uicolor = UIColor.init(red: 100, green: 100, blue: 255, alpha: 1)
            context.cgContext.setStrokeColor(UIColor.black.cgColor)
            context.cgContext.setLineWidth(10)
            
            let headRectangle = CGRect(x: -128, y: -128, width: 256, height: 256)
            context.cgContext.addEllipse(in: headRectangle)

            let leftEyeRectangle = CGRect(x: -50, y: -50, width: 10, height: 10)
            context.cgContext.addEllipse(in: leftEyeRectangle)
            
            let rightEyeRectangle = CGRect(x: 50, y: -50, width: 10, height: 10)
            context.cgContext.addEllipse(in: rightEyeRectangle)
            
            context.cgContext.move(to: CGPoint(x: -60, y: 60))
            context.cgContext.addLine(to: CGPoint(x: 60, y: 60))
            
            
            context.cgContext.drawPath(using: .fillStroke)
        }
        
        imageView.image = image
    }
    
    func drawTwin() {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
        
        let image = renderer.image { context in
            context.cgContext.translateBy(x: 256, y: 256)
            
            context.cgContext.setLineWidth(1)
            context.cgContext.setFillColor(red: 0, green: 0, blue: 0, alpha: 0)

            // T
            context.cgContext.move(to: CGPoint(x: -200, y: -200))
            context.cgContext.addLine(to: CGPoint(x: -150, y: -200))
            context.cgContext.move(to: CGPoint(x: -175, y: -200))
            context.cgContext.addLine(to: CGPoint(x: -175, y: -120))
            
            // W
            context.cgContext.move(to: CGPoint(x: -125, y: -200))
            context.cgContext.addLine(to: CGPoint(x: -100, y: -120))
            context.cgContext.addLine(to: CGPoint(x: -75, y: -200))
            context.cgContext.addLine(to: CGPoint(x: -50, y: -120))
            context.cgContext.addLine(to: CGPoint(x: -25, y: -200))
            
            // I
            context.cgContext.move(to: CGPoint(x: 0, y: -200))
            context.cgContext.addLine(to: CGPoint(x: 0, y: -120))
            
            // N
            context.cgContext.move(to: CGPoint(x: 25, y: -120))
            context.cgContext.addLine(to: CGPoint(x: 25, y: -200))
            context.cgContext.addLine(to: CGPoint(x: 75, y: -120))
            context.cgContext.addLine(to: CGPoint(x: 75, y: -200))
            
            context.cgContext.drawPath(using: .fillStroke)
        }
        
        imageView.image = image
    }
}
