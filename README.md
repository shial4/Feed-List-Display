# Feed List Display

Project this was created from scratch. It is iOS native app done with Swift.

This project use [CocoPods](https://cocoapods.org) as a dependency manager. 
You can find instructions here [CocoPods](https://cocoapods.org). Once you are ready. Please open the terminal and navigate to this project directory. Install the dependencies in your project by running the command from your terminal:
```
$ pod install
```
Wait till installation will finish. Make sure to always open the Xcode workspace instead of the project file.
Below are the screenshots from the application.

---

As data storage, we are using Realm. I was thinking at the beginning to go with CoreData. However, you are using Realm in your app so it is best if for this example I do the same.

I implemented coordinator patter & mvvm to manage flow in this project.

I've introduced rxSwift for displaying data and pull to refresh to load the data from the server.
However, there is nothing done in terms of watching changes in realm. Wanted to do it quick. It is possible to subscribe to realm and changes happening there. thanks to the architecture it would be easy to update UI for that.

If you have any questions. Best if we do call and discuss this example. Hope you are satisfied.


Aaaaa one more thing. In terms of server, data fetch. For simplicity, I am holding and using full batches for that. passing whole content in the flow. Moreover mapping it on the go. In real example, I would suggest implementing pagination with table view or uiviewcollection where custom flow manager would indicate when and what offset to data we would like to fetch. Besides, the frontend (iOS) server should implement offset query argument to indicate correct page fetching. 

For most what you described in this task we could use dependencies as a solution. On the other hand, I do not like to do that. Over time it is just an extra layer of problems. 

To summarise, I have tried to cover all the aspect you might think of.  Added few tests for integration and coordinator. Haven't add rx or realm tests. It would be good to have them there though. 

Wanted to work on it further. Recived second phone call about it so If you want to ask me something or speed up the process let me know.

Cheers,
Szymon 
