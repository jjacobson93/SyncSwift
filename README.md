# SyncSwift

Run asynchronous closures syncronously

Example:
```swift
Sync.run({ sync in 
    asyncMethod {
        sync.signal()
    }
})
```

Based on [gist](https://gist.github.com/Krelborn/3cade0e86cc9f06637b6) by [Krelborn](https://gist.github.com/Krelborn)