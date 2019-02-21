//
//  MusicView.swift
//  Workout
//
//  Created by francis on 2019/2/18.
//  Copyright © 2019年 francis. All rights reserved.
//

import Foundation
import UIKit
import StoreKit
import Alamofire
import MediaPlayer
class MusicViewController: UIViewController,UITableViewDelegate,UITableViewDataSource{
    //组件区域
    @IBAction func startShuffle(_ sender: Any) {
    }
    @IBOutlet weak var networkStatus: UILabel!
    @IBOutlet weak var musicStatus: UILabel!
    @IBOutlet weak var musicStatusColor: UIImageView!
    @IBOutlet weak var playlist: UITableView!
    @IBOutlet weak var albumArtwork: UIImageView!
    @IBOutlet weak var songName: UILabel!
    @IBOutlet weak var songArtist: UILabel!
    @IBAction func preSong(_ sender: Any) {
        musicPlayer.skipToPreviousItem()
    }
    @IBAction func songPauseContinue(_ sender: Any) {
        if(musicPlayer.playbackState == MPMusicPlaybackState.paused){musicPlayer.play()}
        else{musicPlayer.pause()}
    }
    @IBOutlet weak var pauseContinueBtn: UIButton!
    @IBAction func nextSong(_ sender: Any) {
        musicPlayer.skipToNextItem()
    }
    @IBOutlet weak var PlaylistTableView: UITableView!
    //变量
    let networkManager = NetworkReachabilityManager.init(host: "www.apple.com")
    lazy var networkStatusPicOK = UIImage(named: "Status OK")!
    lazy var networkStatusWarnning = UIImage(named: "Status Warnning")!
    lazy var networkStatusError = UIImage(named: "Status Error")!
    var authorizationStatus = SKCloudServiceAuthorizationStatus.notDetermined
    lazy var musicPlayLists:[MPMediaItemCollection] = []
    lazy var playlistPlay = UIImage(named: "Playlist Play")
    lazy var playlistPause = UIImage(named: "Playlist Pause")
    lazy var artworkDefaultImage = UIImage(named: "Default Image")
    lazy var playerplaying = UIImage(named: "Music Playing")
    lazy var playerPause = UIImage(named: "Music Pause")
    lazy var musicPlayer = MPMusicPlayerController.systemMusicPlayer
    let musicNotifyCenter = NotificationCenter.default
    let UIImageViewRadius = CGFloat.init(8)
    //
    override func viewDidLoad() {
        super.viewDidLoad()
        //网络状态监视器
        networkManager!.listener = {status in
            switch status {
            case .reachable(NetworkReachabilityManager.ConnectionType.ethernetOrWiFi):
                self.networkStatus.text = "Wi-Fi"
            case .reachable(NetworkReachabilityManager.ConnectionType.wwan):
                self.networkStatus.text = "Cellular"
            default:
                self.networkStatus.text = "Offline"
                self.musicStatusColor.image = self.networkStatusError
                self.musicStatus.text = "No Connection"
            }
        }
        networkManager!.startListening()
        //Authorization apple music
        authorizationStatus = SKCloudServiceController.authorizationStatus()
        //
        if authorizationStatus == SKCloudServiceAuthorizationStatus.authorized {
            print("Authorization passed")
            let query = MPMediaQuery.playlists()
            if query.collections == nil {}else{self.musicPlayLists = query.collections!}
            playlist.reloadData()
        }else{
            SKCloudServiceController.requestAuthorization(){(SKstatus)->Void in
                self.authorizationStatus = SKstatus
                if(SKstatus == SKCloudServiceAuthorizationStatus.authorized){
                    let query = MPMediaQuery.playlists()
                    if query.collections == nil {}else{self.musicPlayLists = query.collections!}
                    self.playlist.reloadData()
                    print("Authorized")
                }else if(SKstatus == SKCloudServiceAuthorizationStatus.denied){
                    print("Denied")
                }else{
                    print("Else")
                }
            }
        }
        //configure tableview
        playlist.delegate = self
        playlist.dataSource = self
        //Register music state change notification center
        musicNotifyCenter.addObserver(self, selector: #selector(musicPlayerStateChange), name: NSNotification.Name.MPMusicPlayerControllerPlaybackStateDidChange, object: nil)
        musicNotifyCenter.addObserver(self, selector: #selector(musicPlayingItemChange), name: NSNotification.Name.MPMusicPlayerControllerNowPlayingItemDidChange, object: nil)
        //设置圆角
        albumArtwork.layer.masksToBounds = true
        albumArtwork.layer.cornerRadius = UIImageViewRadius
        //
    }//end of viewDidLoad()
    //
    //Playlist UITableView Method
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return musicPlayLists.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "playlist") as! playlistTableViewCell
        let playlist = musicPlayLists[indexPath.row]
        let artworkSize = CGSize.init(width: 60, height: 60)
        let artwork = playlist.representativeItem?.artwork
        cell.playlistName.text = playlist.value(forProperty: MPMediaPlaylistPropertyName) as? String
        cell.songCount.text = "\(playlist.count) Songs"
        cell.artwork.layer.masksToBounds = true
        cell.artwork.layer.cornerRadius = UIImageViewRadius
        if(artwork == nil){cell.artwork.image = artworkDefaultImage}else{
            cell.artwork.image = artwork!.image(at: artworkSize)
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        musicPlayer.setQueue(with: musicPlayLists[indexPath.row])
        musicPlayer.prepareToPlay(completionHandler: {(error)->Void in
            if(error != nil){print(error!)}
        })
    }
    //Player Method
    //Playing state change
    @objc func musicPlayerStateChange(notif:NSNotification){
        if(musicPlayer.nowPlayingItem != nil){
            self.pauseContinueBtn.setImage(musicPlayer.playbackState == MPMusicPlaybackState.playing ? playerplaying:playerPause, for: UIControl.State.normal)
        }else{
            self.pauseContinueBtn.setImage(playerplaying, for: UIControl.State.normal)
        }
    }
    @objc func musicPlayingItemChange(notif:NSNotification){
        if(musicPlayer.nowPlayingItem == nil){
            self.songName.text = ""
            self.songArtist.text = ""
        }else{
            self.songName.text = musicPlayer.nowPlayingItem!.title!
            self.songArtist.text = musicPlayer.nowPlayingItem!.artist!
        }
        if(musicPlayer.nowPlayingItem == nil || musicPlayer.nowPlayingItem!.artwork == nil){self.albumArtwork.image = self.artworkDefaultImage}else{
            self.albumArtwork.image = musicPlayer.nowPlayingItem!.artwork!.image(at: CGSize.init(width: 60, height: 60))
        }
    }
}

class playlistTableViewCell:UITableViewCell{
    @IBOutlet weak var playlistName: UILabel!
    @IBOutlet weak var songCount: UILabel!
    @IBOutlet weak var artwork: UIImageView!
}

