import Firebase

import UIKit


final class LoginViewController: UIViewController {

    //MARK: Private properties
    private let emailTextField = GeneralTextField(placeholder: TextsEnum.enterEmail.rawValue)
    private let passwordTextField = GeneralTextField(placeholder: TextsEnum.enterPassword.rawValue)
    
    private let signInButton = UIButton()
    private let forgotPasswordButton = UIButton()
    
    private let loginLabel = UILabel()
    
    private let eyeButtonForPassword = EyeButton()
    private var isEyeButtonForPasswordPrivate = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    
    func goToMainPage() {

        let tab = UITabBarController()

        let home = UINavigationController(rootViewController: HomeViewController())
        home.title = "Home"

        let search = UINavigationController(rootViewController: SearchViewController())
        search.title = "Search"

        let profile = UINavigationController(rootViewController: ProfileViewController())
        profile.title = "Profile"

        let liked = UINavigationController(rootViewController: LikedFilmsViewController())
        liked.title = "Liked"

        tab.tabBar.tintColor = .black

        tab.setViewControllers([home, search, liked,  profile], animated: false)

        guard let items = tab.tabBar.items else { return }

        let images = ["house", "magnifyingglass.circle", "heart", "person.circle"]

        for i in 0...images.count-1 {
            items[i].image = UIImage(systemName: images[i])
            
        }

        tab.modalPresentationStyle = .fullScreen
        
        navigationController?.present(tab, animated: true)

    }
        
    //MARK: Private methods

    @objc private func signInButtonClicked() {
//        guard let password = passwordTextField.text, !password.isEmpty, let email = emailTextField.text, !email.isEmpty else {
//            showAlertWithWarning(TextsEnum.fillFields.rawValue)
//            return
//        }
//
//        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
//            if error == nil {
                self.goToMainPage()
//            } else if password.count < 6 {
//                self.showAlertWithWarning("Password length should be 6 or more")
//            } else {
//                self.showAlertWithWarning(TextsEnum.invalidData.rawValue)
//            }
//        }

    }
    
    
    
    private func showAlertWithWarning(_ warning: String) {
        let alert = UIAlertController(title: "Warning", message: warning, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc private func eyeButtonForPasswordPressed() {
        let imageName = isEyeButtonForPasswordPrivate ? "eye" : "eye.slash"
        
        passwordTextField.isSecureTextEntry.toggle()
        eyeButtonForPassword.setImage(UIImage(systemName: imageName), for: .normal)
        isEyeButtonForPasswordPrivate.toggle()
    }
    
    @objc private func forgotPasswordButtonClicked() {
        navigationController?.pushViewController(ForgotPasswordViewController(), animated: true)
    }

}

// MARK: Setting views

private extension LoginViewController {
    
    func setupView() {
        view.backgroundColor = .white
        addSubViews()
        addActions()
        
        configureTextFields()
        configureLabels()
        configureSignInButton()
        configureForgotPasswordButton()
    }
    
    
}

// MARK: Configurations

private extension LoginViewController {
    func addSubViews() {
        view.addSubview(passwordTextField)
        view.addSubview(emailTextField)
        view.addSubview(loginLabel)
        view.addSubview(signInButton)
        view.addSubview(forgotPasswordButton)
    }
    
    func addActions() {
        eyeButtonForPassword.addTarget(self, action: #selector(self.eyeButtonForPasswordPressed), for: .touchUpInside)
    }
    
    func configureLabels() {
        loginLabel.textColor = .black
        loginLabel.text = "Login"
        loginLabel.textAlignment = .center
        loginLabel.font = .systemFont(ofSize: 30)
        setLabelConstraints(toItem: loginLabel, topAnchorConstraint: 10)
    }
    
    func configureTextFields() {
        emailTextField.autocapitalizationType = .none
        emailTextField.keyboardType = .emailAddress
        
        passwordTextField.autocapitalizationType = .none
        passwordTextField.isSecureTextEntry = true
        passwordTextField.rightView = eyeButtonForPassword
        passwordTextField.rightViewMode = .always
        
        let stackView = UIStackView()
        self.view.addSubview(stackView)
        stackView.addArrangedSubview(emailTextField)
        stackView.addArrangedSubview(passwordTextField)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = UIStackView.Distribution.equalSpacing
        stackView.spacing = 35.0
        stackView.alignment = UIStackView.Alignment.center
        stackView.axis = .vertical
        emailTextField.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, constant: -70).isActive = true
        passwordTextField.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, constant: -70).isActive = true
        stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 70).isActive = true
        stackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 30).isActive = true

    }
    
    
    func configureSignInButton() {
        signInButton.setTitle("Sign in", for: .normal)
        signInButton.setTitleColor(UIColor.white, for: .normal)
        signInButton.titleLabel?.font = .systemFont(ofSize: 20)
        setButtonConstraints(toItem: signInButton, topAnchorConstraint: 260)
        signInButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
        signInButton.layer.cornerRadius = 10
        signInButton.layer.backgroundColor = UIColor.black.cgColor
        signInButton.addTarget(self, action:#selector(self.signInButtonClicked), for: .touchUpInside)
    }
    
    func configureForgotPasswordButton() {
        forgotPasswordButton.setTitle("Forgot password", for: .normal)
        forgotPasswordButton.titleLabel?.font = .systemFont(ofSize: 20)
        setButtonConstraints(toItem: forgotPasswordButton, topAnchorConstraint: 360)
        forgotPasswordButton.widthAnchor.constraint(equalToConstant: 170).isActive = true
        forgotPasswordButton.setTitleColor(UIColor.white, for: .normal)
        forgotPasswordButton.layer.cornerRadius = 10
        forgotPasswordButton.layer.backgroundColor = UIColor.red.cgColor
        forgotPasswordButton.addTarget(self, action:#selector(self.forgotPasswordButtonClicked), for: .touchUpInside)
    }
}

// MARK: Constraints

private extension LoginViewController {
    func setTextFieldConstraints(toItem: UITextField, topAnchorConstraint: CGFloat) {
        toItem.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            toItem.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: topAnchorConstraint),
            toItem.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            toItem.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, constant: -70)
        ])
    }
    
    func setLabelConstraints(toItem: UILabel, topAnchorConstraint: CGFloat) {
        toItem.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            toItem.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: topAnchorConstraint),
            toItem.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 30),
            toItem.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, constant: -70),
            toItem.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.07)
        ])
    }
    
    func setButtonConstraints(toItem: UIButton, topAnchorConstraint: CGFloat) {
        toItem.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            toItem.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: topAnchorConstraint),
            toItem.heightAnchor.constraint(equalToConstant: 50)
        ])
        toItem.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
}
