# Task definition

Your task is to implement a network service which will be used to interact with the server.

Implement the following methods:


```
func registerUserWith(login: String?, password: String?, success: @escaping (Data)->(), failure: @escaping (Error?) -> ())
```
The function registers users with a login and a password. In case of a successful registration, it returns the token in a success block. In case of an error, it calls a failure block.

```
func getAllEvents(success: @escaping (Data)->(), failure: @escaping (Error?) -> ())
```
The function returns a list of all available events.  In case of an error, it calls a failure block.


```
func subscribeOnEvent(eventUUID: Int, success: @escaping (Data)->(), failure: @escaping (Error?) -> ())
```
The function subscribes the current user on an event.  In case of an error, it calls a failure block.


```
func unsubscribeFromEvent(eventUUID: Int, success: @escaping (Data)->(), failure: @escaping (Error?) -> ())
```
The function unubscribes the current user on an event.  In case of an error, it calls a failure block.

Only introduce changes to existing files.

# API reference

- User registration
(POST http://example.com/api/v1/user
creates a user. returns authToken

- Retrieving list of available events
(GET http://example.com/api/v1/events )
returns list of events.

- Subscribing to event
(GET http://example.com/api/v1/event/{uuid}/join)
adds the current user to an event.

- Unsubscribing from event
(GET http://example.com/api/v1/event/{uuid}/leave)
removes current user from the event.


```
User object: {
uuid: Int
date: Date
name: String
authToken: Uuid
events: Array<Event>
}

Event object: {
uuid: Int
date: Date
name: String
}
```

# Technical requirements

*   Language: Swift 4
*   System version: Xcode 10.1+


# Copyright

   Copyright 2017 Devskiller. All rights reserved. _
