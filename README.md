# Features


This framework implements CRUD features for managing Feature Flags.

## Priority

The system manages internally two (2) sources, **Primary** and **Secondary**. 

You will get the value in this priority order:

1. value found in **Primary**
2. value found in **Secondary**
3. value given as *default* on call

### Read

To read a *feature* value you can use an enumeration value or a String as the call's parameter. 

> The default value for a non-existent *feature* is **false**

```swift
Features.isEnable(Features.Module.myNewFeature)
Features.isEnable("My new revolutionary Feature")
```

You can also pass a default value for the case that the *feature* is not defined on the system

```swift
Features.isEnable(Features.Module.myNewFeature, default: true)
Features.isEnable("My new revolutionary Feature", default: true)
```

### Create and Update

At creation or update time, you must define the priority for the value that you are adding

```swift
FeatureStore.set(false, for: Features.Module.myNewFeature, on: .primary)
FeatureStore.set(true, for: Features.Module.myNewFeature, on: .secondary)
```

Not recommended but possible

```Swift
FeatureStore.set(true, for: "My new revolutionary Feature", on: .secondary)
```

### Deletion

You can remove all the values saved on any source

```swift
FeatureStore.removeAll(from: .primary)
```

Or you can delete just the values for a specific feature

```swift
FeatureStore.remove(feature: "My new revolutionary Feature", from: .primary)
FeatureStore.remove(feature: Features.Module.myNewFeature, from: .secondary)
```

## About Creating cases for the Features Name

It is expected from you to use a namespace for the Feature Names, although the code does not enforce this.

You extends `Features` adding a new enum for your **Module** that has to conform to the `FeatureName` protocol.

```swift
extension Features {
    enum Module: String, FeatureName {
        case myNewFeature
        
        var description: String { rawValue }        
    }
}
```
