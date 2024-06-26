import UIKit
import SnapKit
import Combine
import CombineKeyboard

class LoginViewController: UIViewController {
    
    private let logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "adc_logo")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let closeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        button.tintColor = .white
        button.addTarget(nil, action: #selector(didTapCloseButton), for: .touchUpInside)
        return button
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Вход"
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 32)
        label.textAlignment = .center
        return label
    }()
    
    private let emailLabel: UILabel = {
        let label = UILabel()
        label.text = "Почта"
        label.textColor = .placeholderText
        label.font = UIFont.systemFont(ofSize: 14)
        label.textAlignment = .center
        label.isHidden = true
        label.alpha = 0
        return label
    }()
    
    private let passwordLabel: UILabel = {
        let label = UILabel()
        label.text = "Пароль"
        label.textColor = .placeholderText
        label.font = UIFont.systemFont(ofSize: 14)
        label.textAlignment = .center
        label.isHidden = true
        label.alpha = 0
        return label
    }()
    
    private let emailTextField: PaddedTextField = {
        let textField = PaddedTextField(topPadding: 10, leftPadding: 10)
        textField.attributedPlaceholder = NSAttributedString(string: "Почта", attributes: [NSAttributedString.Key.foregroundColor: UIColor.placeholderText])
        textField.backgroundColor = .textFieldBackground
        textField.layer.cornerRadius = 12
        textField.textColor = .white
        textField.keyboardType = .emailAddress
        textField.font = UIFont.systemFont(ofSize: 18)
        textField.addTarget(nil, action: #selector(textEmailFieldDidChange), for: .editingChanged)
        return textField
    }()
    
    private let passwordTextField: PaddedTextField = {
        let textField = PaddedTextField(topPadding: 10, leftPadding: 10)
        textField.attributedPlaceholder = NSAttributedString(string: "Пароль", attributes: [NSAttributedString.Key.foregroundColor: UIColor.placeholderText])
        textField.backgroundColor = .textFieldBackground
        textField.layer.cornerRadius = 12
        textField.textColor = .white
        textField.font = UIFont.systemFont(ofSize: 18)
        textField.isSecureTextEntry = true
        textField.addTarget(nil, action: #selector(textPasswordFieldDidChange), for: .editingChanged)
        return textField
    }()
    
    private let togglePasswordButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "eye"), for: .normal)
        button.tintColor = .lightGray
        button.addTarget(nil, action: #selector(didTapTogglePasswordButton), for: .touchUpInside)
        return button
    }()
    
    private let forgotPasswordButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Забыли пароль?", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        button.addTarget(nil, action: #selector(didTapForgotPasswordButton), for: .touchUpInside)
        return button
    }()
    
    private let loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Войти", for: .normal)
        button.backgroundColor = .white
        button.setTitleColor(.loginText, for: .normal)
        button.layer.cornerRadius = 8
        button.addTarget(nil, action: #selector(didTapLoginButton), for: .touchUpInside)
        return button
    }()
    
    private let signUpLabel: UILabel = {
        let label = UILabel()
        label.text = "Ещё нет аккаунта?"
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 15)
        return label
    }()
    
    private let signUpButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Зарегистрироваться", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        button.addTarget(nil, action: #selector(didTapSignUpButton), for: .touchUpInside)
        return button
    }()
    
    let bottomContainerView: UIView = {
        let view = UIView()
        return view
    }()
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 8
        return stackView
    }()
    
    private var buttonBottomConstraint: Constraint?
    private var bottomViewConstraint: Constraint?
    private var cancellables = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .background
        view.addSubview(bottomContainerView)
        view.addSubview(logoImageView)
        view.addSubview(closeButton)
        view.addSubview(titleLabel)
        view.addSubview(emailTextField)
        view.addSubview(passwordTextField)
        view.addSubview(togglePasswordButton)
        view.addSubview(forgotPasswordButton)
        view.addSubview(loginButton)
        view.addSubview(emailLabel)
        view.addSubview(passwordLabel)
        bottomContainerView.addSubview(stackView)
        stackView.addArrangedSubview(signUpLabel)
        stackView.addArrangedSubview(signUpButton)
        
        setupConstraints()
        setupKeyboardObservers()
    }
    
    private func setupConstraints() {
        logoImageView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(16)
            make.centerX.equalToSuperview()
            make.height.equalTo(31)
            make.width.equalTo(92)
        }
        
        closeButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(16)
            make.leading.equalToSuperview().offset(16)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(logoImageView.snp.bottom).offset(32)
            make.centerX.equalToSuperview()
        }
        
        emailLabel.snp.makeConstraints { make in
            make.leading.equalTo(emailTextField.snp.leading).inset(10)
            make.top.equalTo(emailTextField.snp.top).inset(5)
        }
        
        passwordLabel.snp.makeConstraints { make in
            make.leading.equalTo(passwordTextField).inset(10)
            make.top.equalTo(passwordTextField).inset(5)
        }
        
        emailTextField.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(32)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(58)
        }
        
        passwordTextField.snp.makeConstraints { make in
            make.top.equalTo(emailTextField.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(58)
        }
        
        togglePasswordButton.snp.makeConstraints { make in
            make.centerY.equalTo(passwordTextField)
            make.trailing.equalTo(passwordTextField.snp.trailing).offset(-8)
        }
        
        forgotPasswordButton.snp.makeConstraints { make in
            make.top.equalTo(passwordTextField.snp.bottom).offset(8)
            make.leading.equalTo(passwordTextField.snp.leading)
        }
        
        loginButton.snp.makeConstraints { make in
            self.buttonBottomConstraint = make.bottom.equalTo(bottomContainerView.snp.top).offset(-12).constraint
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(54)
        }
        
        bottomContainerView.snp.makeConstraints { make in
            bottomViewConstraint = make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-16).constraint
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(20)
        }
        
        stackView.snp.makeConstraints { make in
            make.bottom.equalTo(bottomContainerView.snp.bottom)
            make.centerX.equalToSuperview()
        }
        
        signUpLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.top.equalToSuperview().inset(18)
        }
        
        signUpButton.snp.makeConstraints { make in
            make.leading.equalTo(signUpLabel.snp.trailing).offset(8)
            make.top.equalToSuperview().inset(18)
        }
    }
    
    // MARK: - Actions
    @objc private func didTapCloseButton() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func didTapTogglePasswordButton() {
        passwordTextField.isSecureTextEntry.toggle()
        let imageName = passwordTextField.isSecureTextEntry ? "eye" : "eye.slash"
        togglePasswordButton.setImage(UIImage(systemName: imageName), for: .normal)
    }
    
    @objc private func didTapForgotPasswordButton() {
    }
    
    @objc private func didTapLoginButton() {
        let isEmailEmpty = emailTextField.text?.isEmpty ?? true
        let isPasswordEmpty = passwordTextField.text?.isEmpty ?? true
        
        if isEmailEmpty {
            emailTextField.setErrorBorder()
        } else {
            emailTextField.clearErrorBorder()
        }
        
        if isPasswordEmpty {
            passwordTextField.setErrorBorder()
        } else {
            passwordTextField.clearErrorBorder()
        }

        if !isEmailEmpty, !isPasswordEmpty {
            let tabbar = MainTabBarController()
            tabbar.configureTabBar()
            present(tabbar, animated: true)
        }
    }
    
    @objc private func didTapSignUpButton() {
    }
    
    private func setupKeyboardObservers() {
        CombineKeyboard.shared.height
            .sink { [weak self] height in
                guard let self = self else { return }
                
                let isKeyboardVisible = height > 0
                let bottomViewOffset: CGFloat = isKeyboardVisible ? -(height - 20) : -16
                
                self.bottomViewConstraint?.update(offset: bottomViewOffset)
                UIView.animate(withDuration: 0.3) {
                    self.view.layoutIfNeeded()
                }
            }
            .store(in: &cancellables)
    }
    
    @objc
    private func textPasswordFieldDidChange() {
        if let text = passwordTextField.text, !text.isEmpty {
            UIView.animate(withDuration: 0.3) {
                self.passwordLabel.alpha = 1.0
                self.passwordLabel.isHidden = false
            }
        } else {
            UIView.animate(withDuration: 0.3) {
                self.passwordLabel.alpha = 0.0
                self.passwordLabel.isHidden = true
            }
        }
    }
    
    @objc
    private func textEmailFieldDidChange() {
        if let text = emailTextField.text, !text.isEmpty {
            UIView.animate(withDuration: 0.3) {
                self.emailLabel.alpha = 1.0
                self.emailLabel.isHidden = false
            }
        } else {
            UIView.animate(withDuration: 0.3) {
                self.emailLabel.alpha = 0.0
                self.emailLabel.isHidden = true
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }
}

extension UITextField {
    func setErrorBorder() {
        self.layer.borderColor = UIColor.red.cgColor
        self.layer.borderWidth = 1.0
    }
    
    func clearErrorBorder() {
        self.layer.borderColor = UIColor.clear.cgColor
        self.layer.borderWidth = 0
    }
}


class PaddedTextField: UITextField {

    var topPadding: CGFloat = 0
    var leftPadding: CGFloat = 0

    init(topPadding: CGFloat, leftPadding: CGFloat) {
        self.topPadding = topPadding
        self.leftPadding = leftPadding
        super.init(frame: .zero)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: UIEdgeInsets(top: topPadding, left: leftPadding, bottom: 0, right: 0))
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return textRect(forBounds: bounds)
    }
}
