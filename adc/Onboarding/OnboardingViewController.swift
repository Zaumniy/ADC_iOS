//
//  OnboardingViewController.swift
//  adc
//
//  Created by SitdikovIR on 18.06.2024.
//

import UIKit

class OnboardingViewController: UIViewController {
    
    private var scrollView: UIScrollView!
    private var pageControl: UIPageControl!
    private var nextButton: UIButton!
    private var skipButton: UIButton!
    private var pageImageView: UIImageView!
    private var loginButton: UIButton!
    private var registerButton: UIButton!
    
    private let images = ["image1", "image2", "image3", "image4"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
    }
    
    private func setupViews() {
        scrollView = UIScrollView()
        scrollView.isPagingEnabled = true
        scrollView.contentSize = CGSize(width: view.bounds.width * CGFloat(images.count), height: view.bounds.height)
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.delegate = self
        view.addSubview(scrollView)

        pageControl = UIPageControl()
        pageControl.numberOfPages = images.count
        pageControl.currentPage = 0
        pageControl.pageIndicatorTintColor = .lightGray
        pageControl.currentPageIndicatorTintColor = .white
        pageControl.addTarget(self, action: #selector(pageControlChanged), for: .valueChanged)
        view.addSubview(pageControl)
        
        nextButton = UIButton(type: .system)
        nextButton.setTitle("Далее >", for: .normal)
        nextButton.setTitleColor(.white, for: .normal)
        nextButton.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
        view.addSubview(nextButton)
        
        skipButton = UIButton(type: .system)
        skipButton.setTitle("Пропустить", for: .normal)
        skipButton.setTitleColor(.white, for: .normal)
        skipButton.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        skipButton.addTarget(self, action: #selector(skipButtonTapped), for: .touchUpInside)
        view.addSubview(skipButton)
        
        loginButton = UIButton(type: .system)
        loginButton.backgroundColor = .white
        loginButton.setTitle("Войти", for: .normal)
        loginButton.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        loginButton.titleLabel?.textAlignment = .center
        loginButton.setTitleColor(.loginText, for: .normal)
        loginButton.layer.cornerRadius = 7
        loginButton.isHidden = true
        loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        view.addSubview(loginButton)
        
        registerButton = UIButton(type: .system)
        registerButton.setTitle("Зарегистрироваться", for: .normal)
        registerButton.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        registerButton.backgroundColor = .registrationButton
        registerButton.setTitleColor(.white, for: .normal)
        registerButton.isHidden = true
        registerButton.layer.cornerRadius = 7
        view.addSubview(registerButton)
    }
    
    private func setupConstraints() {
        
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        for i in 0..<images.count {
            let page = UIView()
            scrollView.addSubview(page)
            page.snp.makeConstraints { make in
                make.width.height.equalToSuperview()
                make.leading.equalTo(scrollView.snp.leading).offset(CGFloat(i) * view.bounds.width)
                make.top.equalToSuperview()
            }
            
            pageImageView = UIImageView()
            pageImageView.contentMode = .scaleAspectFill
            pageImageView.image = UIImage(named: images[i])
            page.addSubview(pageImageView)
            
            pageImageView.snp.makeConstraints { make in
                make.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(71)
                make.leading.trailing.equalToSuperview()
                make.width.equalTo(360)
                make.height.equalTo(333)
            }
        }
        
        pageControl.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(pageImageView.snp.bottom).offset(160)
        }
        
        nextButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(pageControl.snp.bottom).offset(41)
        }
        
        skipButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(20)
        }
        
        loginButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(54)
            make.bottom.equalTo(registerButton.snp.top).offset(-12)
        }
        
        registerButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            make.height.equalTo(54)
        }
    }
    
    @objc
    private func pageControlChanged(_ sender: UIPageControl) {
        let x = CGFloat(sender.currentPage) * view.bounds.width
        scrollView.setContentOffset(CGPoint(x: x, y: 0), animated: true)
    }
    
    @objc
    private func nextButtonTapped() {
        let nextPage = pageControl.currentPage + 1
        if nextPage < images.count {
            let x = CGFloat(nextPage) * view.bounds.width
            scrollView.setContentOffset(CGPoint(x: x, y: 0), animated: true)
            pageControl.currentPage = nextPage
        }
    }
    
    @objc
    private func skipButtonTapped() {
        let lastPageIndex = pageControl.numberOfPages - 1
        let x = CGFloat(lastPageIndex) * view.bounds.width
        scrollView.setContentOffset(CGPoint(x: x, y: 0), animated: true)
        pageControl.currentPage = lastPageIndex
    }
    
    @objc
    private func loginButtonTapped() {
        let vc = LoginViewController()
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
}

// MARK: - UIScrollViewDelegate

extension OnboardingViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageIndex = round(scrollView.contentOffset.x / view.bounds.width)
        pageControl.currentPage = Int(pageIndex)
        
        let isLastPage = Int(pageIndex) == images.count - 1
        nextButton.isHidden = isLastPage
        skipButton.isHidden = isLastPage
        loginButton.isHidden = !isLastPage
        registerButton.isHidden = !isLastPage
    }
}
