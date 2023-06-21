# Project Documentation: Recipy

## Table of Contents
1. [Introduction](#introduction)
2. [Features](#features)
3. [Build Instructions](#build-instructions)
4. [Installation](#installation)
5. [Usage](#usage)
6. [API Documentation](#api-documentation)
7. [Dependencies](#dependencies)
8. [Contributors](#contributors)
9. [License](#license)

## 1. Introduction <a name="introduction"></a>
The Recipy project aims to provide a simple yet enjoyable experience to the user when it comes to making cooking more accesible, it uses both an external API to fetch crucial recipe information along with my own API written in Node.js to handle user signup and ownership. For the server-side communication I used a mix of REST, express and the entire project uses mongoDB to house user objects.

## 2. Features <a name="features"></a>
- Fetching a list of recipes based on provided ingredients.
- Saving favourite recipes for later should the user desire to revisit a recipe.
- Functionality of searching a random recipe with the optional choice of diet.
- Fully functional signup, login and account deletion, passwords are hashed and the user account is secured with JWT with strong secret key encryption.
- Log in persistance for up to two hours for user comfort.

## 3. Build Instructions <a name="build-instructions"></a>
To build Recipy the following steps must be taken:

- In the backend folder, in Node.js create a config file that houses your mongoDB database key, provide it as an argument to the function in App.js that executes the server launch, alternatively pass it inside as a plain string (ONLY IF YOU DON'T PLAN TO SHARE THE FILES). Should you wish to plug the app into a hosting service, specify the database key as an environmental variable, based on the hosting service of choice and pass the variable into the function mentioned beforehand.

- In the frontend folder, create a .dart config file where you need to specify your Spoonacular API key and your apiUrl for the node app, the url will either be a plain string an instance of localhost (keep in mind mobile devices don't specifically use localhost) or a string with the url of the hosting service of your choice.

- Use the command "flutter pub get" to download all the package dependencies specified in pubspec.yaml.

- Use the command "flutter build appbundle" to create a bundle of APKs for publishing or alternatively use the command "flutter build apk --split-per-api" (Both commands might be different based on updates to Flutter, for full instructions refer to official Flutter documentation) to build 3 separate APK files that all work for a specified Kernel architecture.

## 4. Installation <a name="installation"></a>
To install and set up Recipy, follow these steps:

1. Make sure the mobile device uses an Android SDK of minimum 21.
2. Correctly choose the APK variant compatible with the device's Kernel architecture.
3. Download the APK file, open it, install the app and enjoy.

## 5. Usage <a name="usage"></a>
To use Recipy, follow these instructions:

1. Considering how Recipy is built, internet connection is required at all times, without it the app is redundant.
2. Sign up for a free user account, follow the correct email writing convention.
3. Log into your account, every user is logged in for a period of two hours even if the app is closed, afterwards a new log in is required for safety measures.

## 6. API Documentation <a name="api-documentation"></a>
- Endpoints used with Spoonacular: 
    -food/ingredients/autocomplete,
    -recipes/findByIngredients,
    -recipes/:Id/information (Id is a parameter housing specific recipe Id),
    -recipes/random,
- Endpoints used with Recipy's Node app API:
    -api/favourite/:_id,
    -api/favourite,
    -api/favourites,
    -/auth/login,
    -/auth/signup,
    -auth/:userId

All the methods for the Node endpoints are specified in backend's "controllers" folder.

## 7. Dependencies <a name="dependencies"></a>
- flutter (https://docs.flutter.dev)
- http: ^0.13.4 (https://pub.dev/packages/http)
- provider: ^6.0.1 (https://pub.dev/packages/provider)
- curved_navigation_bar: ^1.0.3 (https://pub.dev/packages/curved_navigation_bar)
- dio: ^5.2.0+1 (https://pub.dev/packages/dio)
- shared_preferences: ^2.0.8 (https://pub.dev/packages/shared_preferences)
- jwt_decoder (pub.dev/documentation/jwt_decoder)
- logger: ^1.1.0 (https://pub.dev/packages/logger)

## 8. Contributors <a name="contributors"></a>
    -Ven0m - Coding, app architecture
    -Wiktoria Stryjewska - Graphics used in the app (To be added at a later date)

## 9. License <a name="license"></a>
Recipy is released under the Apache-2.0 license. See the LICENSE file for more details.
