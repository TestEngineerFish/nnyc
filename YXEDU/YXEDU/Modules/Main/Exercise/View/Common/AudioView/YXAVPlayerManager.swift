//
//  YXAVPlayerManager.swift
//  YXEDU
//
//  Created by 沙庭宇 on 2019/11/5.
//  Copyright © 2019 shiji. All rights reserved.
//

import AVFoundation

class YXAVPlayerManager: NSObject {

    typealias FinishBlock = ()->Void
    var isPlaying = false

    var player: AVPlayer = {
        let player = AVPlayer()
        player.volume = 1.0
        return player
    }()

    var finishBlock:FinishBlock?

    static let share = YXAVPlayerManager()
    /// 播放音频
    func playerAudio(_ url: URL, finish block: FinishBlock? = nil) {
        self.finishBlock = block
        let asset = AVAsset(url: url)
        let playerItem = AVPlayerItem(asset: asset)
        self.player.replaceCurrentItem(with: playerItem)
        self.player.play()
        self.isPlaying = true
        self.addObservers()
    }
    /// 停止播放
    func pauseAudio() {
        self.player.pause()
        self.isPlaying = false
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

    // MARK: Event
    /// 播放结束事件
    @objc private func playFinished() {
        print("播放结束")
        self.isPlaying = false
        self.finishBlock?()
    }

    /// 播放答题正确音效
    func playRightAudio() {
        guard let path = Bundle.main.path(forResource: "right", ofType: "mp3") else {
            return
        }
        let url = URL(fileURLWithPath: path)
        YXAVPlayerManager.share.playerAudio(url)
    }

    /// 播放答题错误音效
    func playWrongAudio() {
        guard let path = Bundle.main.path(forResource: "wrong", ofType: "mp3") else {
            return
        }
        let url = URL(fileURLWithPath: path)
        YXAVPlayerManager.share.playerAudio(url)
    }

}
