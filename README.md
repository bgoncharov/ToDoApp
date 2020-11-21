# ToDo App

**Stack:** Swift, UIKit, Combine, Firebase

<img src="https://github.com/bgoncharov/ToDoApp/blob/main/img/1.jpg" width="200">        <img src="https://github.com/bgoncharov/ToDoApp/blob/main/img/2.jpg" width="200">   <img src="https://github.com/bgoncharov/ToDoApp/blob/main/img/3.jpg" width="200">   <img src="https://github.com/bgoncharov/ToDoApp/blob/main/img/4.jpg" width="200">   <img src="https://github.com/bgoncharov/ToDoApp/blob/main/img/5.jpg" width="200">        <img src="https://github.com/bgoncharov/ToDoApp/blob/main/img/6.jpg" width="200">   <img src="https://github.com/bgoncharov/ToDoApp/blob/main/img/7.jpg" width="200">   <img src="https://github.com/bgoncharov/ToDoApp/blob/main/img/8.jpg" width="200">

This tasks applications made with `Swift`, `UIKit`, `Combine`, and `Firebase`. Also I used open sorce libraries: [MBProgressHUD](https://github.com/jdg/MBProgressHUD), [Loaf](https://github.com/schmidyy/Loaf), and [FSCalendar](https://github.com/WenchaoD/FSCalendar). There are two screens with Outgoing and Done tasks. You can move tasks from Done to Outgoing, delete and edit tasks. User doen't have to log in every time when lauch the app. 

**Combine framework**

Combine is Apple's shiny reactive framework that provides a declarative Swift API for processing values over time.For example I used it to observe the New Task Form: if form is not empte 'save button' becomes active, and if user set a deadline for the task it appears at the form.

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

Also i used Combine on the Login screen to update error message and check if user succsessfully loged in and transfer to main screen of the app.

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
    
   
