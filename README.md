# twilio

## Description
This is a sample app to showcase integration of Twilio's SDK TwilioVerify on a native iOS environment.

The app has the following modules:
1. Sign In: Allows user to access the app using the user's credentials
2. Factors:
   - List: Shows all the factors that the user has.
   - Create factor: Allows the user to create a new factor.
3. Pending challenges: List of all pending challenges of a user's factor.

## How to run?
1. Clone the repo
2. Run xcodegen from root folder on your terminal.
```
xcodegen
```
3. Execute a pod install
```
pod install
```
4. Open .xcworkspace with xcode and run the app


## Integration with the webpage
To test integration with webpage, follow instructions to run on your machine the Twilio auth website (https://github.com/yafuquen/twilio-verify-example), and open on browser http://localhost:5000/

## Used frameworks
Besides TwilioVerify, Promisekit was used to facilitate reading of code blocks.
