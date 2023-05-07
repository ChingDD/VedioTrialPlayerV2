//
//  ViewController.swift
//  pageChange
//
//  Created by JeffApp on 2023/5/5.
//

import UIKit
import AVKit
class ViewController: UIViewController {
    
    @IBOutlet weak var dramaCoverImageView: UIImageView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    @IBOutlet weak var dramaNameLabel: UILabel!
    
    @IBOutlet weak var releaseDateLabel: UILabel!
    
    var introTextView:UITextView!
    
    @IBOutlet weak var dramaSegmentControl: UISegmentedControl!
    
    @IBOutlet weak var introSegmentControl: UISegmentedControl!
    //建在全域，避免被清掉
    var vedioPlayerController = AVPlayerViewController()
    //建立播放預告片的按鈕物件，建全域是因為很多function會用到
    var playTrialButton = UIButton(type: .system)
    //建立scrollView物件，建全域是因為很多function會用到
    var introScrollView = UIScrollView(frame: CGRect(x: 24, y: 674, width: 344, height: 144))
    //建立影片資料
    let dramas = [
        [
            Drama(dramaName: "First Love 初戀", intro: "年輕、自由、瘋狂墜入愛河。對於青少年時期的他們來說，世界是能盡情揮灑的舞台。然而成年之後，他們的生活變得黯淡無光，彷彿缺了非常重要的一塊。", releaseDate: "2022年", trial: "初戀預告片"),
            Drama(dramaName: "我家的故事", intro: "隸屬於弱小摔角團體的職業摔跤手觀山壽一，在能樂師同時也是人類國寶的父親病危之際，壽一回到了20多年沒聯絡的老家，圍繞看護和遺產繼承問題，與家人和神秘的女性家護展開了鬥爭..", releaseDate: "2021年", trial: "我家的故事預告片"),
            Drama(dramaName: "相撲聖域", intro: "個性強悍又拼命的孩子成了相撲選手，他狂妄的態度吸引到一群粉絲，卻也惹毛了講究傳統的業界。", releaseDate: "2023年", trial: "相撲聖域預告片"),
            Drama(dramaName: "AV帝王", intro: "故事講述成人影片（AV）導演村西透的起伏人生，在日本繁榮的1980年代，他徹底改變了日本成人影片產業。", releaseDate: "2021年", trial: "AV帝王預告片"),
            Drama(dramaName: "今際之國的闖關者", intro: "改編自同名小說的劇集，講述了一群人穿越到異世界的故事，他們必須通過各種關卡才能生存下去。", releaseDate: "2020年", trial: "今際之國的闖關者預告片")
        ],
        
        [
            Drama(dramaName: "模仿犯", intro: "故事背景設定在1990年代的台灣，描述檢察官郭曉其面臨一宗連環謀殺案的調查。。", releaseDate: "2023年", trial: "模仿犯預告片"),
            Drama(dramaName: "華燈初上", intro: " 羅雨儂和蘇慶儀的故事在她們還是女孩的時候 就已經開始了。生長背景與個性天差地別的兩人，命運卻將她們緊緊綁在一起 她們合力頂下一間在林森北路條通的酒店 「 光 」。 原本以為這家店將會承載她們人生最華美的燦爛時光 無奈一個叫江瀚的男子出現，打亂了她們原本的生命軌跡 ..", releaseDate: "2021年", trial: "華燈初上預告片"),
            Drama(dramaName: "她和她的她", intro: "描述一名在職場上很成功的女子在車禍醒來後，發現世界變得不一樣，這一切又似乎與她國中老師遭殺害的事件有關。", releaseDate: "2022年", trial: "她和她的她預告片"),
            Drama(dramaName: "茶金", intro: "以1950年代為背景，述說新竹北埔的客家茶產業，如何在爾虞我詐的商場中，面對強大競爭起落浮沉，靠著茶業創造經濟奇蹟為題材。。", releaseDate: "2021年", trial: "茶金預告片"),
            Drama(dramaName: "比悲傷更悲傷的故事", intro: "講述一名患有絕症的男子打算幫助心愛之人找到長久伴侶。", releaseDate: "2021年", trial: "比悲傷更悲傷的故事預告片")
           ]
    ]
   //讓程式知道現在要播哪個影片資料
    var index = 0
    //MARK: - 建立introTextView樣式
    fileprivate func setIntroTextView() {
        introTextView = UITextView()
        introTextView.frame = CGRect(x: 0, y: 0, width: introScrollView.frame.width, height: introScrollView.frame.height)
        introTextView.font = UIFont.boldSystemFont(ofSize: 20)
        introTextView.textColor = .white
        introTextView.backgroundColor = .clear
        introTextView.isPagingEnabled = false
        introTextView.isEditable = false
        introScrollView.addSubview(introTextView)
    }
    //MARK: - trialButton樣式
    func setTrialButton(){
        //設定播放符號
        let playSymbol = UIImageView(frame: CGRect(x: introScrollView.frame.width/2-25, y: introScrollView.frame.height/2-25, width: 50, height: 50))
        playSymbol.image = UIImage(systemName: "play.circle")
        playSymbol.tintColor = .white
        playTrialButton.addSubview(playSymbol)
        
        //設定按鈕內容
        var config = UIButton.Configuration.plain()
        config.background.image = UIImage(named: "")
        config.background.imageContentMode = .scaleAspectFill
        playTrialButton.configuration = config
        playTrialButton.frame = introTextView.frame.offsetBy(dx: introScrollView.frame.width, dy: 0)
        playTrialButton.backgroundColor = .clear
        playTrialButton.addTarget(self, action: #selector(clickButton), for: .touchUpInside)
        introScrollView.addSubview(playTrialButton)
    }
    
    //按鈕觸發後的function
    //這邊不能把currentTypeOfDrama放參數，好像跟@objc有關係
    @objc func clickButton(){
        let currentTypeOfDrama = dramas[dramaSegmentControl.selectedSegmentIndex]
        let url = Bundle.main.url(forResource: currentTypeOfDrama[index].dramaName, withExtension: "mp4")
        let vedioPlayer = AVPlayer(url: url!)
        vedioPlayerController.player = vedioPlayer
        present(vedioPlayerController, animated: true) {
            self.vedioPlayerController.player!.play()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //先記錄dramaCoverImageView的大小而已，方便後續使用
        let dramaCoverImageViewSize = dramaCoverImageView.frame
        //MARK: - 設定pageControl的樣式
        pageControl.currentPage = index
        pageControl.frame.size = CGSize(width: dramaCoverImageViewSize.width, height: pageControl.frame.height)
        pageControl.frame = pageControl.frame.offsetBy(dx: view.frame.width/2-pageControl.frame.width/2, dy: dramaCoverImageViewSize.maxY-pageControl.frame.size.height)
        //MARK: - 設定dramaCoverImageView的樣式
        dramaCoverImageView.contentMode = .scaleAspectFill
        //MARK: - 設定dramaNameLabel的樣式
        dramaNameLabel.frame.size = CGSize(width: dramaCoverImageViewSize.width, height: dramaNameLabel.frame.height)
        //MARK: - 設定releaseDateLabel的樣式
        releaseDateLabel.frame.size = CGSize(width: dramaCoverImageViewSize.width, height: releaseDateLabel.frame.height)
        //MARK: - 設定切換預告模式segment的樣式
        //設定被選擇前的字體大小與顏色
        introSegmentControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor : UIColor.white,NSAttributedString.Key.font : UIFont.italicSystemFont(ofSize: 17)], for: .normal)
        //設定被選擇後的字體大小與顏色
        introSegmentControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor : UIColor.white, NSAttributedString.Key.font:UIFont.boldSystemFont(ofSize: 17)], for: .selected)
        introSegmentControl.backgroundColor = .clear
        introSegmentControl.selectedSegmentTintColor = .clear
        
        //MARK: - 設定scrollView的內容
        introScrollView.contentSize = CGSize(width: introScrollView.frame.width*2, height: introScrollView.frame.height)
        introScrollView.isPagingEnabled = true
        view.addSubview(introScrollView)
        //MARK: - 將影片資訊初始化
        //將IntroTextView以及TrialButton初始化，便可在ViewDidLoad執行時將物件顯示在畫面上
        setIntroTextView()
        setTrialButton()
        //將影片資訊初始化，便可在ViewDidLoad執行時將資訊都顯示在物件上
        dramaChange()

    
        }
    //MARK: - 更換影片訊息
    fileprivate func dramaChange() {
        //目前是台劇還是日劇
        let currentTypeOfDrama = dramas[dramaSegmentControl.selectedSegmentIndex]
        //目前是台劇或日劇裡的哪一部
        let currentDrama = currentTypeOfDrama[index]
        //改封面
        dramaCoverImageView.image = UIImage(named: currentTypeOfDrama[index].dramaName)
        //改戲劇名稱
        dramaNameLabel.text = currentTypeOfDrama[index].dramaName
        //改播出日期
        releaseDateLabel.text = currentTypeOfDrama[index].releaseDate
        //改播簡介還是預告片
        if introSegmentControl.selectedSegmentIndex == 0{
            let currentRect = introTextView.frame
            introScrollView.scrollRectToVisible(currentRect, animated: true)
            introTextView.text = currentTypeOfDrama[index].intro
        }else{
            let currentRect = playTrialButton.frame
            introScrollView.scrollRectToVisible(currentRect, animated: true)
            playTrialButton.configuration?.background.image = UIImage(named: currentTypeOfDrama[index].trial)
            
        }
    }
    
    //MARK: - 其他IBAction的程式碼：
    //按下切換日劇台劇的segment contro時會做的事
    @IBAction func dramaTypeChange(_ sender: UISegmentedControl) {
        dramaChange()
    }
    
    //下一部
    @IBAction func nextButton(_ sender: UIButton) {
        let currentTypeOfDrama = dramas[dramaSegmentControl.selectedSegmentIndex]
        index = (index+1) % currentTypeOfDrama.count
        //更換影片訊息
        dramaChange()
        //要把index回傳到pageSegmentControl，這樣小圓點才會一起動
        pageControl.currentPage = index

    }
    
   
    //上一部
    @IBAction func backButton(_ sender: UIButton) {
        let currentTypeOfDrama = dramas[dramaSegmentControl.selectedSegmentIndex]
        index = (index-1+currentTypeOfDrama.count) % currentTypeOfDrama.count
        //更換影片訊息
        dramaChange()
        //要把index回傳到pageSegmentControl，這樣小圓點才會一起動
        pageControl.currentPage = index

    }
    
    @IBAction func pageChangeControl(_ sender: UIPageControl) {
        //將目前的移動後的位置回存index
        index = sender.currentPage
        //再啟動這個function，他會讀到回存後的index，就可以改變影片資訊
        dramaChange()
        
    }
    
    @IBAction func introTypeChange(_ sender: UISegmentedControl) {
        //更換影片訊息
        dramaChange()
    }
    
}

