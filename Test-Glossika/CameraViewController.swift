//
//  CameraViewController.swift
//  Test-Glossika
//
//  Created by Wei Kuo on 2021/3/28.
//

import UIKit
import AVFoundation


class CameraViewController: UIViewController {
    
    var player: AVPlayer?
    var playButton = PlayButton()
    
    let captureView = UIView(frame: .zero)
    
    // AV
    let session = AVCaptureSession()
    let output = AVCaptureMovieFileOutput()
    
    // Layer
    var previewLayer:AVCaptureVideoPreviewLayer?
    var playerLayer: AVPlayerLayer?
    
    // UI
    let topView = UIView(frame: .zero)
    let topStackView = UIStackView(frame: .zero)
    let bottomView = UIView(frame: .zero)
    let overlayLabel1 = UILabel(frame: .zero)
    let overlayLabel2 = UILabel(frame: .zero)
    let overlayFocusView = FocusView()
    let timerLabel = UILabel(frame: .zero)
    let descLabel = UILabel(frame: .zero)
    let recordButton = RecordButton(frame: .zero)
    
    // State
    var isRecordMode = true
    
    var timer: Timer?
    
    init() {
        super.init(nibName: nil, bundle: nil)
        self.view.backgroundColor = .white
        self.modalPresentationStyle = .fullScreen
        
        overlayLabel1.text = "你的手機有拍照功能嗎？"
        overlayLabel1.textColor = .yellow
        overlayLabel1.textAlignment = .center
        
        overlayLabel2.text = "Please press record watch camera, then say the yellow text and press stop when you're done"
        overlayLabel2.font = .systemFont(ofSize: 12)
        overlayLabel2.textColor = .white
        overlayLabel2.textAlignment = .center
        overlayLabel2.numberOfLines = 3
        
        timerLabel.text = "00:00"
        timerLabel.textColor = .white
        timerLabel.backgroundColor = .red
        timerLabel.layer.cornerRadius = 5.0
        
        descLabel.textColor = .white
        descLabel.text = "Tap anywhere to stop"
        
        topView.backgroundColor = .black
        
        topStackView.axis = .horizontal
        topStackView.addArrangedSubview(timerLabel)
        topStackView.addArrangedSubview(descLabel)
        topStackView.setCustomSpacing(10, after: timerLabel)
        topStackView.alignment = .center
        topStackView.distribution = .equalSpacing
        topView.addSubview(topStackView)


        topView.addSubview(overlayLabel1)

        self.view.addSubview(topView)
        
        bottomView.backgroundColor = .black
        bottomView.addSubview(recordButton)
        bottomView.addSubview(playButton)
        self.view.addSubview(bottomView)
        self.view.addSubview(overlayLabel2)
        self.view.addSubview(overlayFocusView)
        
        recordButton.addTarget(self, action: #selector(recordButtonTouch(sender:)), for: .touchUpInside)
        playButton.addTarget(self, action: #selector(playButtonTouch(sender:)), for: .touchUpInside)

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        session.sessionPreset = .hd1280x720
        if let device = AVCaptureDevice.default(.builtInTrueDepthCamera, for: .video, position: .front) {
            try! session.addInput(AVCaptureDeviceInput.init(device: device))
        }
        
        if let device = AVCaptureDevice.default(.builtInMicrophone, for: .audio, position: .unspecified) {
            try! session.addInput(AVCaptureDeviceInput.init(device: device))
        }
        
        session.beginConfiguration()
        output.maxRecordedDuration = .init(value: 40, timescale: 1)
        if let v = output.connection(with: .video) {
            v.videoOrientation = .portrait
            v.isVideoMirrored = false
            v.automaticallyAdjustsVideoMirroring = false
        }

        session.addOutput(output)
        session.commitConfiguration()
        
        self.previewLayer = AVCaptureVideoPreviewLayer(session: session)
        self.previewLayer?.videoGravity = .resizeAspectFill
        if let layer = self.previewLayer {
            self.view.layer.addSublayer(layer)
        }
        
        self.playerLayer = AVPlayerLayer()
        if let layer = self.playerLayer {
            self.view.layer.addSublayer(layer)
        }
        NotificationCenter.default.addObserver(self, selector: #selector(playerFinishPlay(notification:)), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil)
        showStyle()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.previewLayer?.frame = self.view.layer.bounds
        self.playerLayer?.frame = self.view.layer.bounds

        topStackView.snp.remakeConstraints { (make) in
            make.top.equalToSuperview().offset(30)
            make.centerX.equalToSuperview()
        }
        
        overlayLabel1.snp.remakeConstraints { (make) in
            make.top.equalTo(topStackView.snp.bottom).offset(30)
            make.left.right.equalToSuperview()
        }
        topView.snp.remakeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(120)
        }
        
        recordButton.snp.remakeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.width.height.equalTo(80)
        }
        
        playButton.snp.remakeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.width.height.equalTo(80)
        }
        
        bottomView.snp.remakeConstraints { (make) in
            make.bottom.left.right.equalToSuperview()
            make.height.equalTo(140)
        }
        
        overlayLabel2.snp.remakeConstraints { (make) in
            make.bottom.equalToSuperview().offset(-20)
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
        }
        
        overlayFocusView.snp.remakeConstraints { (make) in
            make.width.height.equalTo(300)
            make.center.equalToSuperview()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        session.startRunning()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        session.stopRunning()
    }
    
    // MARK: Layout
    func showStyle() {
        if isRecordMode {
           setRecordMode()
        } else {
           setPlayerMode()
        }
    }
    
    func setRecordMode() {
        isRecordMode = true
        self.playButton.isHidden = true
        self.recordButton.isHidden = false
        self.playerLayer?.isHidden = true
        self.previewLayer?.isHidden = false
    }
    
    func setPlayerMode() {
        isRecordMode = false
        self.playButton.isHidden = false
        self.recordButton.isHidden = true
        self.playerLayer?.isHidden = false
        self.previewLayer?.isHidden = true
    }
    
    // MARK: IBAction
    @objc func recordButtonTouch(sender: RecordButton) {
        if isRecordMode {
            if output.isRecording {
                sender.isRecord = false
                output.stopRecording()
                timer?.invalidate()
            } else {
                sender.isRecord = true
                let tempFolder = NSHomeDirectory()
                let fileURL = URL(fileURLWithPath: tempFolder + "/Documents/temp.mov")
                output.startRecording(to: fileURL, recordingDelegate: self)
                timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true, block: recordTimeDisplay(timer:))
            }
        } else {
            player?.play()
        }
    }
    
    @objc func playButtonTouch(sender: PlayButton) {
        if sender.isOn {
            sender.isOn = false
            player?.pause()
        } else {
            sender.isOn = true
            player?.play()
        }
    }
    
    // MARK: Display
    func recordTimeDisplay(timer:Timer) {
        let time = output.recordedDuration
        let seconds = time.seconds
        timerLabel.text = String(format: "%.2d:%.2d", Int(seconds / 60), Int(seconds.truncatingRemainder(dividingBy: 60)))
    }
    
    @objc func playerFinishPlay(notification:Notification) {
        print("playerFinishPlay")
        self.player?.seek(to: .init(seconds: 0, preferredTimescale: 1))
        playButton.isOn = false
    }
}


extension CameraViewController: AVCaptureFileOutputRecordingDelegate {
    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
        print(outputFileURL, error.debugDescription)
        self.player = AVPlayer(url: outputFileURL)
        self.playerLayer?.player = player
        setPlayerMode()
    }
    
    
}
