# vestasleep

## New envionment setup

Get the SHA1 of the key and follow the next guide 

https://developers.google.com/fit/android/get-api-key?hl=es-419


Go to the google cloud project enable the fit api

Create an oauth credential

This credential it's tied to the project by using the package name

## Before deploying

1. Change the version in the `pubspec.yaml` file.
2. Change the constants in the `lib/constants.dart` file to avoid mocked data.
3. Push a new tag to the repository.
4. Build should be triggered in the CI/CD pipeline.
