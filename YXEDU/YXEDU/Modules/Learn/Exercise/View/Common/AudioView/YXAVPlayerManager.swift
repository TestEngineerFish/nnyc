//
//  YXAVPlayerManager.swift
//  YXEDU
//
//  Created by 沙庭宇 on 2019/11/5.
//  Copyright © 2019 shiji. All rights reserved.
//

import AVFoundation

protocol YXAVPlayerProtocol: NSObjectProtocol {
    func playFinished()
}

class YXAVPlayerManager: NSObject {

    typealias FinishedBlock = ()->Void
    var isPlaying = false

    var player: AVPlayer = {
        let player = AVPlayer()
//        player.volume = 1.0
        return player
    }()

    var sourceList: [String] = []
    var sourceIndex: Int     = 0
    var finishedBlock:FinishedBlock?
    weak var delegate: YXAVPlayerProtocol?
    let rightAudioPath = Bundle.main.path(forResource: "right", ofType: "mp3")
    let wrongAudioPath = Bundle.main.path(forResource: "wrong", ofType: "mp3")

    static let share = YXAVPlayerManager()
    
    override init() {
        super.init()
        self.addObservers()
    }
    
    deinit {
        self.removeObservers()
    }

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
            try? AVAudioSession.sharedInstance().setCategory(.playback)
            if let error = self.player.error {
                YXLog("语音播放加载失败：", error)
                self.player = AVPlayer()
            }
            self.player.replaceCurrentItem(with: playerItem)
            self.player.seek(to: .zero)
            self.player.play()
            self.isPlaying = true
        } else {
            YXLog("无效音频,地址：" + url.absoluteString)
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
            self.isPlaying = false
            self.player.pause()
        }
    }


    // MARK: Observer
    /// 添加监听
    private func addObservers() {
//        let playerItem = self.player.currentItem
        // 添加播放完成后通知事件
        NotificationCenter.default.addObserver(self, selector: #selector(playFinished), name: Notification.Name.AVPlayerItemDidPlayToEndTime, object: nil)
    }

    /// 移除监听
    private func removeObservers() {
        NotificationCenter.default.removeObserver(self, name: Notification.Name.AVPlayerItemDidPlayToEndTime, object: nil)
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
            self.delegate?.playFinished()
        } else {
            guard let url = URL(string: self.sourceList[sourceIndex]) else {
                return
            }
            self.play(url)
        }
    }
    
    /// TODO: ---- Tools ----


    /// 是否正在播放学习结果音频
    /// - Returns: 是否在播放
    func isPlayingResult() -> Bool {
        if self.isPlaying && ((self.player.currentItem?.asset as? AVURLAsset)?.url.absoluteString.hasSuffix(rightAudioPath ?? "") == .some(true) || (self.player.currentItem?.asset as? AVURLAsset)?.url.absoluteString.hasSuffix(wrongAudioPath ?? "") == .some(true)) {
            return true
        } else {
            return false
        }
    }

    /// 播放答题正确音效
    func playRightAudio() {
        guard let path = rightAudioPath else {
            return
        }
        let url = URL(fileURLWithPath: path)
        YXAVPlayerManager.share.playAudio(url)
    }

    /// 播放答题错误音效
    func playWrongAudio() {
        guard let path = wrongAudioPath else {
            return
        }
        let url = URL(fileURLWithPath: path)
        YXAVPlayerManager.share.playAudio(url)
    }
    
    /// 播放一颗星音效
    func playStar1() {
        guard let path = Bundle.main.path(forResource: "star1", ofType: "mp3") else {
            return
        }
        let url = URL(fileURLWithPath: path)
        YXAVPlayerManager.share.playAudio(url)
    }
    
    /// 播放两颗星音效
    func playStar2() {
        guard let path = Bundle.main.path(forResource: "star2", ofType: "mp3") else {
            return
        }
        let url = URL(fileURLWithPath: path)
        YXAVPlayerManager.share.playAudio(url)
    }
    
    /// 播放三颗星音效
    func playStar3() {
        guard let path = Bundle.main.path(forResource: "star3", ofType: "mp3") else {
            return
        }
        let url = URL(fileURLWithPath: path)
        YXAVPlayerManager.share.playAudio(url)
    }

}
