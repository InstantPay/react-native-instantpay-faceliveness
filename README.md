# react-native-instantpay-faceliveness

Face Liveness verifies that only real users, not bad actors using spoofs, can access your services

## Installation

```sh
npm install react-native-instantpay-faceliveness
```

## Configuration for iOS

1. Please install the Swift package by following these steps:

    1. Go to File -> Add Package.
    2. In the search bar, enter the following URL: https://github.com/aws-amplify/amplify-ui-swift-liveness, and press Enter.
    3. Wait for the results to load. Once the Amplify UI Swift Liveness repository appears, you’ll see options to select the version of Liveness you want to install.
    4. Choose the "Up to Next Major Version" option, which will install the latest compatible version of the dependency.
    5. Click Add Package.
    6. In the next screen, select the FaceLiveness product, and click Add Package.

2. Require the `setup` script in your `Podfile`:

```diff
# Transform this into a `node_require` generic function:
- # Resolve react_native_pods.rb with node to allow for hoisting
- require Pod::Executable.execute_command('node', ['-p',
-   'require.resolve(
-     "react-native/scripts/react_native_pods.rb",
-     {paths: [process.argv[1]]},
-   )', __dir__]).strip

+ def node_require(script)
+   # Resolve script with node to allow for hoisting
+   require Pod::Executable.execute_command('node', ['-p',
+     "require.resolve(
+       '#{script}',
+       {paths: [process.argv[1]]},
+     )", __dir__]).strip
+ end

# Use it to require both react-native's and this package's scripts:
+ node_require('react-native/scripts/react_native_pods.rb')
+ node_require('react-native-instantpay-faceliveness/scripts/setup.rb')
```

3. In the same `Podfile`, call `setup_faceliveness` with the configuration required:

```ruby
# …

platform :ios, min_ios_version_supported
prepare_react_native_project!

# ⬇️ Add 
setup_faceliveness({
  "targetName" => "<Target-Name>", #Replace with project Target Name
})
# …
```

4. Then execute `pod install` in your `ios` directory _(📌  Note that it must be re-executed each time you update this config)_.

## Usage

```js
//Possible Options

{
    debug : false,
    sessionId : "", //String
    accessToken : "", //String
    welcomeScreenConfig : {
        hideScreen: false,
        proceedButtonText : "", //String
        description : "", //String
        extraInstructionPoint : [] //Array
    },
    verificationScreenConfig : {
        hideIntroScreen : false
    },
    config: {
        hideTitleBar : false,
        title : "", //String
        titleColor : "#000000", 
        hideCloseButton : false,
        color : {
            primaryLight : "#7DD6E8", // Primary color; eg: set on button color background
            onPrimaryLight : "#FFFFFF", // on screen button text color
            backgroundLight : "#FFFFFF", // on screen background
            onBackgroundLight : "#000000", // on screen Text Color
            primaryDark : "#047D95",
            onPrimaryDark : "#FAFAFA",
            backgroundDark : "#FAFAFA",
            onBackgroundDark : "#FFFFFF",
        }
    }
}

```

```js
import { InstantpayFacelivenessView } from "react-native-instantpay-faceliveness";

// ...

    const [showFaceliveness, setShowFaceliveness] = useState(false)
    const [optionsItem, setOptionsItem] = useState("")

    useEffect(() => {

        let items = JSON.stringify({
            debug : false,
            sessionId : '',
            welcomeScreenConfig : {
                hideScreen: false,
            },
            verificationScreenConfig : {
                hideIntroScreen : false
            },
            config: {
                hideTitleBar : false,
                hideCloseButton : false,
            }
        });

        setOptionsItem(items);

    },[]);

    const startFaceliveness = () => {

        setShowFaceliveness(true)
    }

    const onCancelCallbackHandeler = (event) => {

        setShowFaceliveness(false)

        console.log('onCancelCallbackHandeler', event.nativeEvent);
    }

    const onErrorCallbackHandeler = (event) => {

        setShowFaceliveness(false)

        console.log('onErrorCallbackHandeler', event.nativeEvent);
    }

    const onSuccessCallbackHandeler = (event) => {

        setShowFaceliveness(false)

        console.log('onSuccessCallbackHandeler', event.nativeEvent);
    }

    return (
        <View style={styles.container}>
            {
                !showFaceliveness ? 
                <>
                    <Button
                        title='Start faceliveness'
                        onPress={() => startFaceliveness()}
                    />
                </> : <></>
            }

            {
                
                optionsItem!="" && showFaceliveness ?
                    <InstantpayFacelivenessView 
                        style={styles.box}
                        options={optionsItem}
                        onCancelCallback={(event) => onCancelCallbackHandeler(event)}
                        onErrorCallback={(event) => onErrorCallbackHandeler(event)}
                        onSuccessCallback={(event) => onSuccessCallbackHandeler(event)}
                    /> : <></>
            }
            
        </View>
    );

    const styles = StyleSheet.create({
        container: {
            flex: 1,
        },
        box: {
            width: '100%',
            height: '100%',
        },
    });
```

## License

MIT

---

Created By [Instantpay](https://www.instantpay.in)