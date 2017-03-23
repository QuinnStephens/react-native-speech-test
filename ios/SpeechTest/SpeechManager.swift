//
//  SpeechManager.swift
//  SpeechTest
//
//  Created by Quinn Stephens on 3/23/17.
//  Copyright © 2017 Facebook. All rights reserved.
//

import Foundation
import Speech

@available(iOS 10.0, *)
@objc(SpeechManager)
class SpeechManager: NSObject, SFSpeechRecognizerDelegate {
  
  private let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "en-US"))!
  private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
  private var recognitionTask: SFSpeechRecognitionTask?
  private let audioEngine = AVAudioEngine()
  
  override init() {
    super.init()
    speechRecognizer.delegate = self
  }
  
  @objc func getPermission(_ resolve: @escaping RCTPromiseResolveBlock, reject: @escaping RCTPromiseRejectBlock) {
    SFSpeechRecognizer.requestAuthorization { authStatus in
      /*
       The callback may not be called on the main thread. Add an
       operation to the main queue to update the record button's state.
       */
      OperationQueue.main.addOperation {
        switch authStatus {
        case .authorized:
          resolve("Success!")
          
        case .denied:
          reject(nil, "User denied access to speech recognition", NSError())
          
        case .restricted:
          reject(nil, "Speech recognition restricted on this device", NSError())
          
        case .notDetermined:
          reject(nil, "Speech recognition not yet authorized", NSError())
        }
      }
    }

  }
  
  @objc func startRecording(resolve: @escaping RCTPromiseResolveBlock, reject: @escaping RCTPromiseRejectBlock) throws {
    
    // Cancel the previous task if it's running.
    if let recognitionTask = recognitionTask {
      recognitionTask.cancel()
      self.recognitionTask = nil
    }
    
    let audioSession = AVAudioSession.sharedInstance()
    try audioSession.setCategory(AVAudioSessionCategoryRecord)
    try audioSession.setMode(AVAudioSessionModeMeasurement)
    try audioSession.setActive(true, with: .notifyOthersOnDeactivation)
    
    recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
    
    guard let inputNode = audioEngine.inputNode else { return reject(nil, "Audio engine has no input node", nil) }
    guard let recognitionRequest = recognitionRequest else { return reject(nil, "Unable to created a SFSpeechAudioBufferRecognitionRequest object", nil) }
    
    // Configure request so that results are returned before audio recording is finished
    recognitionRequest.shouldReportPartialResults = true
    
    // A recognition task represents a speech recognition session.
    // We keep a reference to the task so that it can be cancelled.
    recognitionTask = speechRecognizer.recognitionTask(with: recognitionRequest) { result, error in
      guard error == nil else {
        reject(nil, error?.localizedDescription, error)
        return
      }
      
      if let result = result, result.isFinal {
        self.audioEngine.stop()
        inputNode.removeTap(onBus: 0)
        
        self.recognitionRequest = nil
        self.recognitionTask = nil
        
        resolve(result.bestTranscription.formattedString)
      }
    }
    
    let recordingFormat = inputNode.outputFormat(forBus: 0)
    inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer: AVAudioPCMBuffer, when: AVAudioTime) in
      self.recognitionRequest?.append(buffer)
    }
    
    audioEngine.prepare()
    
    try audioEngine.start()
  }
  
  @objc func toggleRecording(_ resolve: @escaping RCTPromiseResolveBlock, reject: @escaping RCTPromiseRejectBlock) {
    if audioEngine.isRunning {
      audioEngine.stop()
      recognitionRequest?.endAudio()
    } else {
      try! startRecording(resolve: resolve, reject: reject)
    }
  }

  // MARK: SFSpeechRecognizerDelegate
  
  @objc func speechRecognizer(_ speechRecognizer: SFSpeechRecognizer, availabilityDidChange available: Bool) {
//    if available {
//      recordButton.isEnabled = true
//      recordButton.setTitle("Start Recording", for: [])
//    } else {
//      recordButton.isEnabled = false
//      recordButton.setTitle("Recognition not available", for: .disabled)
//    }
  }
  
}
