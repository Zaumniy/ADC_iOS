import UIKit
import SnapKit
import SwiftUI

final class MainTabBarController: UITabBarController {

    convenience init() {
        self.init(nibName: nil, bundle: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .background
        setupUI()
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        tabBar.layer.masksToBounds = true
        tabBar.layer.cornerRadius = 16
        tabBar.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }

    private func setupUI() {
        modalPresentationStyle = .fullScreen
        let appearace: UITabBarAppearance = {
            $0.backgroundColor = .tabbar.withAlphaComponent(0.8)
            $0.shadowImage = UIImage()
            $0.stackedLayoutAppearance.normal.titleTextAttributes = [
                .foregroundColor: UIColor.placeholderText
            ]
            $0.stackedLayoutAppearance.selected.titleTextAttributes = [
                .foregroundColor: UIColor.primary
            ]
            $0.stackedLayoutAppearance.normal.iconColor = .placeholderText
            $0.stackedLayoutAppearance.selected.iconColor = .primary
            return $0
        }(UITabBarAppearance())
        tabBar.standardAppearance = appearace
        tabBar.scrollEdgeAppearance = appearace
        
        let blur = UIBlurEffect(style: .regular)
        let vibrancy = UIVibrancyEffect(blurEffect: blur)

        let frost = UIVisualEffectView()
        frost.frame = tabBar.bounds
        frost.autoresizingMask = .flexibleWidth
        frost.effect = vibrancy
        tabBar.insertSubview(frost, at: 0)
        tabBar.isTranslucent = true
    }
}

final class MainListNavBarView: UIView {

    private lazy var segments: ListSegmentedView = {
        let view = ListSegmentedView(frame: .zero)
        return view
    }()

    private lazy var logoImageView: UIImageView = {
        let view = UIImageView(image: .adcLogoMedium)
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
        makeConstraints()
    }

    private func addSubviews() {
        addSubview(logoImageView)
        addSubview(segments)
    }

    private func makeConstraints() {
        logoImageView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(18)
            $0.centerX.equalToSuperview()
        }
        segments.snp.makeConstraints {
            $0.centerX.equalTo(logoImageView)
            $0.top.equalTo(logoImageView.snp.bottom).offset(19)
        }
    }

    override var intrinsicContentSize: CGSize {
        var height = CGFloat()
        height += 18
        height += logoImageView.intrinsicContentSize.height
        height += 19
        height += segments.intrinsicContentSize.height
        let witdh = max(logoImageView.intrinsicContentSize.width, segments.intrinsicContentSize.width)
        return CGSize(width: witdh, height: height)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension MainTabBarController {
    func configureTabBar() {
        let mainListVC = MainListViewController(nibName: nil, bundle: nil)
        mainListVC.tabBarItem = MainTabBarTabType.list.tabBarItem
        mainListVC.navigationItem.titleView = UIImageView(image: .adcLogoMedium)
        let contentView = ListSegmentedView(frame: .zero)
        contentView.sizeToFit()
        contentView.frame = CGRect(origin: .zero, size: CGSize(width: view.frame.width, height: 55))
        let _UINavigationBarPalette = NSClassFromString("_UINavigationBarPalette") as! UIView.Type
        let palette = _UINavigationBarPalette.perform(NSSelectorFromString("alloc"))
            .takeUnretainedValue()
            .perform(NSSelectorFromString("initWithContentView:"), with: contentView)
            .takeUnretainedValue()

        mainListVC.navigationItem.perform(NSSelectorFromString("_setBottomPalette:"), with: palette)

        let searchVC = MainListViewController(nibName: nil, bundle: nil)
        searchVC.tabBarItem = MainTabBarTabType.search.tabBarItem

        let carriersVC = MainListViewController(nibName: nil, bundle: nil)
        carriersVC.tabBarItem = MainTabBarTabType.carriers.tabBarItem

        let showcasesVC = MainListViewController(nibName: nil, bundle: nil)
        showcasesVC.tabBarItem = MainTabBarTabType.showcases.tabBarItem

        let profileVC = ProfileViewController(model: .empty)
        profileVC.tabBarItem = MainTabBarTabType.profile.tabBarItem
        
        let vcs: [UIViewController] = [
            ListNavigationController(rootViewController: mainListVC),
            searchVC,
            carriersVC,
            showcasesVC,
            profileVC
        ]

        setViewControllers(vcs, animated: true)
    }
}

enum MainTabBarTabType: Int {
    case list = 0
    case search
    case carriers
    case showcases
    case profile

    private var title: String {
        switch self {
        case .list: return "Лента"
        case .search: return "Поиск"
        case .carriers: return "Вакансии"
        case .showcases: return "Витрина"
        case .profile: return "Профиль"
        }
    }

    private var icon: UIImage {
        switch self {
        case .list: return .list
        case .search: return .search
        case .carriers: return .careers
        case .showcases: return .star
        case .profile: return .people
        }
    }

    var tabBarItem: UITabBarItem {
        UITabBarItem(title: title, image: icon, tag: rawValue)
    }
}


final class ListNavigationController: UINavigationController {
    override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
        modalPresentationStyle = .fullScreen
    }

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        modalPresentationStyle = .fullScreen
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        modalPresentationStyle = .fullScreen
        navigationBar.isTranslucent = false
        configureNavBar()
    }

    func configureNavBar() {
        navigationBar.largeContentImage = .adcLogoMedium
        let appearanceConfig = UINavigationBarAppearance()
        appearanceConfig.configureWithOpaqueBackground()
        appearanceConfig.backgroundColor = .background
        appearanceConfig.shadowColor = .clear
        appearanceConfig.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.white
        ]
        navigationBar.standardAppearance = appearanceConfig
        navigationBar.scrollEdgeAppearance = appearanceConfig
        navigationBar.shadowImage = UIImage()
        navigationBar.tintColor = .primary
    }
}

final class ListSegmentedView: UIView {
    enum SegmentType: Int, CaseIterable {
        case subscriptions = 0
        case recomendations

        var title: String {
            switch self {
            case .subscriptions:
                return "Подписки"
            case .recomendations:
                return "Рекомендации"
            }
        }
    }

    private lazy var segments: UISegmentedControl = {
        let view = UISegmentedControl(items: ListSegmentedView.SegmentType.allCases.map(\.title))
        view.selectedSegmentTintColor = .primary
        view.setTitleTextAttributes(
            [NSAttributedString.Key.foregroundColor: UIColor.white],
            for: .normal
        )
        view.setTitleTextAttributes(
            [NSAttributedString.Key.foregroundColor: UIColor.black],
            for: .selected
        )
        view.selectedSegmentIndex = 0
        view.addTarget(self, action: #selector(segmentValueChanged), for: .valueChanged)
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        segments.sizeToFit()
        addSubview(segments)
        segments.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(12)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    @objc func segmentValueChanged() {
        print(segments.selectedSegmentIndex)
    }
}

final class MainListViewController: UIViewController {

    private lazy var tableView: UITableView = {
        let view = UITableView(frame: .zero, style: .plain)
        view.backgroundColor = .background
        view.delegate = tableController
        view.dataSource = tableController
        view.register(PostTableViewCell.self, forCellReuseIdentifier: PostTableViewCell.identifier)
        view.separatorInset = .zero
        return view
    }()

    private lazy var plusButton: UIButton = {
        let view = UIButton(frame: .zero)
        view.setImage(.plusBtn, for: .normal)
        return view
    }()

    private lazy var tableController: TableViewController = {
        let controller = TableViewController(posts: self.data)
        controller.onScroll = { [weak self] scrollView in
            print(scrollView.contentOffset)
        }
        controller.onProfileTapped = { [weak self] in
            self?.showProfile()
        }
        controller.scrollViewWillBeginDecelerating =  { [weak self] in
            self?.handlePlusButton(isVisible: false)
        }
        controller.scrollViewDidEndDecelerating =  { [weak self] in
            self?.handlePlusButton(isVisible: true)
        }
        return controller
    }()

    let data = Post.stubs

    var yTableOffset = CGFloat()

    func showProfile() {
        let vc = ProfileViewController(model: .test)
        navigationController?.pushViewController(vc, animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        addSubviews()
        makeConstraints()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.navigationBar.isHidden = false

    }

    private func addSubviews() {
        view.addSubview(tableView)
        view.addSubview(plusButton)
    }

    func handlePlusButton(isVisible: Bool) {
        plusButton.snp.updateConstraints {
            if isVisible {
                $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(18)
            } else {
                $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(100)
            }
        }
        UIView.animate(withDuration: 0.4) {
            self.view.layoutIfNeeded()
        }
    }

    private func makeConstraints() {
        tableView.snp.makeConstraints { $0.edges.equalToSuperview() }
        plusButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(15)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(18)
        }
    }
}

class TableViewController: NSObject, UITableViewDataSource, UITableViewDelegate {
    let posts: [Post]
    init(posts: [Post]) {
        self.posts = posts
    }

    var heightCache: [Post: CGFloat] = [:]

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        posts.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let post = posts[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: PostTableViewCell.identifier, for: indexPath)
        let _cell = (cell as! PostTableViewCell)
        _cell.set(postModel: post)
        _cell.headerView.onNameTap = { [weak self] in
            self?.onProfileTapped?()
        }
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let post = posts[indexPath.row]
        if let cachedHeight = heightCache[post] {
            return cachedHeight
        }

        let dummy = PostTableViewCell()
        dummy.set(postModel: post)
        let height = dummy.sizeThatFits(CGSize(width: tableView.bounds.width, height: .greatestFiniteMagnitude)).height
        heightCache[post] = height
        return height
    }

    var onScroll: ((UIScrollView) -> Void)?
    var onProfileTapped: (() -> Void)?
    var scrollViewWillBeginDecelerating: (() -> Void)?
    var scrollViewDidEndDecelerating:  (() -> Void)?

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        onScroll?(scrollView)
    }

    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        scrollViewWillBeginDecelerating?()
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        scrollViewDidEndDecelerating?()
    }
}

final class PostTableViewCell: UITableViewCell {
    static let identifier = "PostTableViewCell"
    final class HeaderView: UIView {
        private lazy var avatarImageView: UIImageView = {
            let view = UIImageView(frame: .zero)
            view.backgroundColor = .background
            view.layer.cornerRadius = 18
            view.addGestureRecognizer(tapGesture)
            view.isUserInteractionEnabled = true
            return view
        }()

        private lazy var nameLabel: UILabel = {
            let view = UILabel(frame: .zero)
            view.textColor = .white
            view.backgroundColor = .background
            view.isUserInteractionEnabled = true
            view.addGestureRecognizer(tapGesture)
            return view
        }()

        private lazy var tapGesture: UITapGestureRecognizer = {
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleNameTap))
            return tapGesture
        }()

        var onNameTap: (() -> Void)?

        @objc func handleNameTap() {
            onNameTap?()
        }

        private lazy var dateLabel: UILabel = {
            let view = UILabel(frame: .zero)
            view.backgroundColor = .background
            view.textColor = .white.withAlphaComponent(0.5)
            return view
        }()

        private lazy var moreButton: UIButton = {
            let view = UIButton(type: .custom)
            let config = UIImage.SymbolConfiguration(weight: .heavy)
            let image = UIImage(
                systemName: "ellipsis",
                withConfiguration: config
            )?.withTintColor(.white, renderingMode: .alwaysOriginal)
            view.setImage(image, for: .normal)
            view.backgroundColor = .background
            return view
        }()

        override var intrinsicContentSize: CGSize {
            let height = max(avatarImageView.intrinsicContentSize.height, nameLabel.intrinsicContentSize.height)
            return CGSize(width: UIView.noIntrinsicMetric, height: height)
        }

        override init(frame: CGRect) {
            super.init(frame: frame)
            addSubviews()
            makeConstraints()
            backgroundColor = .background
        }

        private func addSubviews() {
            [
                avatarImageView,
                nameLabel,
                dateLabel,
                moreButton,
            ].forEach { addSubview($0) }
        }

        private func makeConstraints() {
            avatarImageView.snp.makeConstraints {
                $0.leading.equalToSuperview()
                $0.centerY.equalToSuperview()
                $0.size.equalTo(CGSize(width: 36, height: 36))
            }

            nameLabel.snp.makeConstraints {
                $0.leading.equalTo(avatarImageView.snp.trailing).inset(-12)
                $0.centerY.equalToSuperview()
            }

            moreButton.snp.makeConstraints {
                $0.trailing.equalToSuperview()
                $0.centerY.equalToSuperview()
            }

            dateLabel.snp.makeConstraints {
                $0.trailing.equalTo(moreButton.snp.leading).inset(-12)
                $0.centerY.equalToSuperview()
            }
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

        func setup(avatar: UIImage, name: String, date: String) {
            avatarImageView.image = avatar
            nameLabel.text = name
            dateLabel.text = date
        }
    }

    lazy var headerView: HeaderView = {
        let view = HeaderView(frame: .zero)
        return view
    }()

    private lazy var textBodyView: UITextView = {
        let view = UITextView(frame: .zero)
        view.textColor = .white
        view.backgroundColor = .background
        view.isEditable = false
        view.isScrollEnabled = false
        view.font = .systemFont(ofSize: 15, weight: .regular)
        return view
    }()

    private lazy var imageBodyView: UIImageView = {
        let view = UIImageView(frame: .zero)
        view.layer.cornerRadius = 20
        view.backgroundColor = .background
        return view
    }()

    private lazy var reactionsView: UIImageView = {
        let view = UIImageView(image: nil)
        return view
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubviews()
        contentView.backgroundColor = .background
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func addSubviews() {
        [
            headerView,
            textBodyView,
            imageBodyView
        ].forEach { contentView.addSubview($0) }
    }

    func set(postModel: Post) {
        switch postModel.body {
        case .left(let text):
            textBodyView.text = text
        case .right(let image):
            imageBodyView.image = image
        case .combined(let text, let image):
            textBodyView.text = text
            imageBodyView.image = image
        }
        headerView.setup(
            avatar: postModel.avatar,
            name: postModel.author,
            date: postModel.dateOfPosting
        )

        if !postModel.reactions.isEmpty {
            reactionsView.image = .reactionsView
            contentView.addSubview(reactionsView)
        }

        setNeedsLayout()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        setupLayoutAndGetHeight()
    }

    override func sizeThatFits(_ size: CGSize) -> CGSize {
        contentView.frame.size.width = size.width
        let height = setupLayoutAndGetHeight()
        return CGSize(width: size.width, height: height)
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        textBodyView.text = nil
        imageBodyView.image = nil
        headerView.onNameTap = nil
        reactionsView.removeFromSuperview()
    }

    @discardableResult
    func setupLayoutAndGetHeight() -> CGFloat {
        let hBaseInset = CGFloat(16)
        let vBaseInset = CGFloat(12)
        let baseWidth = contentView.frame.width - (hBaseInset * 2)
        headerView.frame = CGRect(
            x: Int(hBaseInset),
            y: Int(vBaseInset),
            width: Int(baseWidth),
            height: Int(headerView.intrinsicContentSize.height)
        )
        let textHeight = textBodyView.sizeThatFits(CGSize(width: baseWidth, height: .greatestFiniteMagnitude)).height.rounded(.up)
        if !(textBodyView.text ?? "").isEmpty {
            textBodyView.frame = CGRect(
                x: Int(hBaseInset),
                y: Int(headerView.frame.maxY + vBaseInset),
                width: Int(baseWidth),
                height: Int(textHeight)
            )
        } else {
            textBodyView.frame = .zero
        }
        let imageHeight = imageBodyView.sizeThatFits(CGSize(width: baseWidth, height: .greatestFiniteMagnitude)).height
        if imageBodyView.image != nil {
            let y = [headerView, textBodyView].map(\.frame.maxY).max() ?? .zero
            imageBodyView.frame = CGRect(
                x: Int(hBaseInset),
                y: Int(y + vBaseInset),
                width: Int(baseWidth),
                height: Int(imageHeight)
            )
        } else {
            imageBodyView.frame = .zero
        }
        reactionsView.frame = CGRect(
            x: Int(hBaseInset),
            y: Int([headerView, textBodyView, imageBodyView].map(\.frame.maxY).max()! + 7),
            width: Int(reactionsView.intrinsicContentSize.width),
            height: Int(reactionsView.intrinsicContentSize.height)
        )
        let maxY = [headerView, textBodyView, imageBodyView, reactionsView].map(\.frame.maxY).max() ?? .zero
        return maxY + vBaseInset
    }
}

enum Either<A: Hashable, B: Hashable>: Hashable {
    case left(A)
    case right(B)
    case combined(A, B)
}

struct Post: Hashable {
    let author: String
    let avatar: UIImage
    let dateOfPosting = "2 д"
    let body: Either<String, UIImage>
    let reactions: [Reaction]
    let availableReactions: [Reaction] = Reaction.allCases

    enum Reaction: CaseIterable, Hashable {
        case like
        case fire
        case lookup
        case thumbsUp

        var icon: UIImage {
            switch self {
            case .like: return .fireReaction
            case .fire: return .fireReaction
            case .lookup: return .fireReaction
            case .thumbsUp: return .fireReaction
            }
        }
    }

    static var stubs: [Self] {
        [
            Post(
                author: "Софья Загуменкова",
                avatar: .avatar,
                body: .left(
"""
Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.
"""
                ),
                reactions: [.fire]
            ),
            Post(
                author: "Софья Загуменкова",
                avatar: .avatar,
                body: .right(.post),
                reactions: []
            ),
            Post(
                author: "Софья Загуменкова",
                avatar: .avatar,
                body: .combined(
"""
Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.
""",
.post
                ),
                reactions: []
            ),
            Post(
                author: "Софья Загуменкова",
                avatar: .avatar,
                body: .left(
"""
Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.
"""
                ),
                reactions: [.fire]
            ),
            Post(
                author: "Софья Загуменкова",
                avatar: .avatar,
                body: .right(.post),
                reactions: []
            ),
            Post(
                author: "Софья Загуменкова",
                avatar: .avatar,
                body: .combined(
"""
Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.
""",
.post
                ),
                reactions: [.fire]
            ),
        ]
    }
}


struct Profile {
    let avatar: UIImage
    let name: String
    let role: String?
    let description: String?
    let props: [Profile.Property]
    let achivements: [Achivement]
    let friendsCount: Int
    let externalRefs: [ExternalRef]
    let posts: [Post]
    let isSelf: Bool

    struct Property {
        let name: String
        let value: String
    }

    struct Achivement {}

    enum ExternalRef {
        case hh
        case behance
        case telegram
        case hse
        case vk
        case hsePortf
        case tgChannel
        case custom(String)

        var icon: UIImage? {
            switch self {
            case .hh: return .hhLogo
            case .behance: return .behLogo
            case .telegram: return .tgLogo
            case .hse: return .hseLogo
            case .vk: return .vkLogo
            case .hsePortf: return .portfLogo
            case .tgChannel: return .tgChLogo
            case .custom: return nil
            }
        }

        var title: String {
            switch self {
            case .hh:
                return "hh.ru"
            case .behance:
                return "behance"
            case .telegram:
                return "telegram"
            case .hse:
                return "hsedesign"
            case .vk:
                return "вконтакте"
            case .hsePortf:
                return "portfolio.hse"
            case .tgChannel:
                return "telegram-канал"
            case .custom(let string):
                return string
            }
        }

        var link: URL {
            let urlStr: String
            switch self {
            case .hh: urlStr = "https://hh.ru"
            case .behance: urlStr = "https://hh.ru"
            case .telegram: urlStr = "https://hh.ru"
            case .hse: urlStr = "https://hh.ru"
            case .vk: urlStr = "https://hh.ru"
            case .hsePortf: urlStr = "https://hh.ru"
            case .tgChannel: urlStr = "https://hh.ru"
            case .custom: urlStr = "https://hh.ru"
            }
            return URL(string: urlStr).unsafelyUnwrapped
        }
    }

    static var test: Self {
        return Self(
            avatar: .profileAvatar,
            name: "Софья Загуменкова",
            role: "admin",
            description: "Нарисовала вам эти странички на сайте, чтобы было красиво и приятно. Еще люблю котиков и дизайн. Давайте знакомиться!",
            props: [
                Property(name: "Место работы", value: "restore:"),
                Property(name: "Образование", value: "HSE ART AND DESIGN")
            ],
            achivements: [Achivement()],
            friendsCount: 33,
            externalRefs: [
                .hh,
                .behance,
                .telegram,
                .hse,
                .vk,
                .hsePortf,
                .tgChannel,
                .custom("личное портфолио")
            ],
            posts: Post.stubs,
            isSelf: false
        )
    }

    static var empty: Self {
        return Self(
            avatar: .avatarThumbnail,
            name: "Василий Шихачевский",
            role: nil,
            description: nil,
            props: [],
            achivements: [],
            friendsCount: 3,
            externalRefs: [],
            posts: [],
            isSelf: true
        )
    }
}

final class ProfileVeiw: UIView {
    lazy var headerView: UIImageView = {
        let view = UIImageView(image: .profileHeader)
        view.contentMode = .scaleAspectFit
        view.backgroundColor = .clear
        return view
    }()

    private lazy var avatorImageView: UIImageView = {
        let view = UIImageView(image: model.avatar)
        return view
    }()

    private lazy var achivementsImageView: UIImageView = {
        let view = UIImageView(image: .achivements)
        return view
    }()

    class SubscribeButton: UIButton {
        struct Style: Equatable {
            let titleColor: UIColor
            let background: UIColor

            static var subscribed: SubscribeButton.Style {
                return .init(
                    titleColor: .black,
                    background: .white
                )
            }

            static var unsubscribed: SubscribeButton.Style {
                return .init(
                    titleColor: .white,
                    background: .unsubscribe
                )
            }
        }


        var style: SubscribeButton.Style {
            didSet {
                applyStyle()
            }
        }

        init(style: SubscribeButton.Style) {
            self.style = style
            super.init(frame: .zero)
            applyStyle()
        }

        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

        override var intrinsicContentSize: CGSize {
            let original = super.intrinsicContentSize
            let hInset: CGFloat = 17
            return CGSize(width: hInset + original.width + hInset, height: 33)
        }

        private func applyStyle() {
            setTitleColor(style.titleColor, for: .normal)
            setTitleColor(style.titleColor.withAlphaComponent(0.2), for: .highlighted)
            backgroundColor = style.background
            layer.cornerRadius = intrinsicContentSize.height / 2
            titleLabel?.font = .systemFont(ofSize: 15, weight: .semibold)
            setNeedsDisplay()
        }

        func toggleStyle() {
            if style == .subscribed {
                style = .unsubscribed
                setTitle("Отписаться", for: .normal)
            } else {
                style = .subscribed
                setTitle("Подписаться", for: .normal)
            }
            UIView.animate(withDuration: 0.1) {
                self.superview?.layoutIfNeeded()
            }
        }
    }

    private lazy var subscribeButton: SubscribeButton = {
        let view = SubscribeButton(style: .subscribed)
        view.setTitle("Подписаться", for: .normal)
        view.addAction(
            UIAction(handler: { [weak view] _ in
                view?.toggleStyle()
            }),
            for: .touchUpInside
        )
        return view
    }()

    private lazy var nameLabel: UILabel = {
        let view = UILabel()
        view.textColor = .white
        view.backgroundColor = .background
        view.text = model.name
        view.font = .systemFont(ofSize: 24, weight: .medium)
        view.textAlignment = .left
        return view
    }()

    private lazy var descriptionLabel: UILabel = {
        let view = UILabel()
        view.backgroundColor = .background
        view.textColor = .white
        view.text = model.description
        view.font = .systemFont(ofSize: 15, weight: .regular)
        view.numberOfLines = 0
        return view
    }()

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(frame: .zero)
        stackView.axis = .vertical
        stackView.spacing = 8
        return stackView
    }()

    private lazy var friendsCountView: ProfileFriendsCountView = {
        let view = ProfileFriendsCountView(count: model.friendsCount)
        return view
    }()

    private lazy var linksCollectionView: ExternalLinksCarouselView = {
        let view = ExternalLinksCarouselView(items: model.externalRefs)
        view.onSelect = {
            UIApplication.shared.open($0.link, options: [:], completionHandler: nil)
        }
        return view
    }()

    let model: Profile

    init(model: Profile) {
        self.model = model
        super.init(frame: .zero)
        backgroundColor = .background
        addSubviews()
        makeConstraints()
        addSubscribeButtonIfNeeded()
        addAchivementsIfNeeded()
        addDescriptionLabelIfNeeded()
        configurePropertiesViewIfNeeded()
        addFriendsViewIfNeeded()
        addExternalLinksCarouselViewIfNedded()
        layoutIfNeeded()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func sizeThatFits(_ size: CGSize) -> CGSize {
        var height = CGFloat()
        height += headerView.intrinsicContentSize.height
        height += avatorImageView.intrinsicContentSize.height / 2
        height += baseInsets.vertical
        height += nameLabel.intrinsicContentSize.height
        height += 18
        height += descriptionLabel.intrinsicContentSize.height * CGFloat(descriptionLabel.numberOfLines)
        if model.props.isEmpty == false {
            height += baseInsets.vertical
            let dummy = ProfilePropertyView(model: .init(name: "foo", value: "bar"))
            dummy.layoutIfNeeded()
            model.props.forEach { _ in
                height += stackView.spacing
                height += dummy.intrinsicContentSize.height
            }
        }
        if model.friendsCount > 0 {
            height += baseInsets.vertical
            height += friendsCountView.intrinsicContentSize.height
        }
        if model.externalRefs.isEmpty == false {
            height += baseInsets.vertical
            height += 22
            height += 40
        }
        height += 14
        return CGSize(width: size.width, height: height)
    }

    private func addSubviews() {
        addSubview(headerView)
        addSubview(avatorImageView)
        addSubview(nameLabel)
    }


    private let baseInsets: (vertical: CGFloat, horizontal: CGFloat) = (16, 16)

    private func makeConstraints() {
        headerView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
        }
        avatorImageView.snp.makeConstraints {
            $0.centerY.equalTo(headerView.snp.bottom)
            $0.leading.equalToSuperview().inset(baseInsets.horizontal)
        }
        nameLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(baseInsets.horizontal)
            $0.top.equalTo(avatorImageView.snp.bottom).offset(baseInsets.vertical)
        }
    }

    func addSubscribeButtonIfNeeded() {
        guard !model.isSelf else { return }
        addSubview(subscribeButton)
        subscribeButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(baseInsets.horizontal)
            $0.bottom.equalTo(avatorImageView.snp.bottom)
        }
    }

    func addAchivementsIfNeeded() {
        guard !model.achivements.isEmpty else { return }
        addSubview(achivementsImageView)
        achivementsImageView.snp.makeConstraints {
            $0.leading.equalTo(avatorImageView.snp.trailing).inset(-6)
            $0.bottom.equalTo(avatorImageView.snp.bottom)
        }
    }

    func addDescriptionLabelIfNeeded() {
        guard model.description != nil else { return }
        addSubview(descriptionLabel)
        descriptionLabel.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(baseInsets.horizontal)
            $0.top.equalTo(nameLabel.snp.bottom).offset(18)
        }
    }

    func configurePropertiesViewIfNeeded() {
        guard !model.props.isEmpty else { return }
        model.props.forEach {
            let propView = ProfilePropertyView(model: ProfilePropertyView.Model(name: $0.name, value: $0.value))
            stackView.addArrangedSubview(propView)
        }
        addSubview(stackView)
        stackView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(baseInsets.horizontal)
            if model.description != nil {
                $0.top.equalTo(descriptionLabel.snp.bottom).offset(baseInsets.vertical)
            } else {
                $0.top.equalTo(nameLabel.snp.bottom).offset(18)
            }
        }
    }

    func addFriendsViewIfNeeded() {
        guard model.friendsCount > 0 else { return }
        addSubview(friendsCountView)
        friendsCountView.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(baseInsets.horizontal)
            if model.props.isEmpty == false {
                $0.top.equalTo(stackView.snp.bottom).offset(baseInsets.vertical)
            } else if model.description != nil {
                $0.top.equalTo(descriptionLabel.snp.bottom).offset(baseInsets.vertical)
            } else {
                $0.top.equalTo(nameLabel.snp.bottom).offset(18)
            }
        }
    }

    func addExternalLinksCarouselViewIfNedded() {
        guard !model.externalRefs.isEmpty else { return }
        addSubview(linksCollectionView)
        linksCollectionView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(22)
            if model.friendsCount > 0 {
                $0.top.equalTo(friendsCountView.snp.bottom).offset(baseInsets.vertical)
            } else if model.props.isEmpty == false {
                $0.top.equalTo(stackView.snp.bottom).offset(baseInsets.vertical)
            } else if model.description != nil {
                $0.top.equalTo(descriptionLabel.snp.bottom).offset(baseInsets.vertical)
            } else {
                $0.top.equalTo(nameLabel.snp.bottom).offset(18)
            }
        }
    }

}
final class ProfileTableViewCell: UITableViewCell {
    static var identifier: String {
        "ProfileTableViewCell"
    }
    let model: Profile

    lazy var profileView: ProfileVeiw = {
        let view = ProfileVeiw(model: model)
        return view
    }()

    init(model: Profile) {
        self.model = model
        super.init(style: .default, reuseIdentifier: ProfileTableViewCell.identifier)
        backgroundColor = .background
        contentView.addSubview(profileView)
        profileView.snp.makeConstraints { $0.edges.equalToSuperview() }
    }

    override func sizeThatFits(_ size: CGSize) -> CGSize {
        profileView.sizeThatFits(size)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

final class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    private lazy var tableView: UITableView = {
        let view = UITableView(frame: .zero, style: .plain)
        view.backgroundColor = .background
        view.delegate = self
        view.dataSource = self
        view.bounces = false
        view.register(PostTableViewCell.self, forCellReuseIdentifier: PostTableViewCell.identifier)
        view.register(ProfileTableViewCell.self, forCellReuseIdentifier: ProfileTableViewCell.identifier)
        view.register(EmptyStateTableViewCell.self, forCellReuseIdentifier: EmptyStateTableViewCell.identifier)
        view.contentInsetAdjustmentBehavior = .never
        view.separatorInset = .zero
        return view
    }()

    private lazy var postsTableController: TableViewController = {
        let controller = TableViewController(posts: model.posts)
        return controller
    }()

    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        handleSegments(isVisible: false)
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        handleSegments(isVisible: true)
    }

    func handleSegments(isVisible: Bool) {
        segmets.snp.updateConstraints {
            if isVisible {
                $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(20)
            } else {
                $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(100)
            }
        }
        UIView.animate(withDuration: 0.4) {
            self.view.layoutIfNeeded()
        }
    }

    private lazy var segmets: UISegmentedControl = {
        let view = UISegmentedControl(items: ["Посты", "Проекты"])
        view.selectedSegmentTintColor = .primary
        view.setTitleTextAttributes(
            [
                NSAttributedString.Key.foregroundColor: UIColor.white,
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18, weight: .regular)
            ],
            for: .normal
        )
        view.setTitleTextAttributes(
            [
                NSAttributedString.Key.foregroundColor: UIColor.black,
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18, weight: .regular)
            ],
            for: .selected
        )
        view.selectedSegmentIndex = 0
        view.backgroundColor = .background
        return view
    }()

    let model: Profile

    init(model: Profile) {
        self.model = model
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .background
        addSubviews()
        makeConstraints()
        navigationController?.navigationBar.topItem?.backButtonDisplayMode = .minimal
        navigationItem.title = model.name
    }

    private func addSubviews() {
        view.addSubview(tableView)
        view.addSubview(segmets)
    }

    private func makeConstraints() {
        tableView.snp.makeConstraints {
            $0.leading.trailing.top.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
        segmets.snp.makeConstraints {
            $0.height.equalTo(50)
            $0.leading.trailing.equalToSuperview().inset(39)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(20)
        }
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        2
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            if model.posts.isEmpty {
                return 1
            } else {
                return postsTableController.tableView(tableView, numberOfRowsInSection: section)
            }
        }
    }


    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = indexPath.section
        if section == 0 {
            let cell = ProfileTableViewCell(model: model)
            return cell
        } else {
            if model.posts.isEmpty {
                let cell = EmptyStateTableViewCell(style: .default, reuseIdentifier: EmptyStateTableViewCell.identifier)
                cell.selectionStyle = .none
                return cell
            } else {
                return postsTableController.tableView(tableView, cellForRowAt: indexPath)
            }
        }
    }

    var _cell: ProfileTableViewCell?
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let section = indexPath.section
        if section == 0 {
            let cell = ProfileTableViewCell(model: model)
            cell.sizeToFit()
            _cell = cell
            let size = cell.frame.size
            return size.height
        } else {
            if model.posts.isEmpty {
                let contentHeight = tableView.frame.height
                let cell = ProfileTableViewCell(model: model)
                cell.sizeToFit()
                _cell = cell
                let profileHeight = cell.frame.size.height
                return abs(contentHeight - profileHeight)
            } else {
                return postsTableController.tableView(tableView, heightForRowAt: indexPath)
            }
        }
    }
}

final class EmptyStateTableViewCell: UITableViewCell {
    static let identifier = "EmptyStateTableViewCell"

    private lazy var view: EmptyStateView = {
        let view = EmptyStateView(frame: .zero)
        return view
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(view)
        contentView.addSubview(view)
        view.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        backgroundColor = .background
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

final class ProfilePropertyView: UIView {

    struct Model {
        let name: String
        let value: String

        var formattedName: String {
            name + ":"
        }
    }

    private lazy var propertyNameLabel: UILabel = {
        let view = UILabel(frame: .zero)
        view.font = .systemFont(ofSize: 15, weight: .regular)
        view.backgroundColor = .background
        view.textColor = .white.withAlphaComponent(0.5)
        view.text = model.formattedName
        view.textAlignment = .left
        return view
    }()

    private lazy var propertyValueLabel: UILabel = {
        let view = UILabel(frame: .zero)
        view.font = .systemFont(ofSize: 15, weight: .regular)
        view.backgroundColor = .background
        view.textColor = .white
        view.text = model.value
        view.textAlignment = .left
        return view
    }()

    let model: ProfilePropertyView.Model

    init(model: ProfilePropertyView.Model) {
        self.model = model
        super.init(frame: .zero)
        addSubviews()
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override var intrinsicContentSize: CGSize {
        var height = CGFloat()
        height += propertyNameLabel.intrinsicContentSize.height
        height += 4
        height += propertyValueLabel.intrinsicContentSize.height
        return CGSize(width: UIView.noIntrinsicMetric, height: height)
    }

    private func addSubviews() {
        addSubview(propertyNameLabel)
        addSubview(propertyValueLabel)
    }

    private func makeConstraints() {
        propertyNameLabel.snp.makeConstraints {
            $0.leading.top.equalToSuperview()
        }
        propertyValueLabel.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.top.equalTo(propertyNameLabel.snp.bottom).offset(4)
        }
    }
}

final class ProfileFriendsCountView: UIView {
    private lazy var avatarsStack: UIImageView = {
        let view = UIImageView(image: .friendsStack)
        view.backgroundColor = .background
        return view
    }()

    private lazy var countLabel: UILabel = {
        let view = UILabel(frame: .zero)
        view.textColor = .secondaryText
        view.font = .systemFont(ofSize: 15, weight: .regular)
        view.textAlignment = .left
        view.backgroundColor = .background
        return view
    }()

    let count: Int

    init(count: Int) {
        self.count = count
        super.init(frame: .zero)
        backgroundColor = .background
        addSubviews()
        makeConstraints()
        prepareCountText()
    }

    override var intrinsicContentSize: CGSize {
        var height = max(avatarsStack.intrinsicContentSize.height, countLabel.intrinsicContentSize.height)
        return CGSize(width: UIView.noIntrinsicMetric, height: height)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubviews() {
        addSubview(avatarsStack)
        addSubview(countLabel)
    }
    private func makeConstraints() {
        avatarsStack.snp.makeConstraints {
            $0.leading.centerY.equalToSuperview()
        }
        countLabel.snp.makeConstraints {
            $0.leading.equalTo(avatarsStack.snp.trailing).offset(6)
            $0.centerY.equalToSuperview()
        }
    }

    private func prepareCountText() {
        let text = conjugation(
            count: count,
            v1: "друг",
            v2_3: "друга",
            v0_5: "друзей"
        )
        countLabel.text = "• \(count) " + text
    }
}

func conjugation(
    count: Int,
    v1: String, // 1 друг
    v2_3: String, // 2 друга
    v0_5: String // 5 друзей
) -> String {
    var countCopy = count
    countCopy %= 100
    if count >= 5, count <= 20 {
        return v0_5
    } else {
        let remainder = countCopy % 10;
        if remainder == 0 || remainder >= 5 {
            return v0_5;
        } else if (remainder == 1) {
            return v1;
        } else {
            return v2_3;
        }
    }
}

final class ExternalLinksCarouselView: UIView, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    let items: [Profile.ExternalRef]

    var onSelect: ((Profile.ExternalRef) -> ())?

    init(items: [Profile.ExternalRef]) {
        self.items = items
        super.init(frame: .zero)
        addSubviews()
        makeConstraints()
        collectionView.reloadData()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func addSubviews() {
        addSubview(collectionView)
    }

    private func makeConstraints() {
        collectionView.snp.makeConstraints { maker in
            maker.edges.equalToSuperview()
        }
    }

    private lazy var collectionLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 14
        layout.headerReferenceSize = .zero
        layout.footerReferenceSize = .zero
        return layout
    }()

    private(set) lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionLayout)
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        collectionView.backgroundColor = .background
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.decelerationRate = .fast
        collectionView.allowsMultipleSelection = false
        collectionView.allowsSelection = true
        collectionView.register(
            ExternalLinksCarouselCell.self,
            forCellWithReuseIdentifier: ExternalLinksCarouselCell.identifier
        )
        return collectionView
    }()

    final class ExternalLinksCarouselCell: UICollectionViewCell {

        static let identifier = "ExternalLinksCarouselCell"

        private lazy var iconImageView: UIImageView = {
            let view = UIImageView(frame: .zero)
            view.backgroundColor = .background
            return view
        }()

        private lazy var nameLabel: UILabel = {
            let view = UILabel(frame: .zero)
            view.backgroundColor = .background
            view.textColor = .white
            view.font = .systemFont(ofSize: 15, weight: .semibold)
            return view
        }()

        override init(frame: CGRect) {
            super.init(frame: frame)
            backgroundColor = .background
            addSubviews()
            makeConstraints()
        }

        override func prepareForReuse() {
            super.prepareForReuse()
            iconImageView.image = nil
            nameLabel.text = nil
        }

        private func addSubviews() {
            contentView.addSubview(iconImageView)
            contentView.addSubview(nameLabel)
        }

        private func makeConstraints() {
            iconImageView.snp.makeConstraints {
                $0.leading.centerY.equalToSuperview()
            }

            nameLabel.snp.makeConstraints {
                $0.centerY.equalToSuperview()
                $0.leading.equalTo(iconImageView.snp.trailing).offset(9)
            }
        }

        func set(model: Profile.ExternalRef) {
            iconImageView.image = model.icon
            nameLabel.text = model.title
            setNeedsLayout()
        }

        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

        override func sizeThatFits(_ size: CGSize) -> CGSize {
            let width = iconImageView.intrinsicContentSize.width + nameLabel.intrinsicContentSize.width + 9
            let height = max(iconImageView.intrinsicContentSize.height, nameLabel.intrinsicContentSize.height)
            return CGSize(width: width, height: height)
        }
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        items.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell: ExternalLinksCarouselCell! = collectionView.dequeueReusableCell(withReuseIdentifier: ExternalLinksCarouselCell.identifier, for: indexPath) as? ExternalLinksCarouselCell
        if cell == nil {
            cell = ExternalLinksCarouselCell(frame: .zero)
        }
        let model = items[indexPath.row]
        cell.set(model: model)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let model = items[indexPath.row]
        onSelect?(model)
    }

    var sizeCache = [String: CGSize]()

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let model = items[indexPath.row]
        if let cachedSize = sizeCache[model.title] {
            return cachedSize
        }
        let dummy = ExternalLinksCarouselCell(frame: .zero)
        dummy.set(model: model)
        dummy.sizeToFit()
        let size = dummy.frame.size
        sizeCache[model.title] = size
        return size
    }
}

final class EmptyStateView: UIView {
    private lazy var emptyStateImageView: UIImageView = {
        let view = UIImageView(image: .emptyState)
        view.contentMode = .scaleAspectFit
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .background
        addSubview(emptyStateImageView)
        emptyStateImageView.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
