//
//  ViewController.swift
//  Test-Glossika
//
//  Created by Wei Kuo on 2021/3/25.
//

import UIKit
import SnapKit

class ViewController: UIViewController {
    var cameraButton = UIButton(frame: .zero)
    
    var timer:Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        cameraButton.setTitle("Take video", for: .normal)
        cameraButton.setTitleColor(.systemBlue, for: .normal)
        cameraButton.addTarget(self, action: #selector(cameraButtonTouch(sender:)), for: .touchUpInside)
        
        self.view.addSubview(cameraButton)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        cameraButton.snp.remakeConstraints { (make) in
            make.height.width.equalTo(100)
            make.center.equalToSuperview()
        }
    }
    
    @objc func cameraButtonTouch(sender:UIButton) {
        self.present(CameraViewController(), animated: false, completion: nil)
    }
}


extension ViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
    }
}
