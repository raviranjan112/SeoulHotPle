//
//  ChatViewController.swift
//  SeoulHotPle
//
//  Created by KimJingyu on 2017. 2. 17..
//  Copyright © 2017년 SeoulHotPle. All rights reserved.
//

import UIKit
import JSQMessagesViewController
import MobileCoreServices
import AVKit
import FirebaseDatabase
import FirebaseStorage
import FirebaseAuth

class ChatViewController: JSQMessagesViewController, NetworkCallback{
    var messages = [JSQMessage]()
    //각각 사용자별로 챗봇 생성
    var messageRef = FIRDatabase.database().reference().child("messages").child((FIRAuth.auth()?.currentUser?.uid)!)
    var avatarDict = [String: JSQMessagesAvatarImage]()
    
    var cache = NSCache<NSString, NSString>()
    
    var apiServiceModel : APIServiceModel?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        apiServiceModel = APIServiceModel(self)
        
        let capacity = 100 * 1024 * 1024
        URLCache.shared = {
            URLCache(memoryCapacity: capacity, diskCapacity: capacity, diskPath: "myDisk")
        }()
        
        if let currentUser = FIRAuth.auth()?.currentUser {
            self.senderId = currentUser.uid
            
            if currentUser.isAnonymous {
                self.senderDisplayName = Constants.CURRENT_STATION
            } else {
                self.senderDisplayName = "\(currentUser.displayName!)"
            }
        }

        observeMessages()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        do {
            try FIRAuth.auth()?.signOut()
        } catch let error {
            print(error)
        }
    }
    
    func networkResult(resultData: Any, code: Int) {
        print("CODE = \(code)")
    }
    
    func observeUsers(id: String) {
        FIRDatabase.database().reference().child("users").child(id).observe(.value, with: { snapshot in
            if let dict = snapshot.value as? [String: AnyObject] {
                let avatarUrl = dict["profileUrl"] as! String
                self.setupAvatar(url: avatarUrl, messageId: id)
            }
        })
    }
    
    func setupAvatar(url: String, messageId: String) {
        
        if url != "" {
            do {
            let fileUrl = URL(string: url)
            let data = try Data(contentsOf: fileUrl!)
            let image = UIImage(data: data )
            let userImg = JSQMessagesAvatarImageFactory.avatarImage(with: image, diameter: 30)
            avatarDict[messageId] = userImg
            } catch {
                print(error.localizedDescription)
            }
        } else {
            
            avatarDict[messageId] = JSQMessagesAvatarImageFactory.avatarImage(with: UIImage(named: "profileImage"), diameter: 30)
        }
        collectionView.reloadData()
    }
    
    func observeMessages() {
        messageRef.observe(.childAdded, with: { snapshot in
            
            if let dict = snapshot.value as? [String: AnyObject] {
                let mediaType = dict["MediaType"] as! String
                let senderId = dict["senderId"] as! String
                let senderName = dict["senderName"] as! String
                
                self.observeUsers(id: senderId)
                
                switch mediaType {
                    
                case "TEXT":
                    let text = dict["text"] as? String
                    self.messages.append(JSQMessage(senderId: senderId, displayName: senderName, text: text))
                    
                    
                case "PHOTO":
                    
                    let photo = JSQPhotoMediaItem(image: nil)
                    let fileUrl = dict["fileUrl"] as? String
                    
                    DispatchQueue.global().async {
                        do {
                            let data = try Data(contentsOf: URL(string: fileUrl!)!)
                            
                            DispatchQueue.main.async {
                                let picture = UIImage(data: data)
                                photo?.image = picture
                                self.collectionView.reloadData()
                            }
                            
                        } catch {
                            print(error.localizedDescription)
                        }
                    }
                    
                    self.messages.append(JSQMessage(senderId: senderId, displayName: self.senderDisplayName, media: photo))
                    
                    if self.senderId == senderId {
                        photo?.appliesMediaViewMaskAsOutgoing = true
                    } else {
                        photo?.appliesMediaViewMaskAsOutgoing = false
                    }
           
                case "VIDEO":
                    let fileUrl = dict["fileUrl"] as? String
                    let video = NSURL(string: fileUrl!)
                    let videoItem = JSQVideoMediaItem(fileURL: video as URL!, isReadyToPlay: true)
                    self.messages.append(JSQMessage(senderId: senderId, displayName: self.senderDisplayName, media: videoItem))
                    
                    if self.senderId == senderId {
                        videoItem?.appliesMediaViewMaskAsOutgoing = true
                    } else {
                        videoItem?.appliesMediaViewMaskAsOutgoing = false
                    }
                    
                default:
                    print("unknown data type!")
                }
                
                self.collectionView.reloadData()
                
            }
            
        })
    }
    
    //텍스트 메시지 입력
    override func didPressSend(_ button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: Date!) {
        
//        messages.append(JSQMessage(senderId: senderId, displayName: senderDisplayName, text: text))
//        collectionView.reloadData()
        print(messages)
        let newMessage = messageRef.childByAutoId()
        let messageData = ["text": text, "senderId": senderId, "senderName": senderDisplayName, "MediaType": "TEXT"]
        newMessage.setValue(messageData)
        
        //서버에 보내서 챗봇기능
        apiServiceModel?.postMessage()
        
        
        self.finishSendingMessage() //입력창 비우기
    }
    
    //첨부파일 클릭
    override func didPressAccessoryButton(_ sender: UIButton!) {
        
        let alertActionSheet = UIAlertController(title: "Media Messasges", message: "Please select a media", preferredStyle: .actionSheet)
        
        let cancel = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel){ (alert:UIAlertAction) in
        }
        
        let photoLibrary = UIAlertAction(title: "Photo Library", style: UIAlertActionStyle.default) { (alert: UIAlertAction) in
            self.getMediaFrom(type: kUTTypeImage)
        }
        
        let videoLibrary = UIAlertAction(title: "video Library", style: UIAlertActionStyle.default) { (alert: UIAlertAction) in
            self.getMediaFrom(type: kUTTypeMovie)
        }
        
        alertActionSheet.addAction(cancel)
        alertActionSheet.addAction(photoLibrary)
        alertActionSheet.addAction(videoLibrary)
        
        present(alertActionSheet, animated: true)
 
    }
    
    func getMediaFrom(type: CFString) {
        
        let mediaPicker = UIImagePickerController()
        mediaPicker.delegate = self
        mediaPicker.mediaTypes = [type as String]
        self.present(mediaPicker, animated: true)
        
    }
    
    //이미지 터치시 확대기능
    let zoomImageView = UIImageView()
    let blackBackgroundView = UIView()
    var statusImageView: UIImageView?
    
    func animateImageView(_ statusImageView: UIImageView) {
        
        self.statusImageView = statusImageView
        
        if let startingFrame = statusImageView.superview?.convert(statusImageView.frame, to: nil) {
            
            statusImageView.alpha = 0
            
            blackBackgroundView.frame = self.view.frame
            blackBackgroundView.backgroundColor = UIColor.black
            blackBackgroundView.alpha = 0
            view.addSubview(blackBackgroundView)
            
            zoomImageView.frame = startingFrame
            zoomImageView.isUserInteractionEnabled = true
            zoomImageView.image = statusImageView.image
            zoomImageView.contentMode = .scaleAspectFit
            zoomImageView.clipsToBounds = true
            view.addSubview(zoomImageView)
            
            zoomImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(zoomOut)))
            
            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: { () -> Void in
                
                self.zoomImageView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
                self.blackBackgroundView.alpha = 1
                self.navigationController?.setNavigationBarHidden(true, animated: true)
                
            }, completion: nil)
            
        }
    }
    
    func zoomOut() {
        
        if let startingFrame = statusImageView!.superview?.convert(statusImageView!.frame, to: nil) {
            
            UIView.animate(withDuration: 0.3, animations: { () -> Void in
                self.zoomImageView.frame = startingFrame
                self.blackBackgroundView.alpha = 0
                
            }, completion: { (didComplete) -> Void in
                self.zoomImageView.removeFromSuperview()
                self.blackBackgroundView.removeFromSuperview()
                self.statusImageView?.alpha = 1
                self.navigationController?.setNavigationBarHidden(false, animated: true)
                
            })
            
        }
    }
    
    
    //start of collectionView func
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = super.collectionView(collectionView, cellForItemAt: indexPath) as! JSQMessagesCollectionViewCell
        return cell
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageDataForItemAt indexPath: IndexPath!) -> JSQMessageData! {
        return messages[indexPath.item]
    }
    
    //말풍선
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAt indexPath: IndexPath!) -> JSQMessageBubbleImageDataSource! {

        let message = messages[indexPath.item]
        let bubbleFactory = JSQMessagesBubbleImageFactory()
        
        if message.senderId == self.senderId {
            return bubbleFactory?.outgoingMessagesBubbleImage(with: UIColor.black)
        } else {
            return bubbleFactory?.incomingMessagesBubbleImage(with: UIColor.blue)
        }
        
    }
    
    //아바타
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAt indexPath: IndexPath!) -> JSQMessageAvatarImageDataSource! {
        
        let message = messages[indexPath.item]
        
        return avatarDict[message.senderId]
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, didTapMessageBubbleAt indexPath: IndexPath!) {
        let message = messages[indexPath.item]
        if message.isMediaMessage {
            
            if let mediaItem = message.media as? JSQVideoMediaItem {
                
                let player = AVPlayer(url: mediaItem.fileURL)
                let playerViewController = AVPlayerViewController()
                playerViewController.player = player
                present(playerViewController, animated: true)
                
            } else if let mediaItem = message.media as? JSQPhotoMediaItem {
                
                let cell = collectionView.cellForItem(at: indexPath)
                do {
                    let subViews = try cell?.contentView.subviews
                    let imageView = (subViews?[2].subviews[0]) as! UIImageView
                    animateImageView(imageView)
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
    }
    //end of collectionView func
    
    func sendMedia(picture: UIImage?, video: NSURL?) {
        
        if let picture = picture {
            let filePath = "\(FIRAuth.auth()!.currentUser!)/\(NSDate.timeIntervalSinceReferenceDate)"
            print(filePath)
            let data = UIImageJPEGRepresentation(picture, 0.1)
            let metadata = FIRStorageMetadata()
            metadata.contentType = "image/jpg"
            FIRStorage.storage().reference().child(filePath).put(data!, metadata: metadata) { (metadata, error) in
                
                if error != nil {
                    print(error?.localizedDescription)
                }
                
                let fileUrl = metadata?.downloadURLs![0].absoluteString
                
                let newMessage = self.messageRef.childByAutoId()
                let messageData = ["fileUrl": fileUrl, "senderId": self.senderId, "senderName": self.senderDisplayName, "MediaType": "PHOTO"]
                newMessage.setValue(messageData)
                
            }
        }
        
        else if let video = video {
            let filePath = "\(FIRAuth.auth()!.currentUser!)/\(NSDate.timeIntervalSinceReferenceDate)"
            print(filePath)
            let data = NSData(contentsOf: video as URL)
            let metadata = FIRStorageMetadata()
            metadata.contentType = "video/mp4"
            FIRStorage.storage().reference().child(filePath).put(data! as Data, metadata: metadata) {
                (metadata, error) in
                if error != nil {
                    print(error?.localizedDescription)
                }
                
                let fileUrl = metadata?.downloadURLs![0].absoluteString
                
                let newMessage = self.messageRef.childByAutoId()
                let messageData = ["fileUrl": fileUrl, "senderId": self.senderId, "senderName": self.senderDisplayName, "MediaType": "VIDEO"]
                newMessage.setValue(messageData)
                
            }
        }
        
    }
    
}

extension ChatViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        // get the image
        //        messages.append(JSQMessage(senderId: senderId, displayName: senderDisplayName, text: text))
        
        if let picture = info[UIImagePickerControllerOriginalImage] as? UIImage {
            let photo = JSQPhotoMediaItem(image: picture)
            
            messages.append(JSQMessage(senderId: senderId, displayName: senderDisplayName, media: photo))
            sendMedia(picture: picture, video: nil)
        }
            
        else if let video = info[UIImagePickerControllerMediaURL] as? NSURL {
            let videoItem = JSQVideoMediaItem(fileURL: video as URL!, isReadyToPlay: true)
            messages.append(JSQMessage(senderId: senderId, displayName: senderDisplayName, media: videoItem))
            sendMedia(picture: nil, video: video)
        }
        
        self.dismiss(animated: true, completion: nil)
        collectionView.reloadData()
        
    }
}
