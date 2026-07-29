# sm_network_proxy example

This Flutter app demonstrates:

- Reading the Android or iOS system proxy
- Injecting the resulting adapter into `sm_network`
- Configuring nested response-envelope paths
- Converting response data into a `Person` model with `Session<Person>`

Run it on Android or iOS:

```shell
flutter pub get
flutter run
```

The request uses `https://httpbingo.org/post`, so the device or simulator needs
network access.
