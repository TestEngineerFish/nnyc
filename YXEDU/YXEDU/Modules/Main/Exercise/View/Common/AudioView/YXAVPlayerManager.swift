//
//  YXAVPlayerManager.swift
//  YXEDU
//
//  Created by 沙庭宇 on 2019/11/5.
//  Copyright © 2019 shiji. All rights reserved.
//

import AVFoundation

class YXAVPlayerManager: NSObject {

    typealias FinishedBlock = ()->Void
    var isPlaying = false

    var player: AVPlayer = {
        let player = AVPlayer()
        player.volume = 1.0
        
        if #available(iOS 10.0, *) {
            do {// 静音键打开的时候，播放也需要有声音
                let session = AVAudioSession.sharedInstance()
                try session.setCategory(.playback, mode: .default, options: [])
            } catch _ as NSError {
            }
        }
        
        return player
    }()

    var sourceList: [String] = []
    var sourceIndex: Int     = 0
    var finishedBlock:FinishedBlock?

    static let share = YXAVPlayerManager()

    /// 播放音频(移除掉)
    func playAudio(_ url: URL, finish block: FinishedBlock? = nil) {
        if self.finishedBlock != nil {
            self.finishedBlock?()
        }
        self.finishedBlock = block
        self.play(url)
    }

    /// 播放音频
    func play(_ url: URL) {
        let playerItem = YYMediaCache.default.playerItem(url)
        if playerItem.asset.isPlayable {
            self.player.replaceCurrentItem(with: playerItem)
            self.player.play()
            self.isPlaying = true
            self.addObservers()
        } else {
            YXUtils.showHUD(kWindow, title: "无效音频")
            YYMediaCache.default.deleteCache(url)
            self.playFinished()
        }
    }

    /// 支持播放一组音频
    func playListAudio(_ sourceList: [String], finished block: FinishedBlock? = nil) {
        self.finishedBlock = block
        self.sourceList    = sourceList
        self.sourceIndex   = 0
        if !sourceList.isEmpty {
            guard let url = URL(string: sourceList[0]) else {
                return
            }
            self.play(url)
        }
    }
    /// 停止播放
    func pauseAudio() {
        if isPlaying {
            self.player.pause()
            self.isPlaying = false
        }
    }


    // MARK: Observer
    /// 添加监听
    private func addObservers() {
        let playerItem = self.player.currentItem
        // 添加播放完成后通知事件
        NotificationCenter.default.addObserver(self, selector: #selector(playFinished), name: Notification.Name.AVPlayerItemDidPlayToEndTime, object: playerItem)
    }

    /// 移除监听
    private func removeObservers() {
        NotificationCenter.default.removeObserver(self, name: Notification.Name.AVPlayerItemDidPlayToEndTime, object: nil)
    }

    deinit {
        self.removeObservers()
    }

    // MARK: Event
    /// 播放结束事件
    @objc private func playFinished() {
        self.sourceIndex += 1
        self.isPlaying = false
        if self.sourceIndex >= self.sourceList.count {
            self.finishedBlock?()
            self.finishedBlock = nil
            self.player.replaceCurrentItem(with: nil)
        } else {
            guard let url = URL(string: self.sourceList[sourceIndex]) else {
                return
            }
            self.play(url)
        }
    }
    
    /// TODO: ---- Tools ----

    /// 播放答题正确音效
    func playRightAudio() {
        guard let path = Bundle.main.path(forResource: "right", ofType: "mp3") else {
            return
        }
        let url = URL(fileURLWithPath: path)
        YXAVPlayerManager.share.playAudio(url)
    }

    /// 播放答题错误音效
    func playWrongAudio() {
        guard let path = Bundle.main.path(forResource: "wrong", ofType: "mp3") else {
            return
        }
        let url = URL(fileURLWithPath: path)
        YXAVPlayerManager.share.playAudio(url)
    }

}
