# ToDo App

**Stack:** Swift, UIKit, Combine, Firebase

<img src="https://github.com/bgoncharov/ToDoApp/blob/main/img/1.jpg" width="200">        <img src="https://github.com/bgoncharov/ToDoApp/blob/main/img/2.jpg" width="200">   <img src="https://github.com/bgoncharov/ToDoApp/blob/main/img/3.jpg" width="200">   <img src="https://github.com/bgoncharov/ToDoApp/blob/main/img/4.jpg" width="200">   <img src="https://github.com/bgoncharov/ToDoApp/blob/main/img/5.jpg" width="200">        <img src="https://github.com/bgoncharov/ToDoApp/blob/main/img/6.jpg" width="200">   <img src="https://github.com/bgoncharov/ToDoApp/blob/main/img/7.jpg" width="200">   <img src="https://github.com/bgoncharov/ToDoApp/blob/main/img/8.jpg" width="200">

This tasks application made with `Swift`, using `UIKit`, `Combine`, and `Firebase`. Also I used some open sorce libraries: [MBProgressHUD](https://github.com/jdg/MBProgressHUD), [Loaf](https://github.com/schmidyy/Loaf), and [FSCalendar](https://github.com/WenchaoD/FSCalendar). There are two main screens with `Outgoing` and `Done` tasks. User can move tasks from Done to Outgoing, delete and edit tasks. User doen't have to log in every time when launch the application. 

**Combine framework**

Combine is Apple's shiny reactive framework that provides a declarative Swift API for processing values over time. For example I used it to observe the `New Task Form`: if form is not empty `save button` becomes active, and if user set a deadline for the task it appears at the form as well.

```swift
    private func observeForm() {
        NotificationCenter.default.publisher(for: UITextField.textDidChangeNotification)
            .map({
                ($0.object as? UITextField)?.text
        }).sink { [unowned self] (text) in
            self.taskString = text
        }.store(in: &subscribers)
        
        $taskString.sink { [unowned self] (text) in
            self.saveButton.isEnabled = text?.isEmpty == false
        }.store(in: &subscribers)
        
        $deadline.sink { (date) in
            self.deadlineLabel.text = date?.toString() ?? ""
        }.store(in: &subscribers)
    }
```

Also I used Combine on the `Login screen` to update error message and check if user succsessfully loged in and transfer to main screen of the application.

```swift
private func observeForm() {
        $errorString.sink { [unowned self] (errorMessage) in
            self.errorLabel.text = errorMessage
        }.store(in: &subscribers)
        
        $isLoginSuccessfull.sink { [unowned self] (isLogin) in
            if isLogin {
                self.delegate?.didLogin()
            }
        }.store(in: &subscribers)
    }
```

**Animation**

I created [protocol](https://github.com/bgoncharov/ToDoApp/blob/main/IosToDoApp/Protcols/Animatable.swift) called `Animatable` with implementation of animation functions for toasts and progress indicator. For toasts I use `Loaf`:

```swift
func showToast(state: Loaf.State, text: String, location: Loaf.Location = .top, duration: TimeInterval = 2.0) {
        DispatchQueue.main.async {
            Loaf(text,
                 state: state,
                 location: location,
                 presentingDirection: .vertical,
                 dismissingDirection: .vertical,
                 sender: self).show(.custom(duration))
        }
    }
```

For progress indicator - `MBProgressHUD`:

```swift
func showLoadingAnimation() {
        
        DispatchQueue.main.async {
            let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
            hud.backgroundColor = UIColor.init(white: 0.5, alpha: 0.3)
        }
    }
```
   
