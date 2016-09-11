import Foundation
import Dispatch

/**
*  Simple way to perform an asynchronous closure synchronously
*
*  Simply use the **run** method to execute the given closure that executes something with an
*  asynchronous closure and signal when its complete.
*
*  Sync.run { sync in somethingWithAsyncCallback { sync.signal() } }
*/
public struct Sync {
    private var semaphore: DispatchSemaphore

    init() {
        semaphore = DispatchSemaphore(value: 0)
    }

    /**
     * Waits until we are signalled
     * 
     * :param: timeoutSeconds Maximum time in seconds. Passing a value of 0.0 will wait forever.
     */
    public func wait(timeoutSeconds: Double = 0.0) {
        let timeout: DispatchTime
        if timeoutSeconds != 0.0 {
            timeout = DispatchTime.now() + timeoutSeconds
        } else {
            timeout = DispatchTime.distantFuture // aka "forever"
        }

        _ = semaphore.wait(timeout: timeout)
    }

    /**
     * Signal to wakeup waiters
     */
    public func signal() {
        semaphore.signal()
    }

    /**
     * Convenience method that will execute the given closure and wait for completion. The Sync must
     * be signalled from inside the closure.
     * 
     * :param: closure Function to execute synchronously
     */
    public func run(_ closure: (Sync) -> ()) {
        closure(self)
        wait()
    }

    /**
     * Convenience static method that will execute the given closure and wait for completion.
     *
     * :param: closure Function to execute synchronously
     */
    public static func run(_ closure: (Sync) -> ()) {
        let sync = Sync()
        sync.run(closure)
    }
}