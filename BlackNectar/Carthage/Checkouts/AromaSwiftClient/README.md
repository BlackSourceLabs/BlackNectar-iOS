Aroma Swift Client
==============================================

[<img src="https://raw.githubusercontent.com/RedRoma/aroma/develop/Graphics/Logo.png" width="300">](http://aroma.redroma.tech/)
## The Official Swift and iOS Client to Aroma

[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![Build Status](https://travis-ci.org/RedRoma/AromaSwiftClient.svg?branch=develop)](https://travis-ci.org/RedRoma/AromaSwiftClient)

# Carthage

Aroma provides easy integration with Carthage.

```ruby
github "RedRoma/AromaSwiftClient" "develop"
```
# API

## Import the Module
Add the following import statement wherever you use the Aroma Client.

```swift
import AromaSwiftClient
```

## Setup the Token

Before you can send messages to Aroma, be sure to set the Application `Token` given when the App was provisioned from within the app.

>The Token should look something like this:
```
abcdefgh-1234-474c-ae46-1234567890ab
```

Put this in your `AppDelegate` when the Application Loads.

```swift
AromaClient.TOKEN_ID = "abcdefgh-1234-474c-ae46-1234567890ab"
```

## Send a Message

```swift
AromaClient.begin(withTitle: "Operation Failed")
    .addBody("Details: \(error)")
    .addLine(2)
    .addBody("For User \(user)")
    .withPriority(.low)
    .send()
```

# Best Practices

### Send Important Messages
>Try to only Send messages that are actually interesting. You don't want to bombard Aroma with too many diagnostic messages that are better suited for Logging.

### Set the Urgency
>Set an Urgency to each message. Think of Urgency like you would a Log Severity Level. Using them allows you and your team to know just how important a message is.

# Project Source
Additional info on the Swift Client can be found by visiting the [GitHub project](https://github.com/RedRoma/aroma-swift-client).
