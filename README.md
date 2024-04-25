# react-native-instantpay-faceliveness

Face Liveness verifies that only real users, not bad actors using spoofs, can access your services

## Installation

```sh
npm install react-native-instantpay-faceliveness
```

## Usage

```js
//Possible Options

{
    debug : false,
    sessionId : '', //String
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
            primaryLight : "#7DD6E8",
            onPrimaryLight : "#FFFFFF",
            backgroundLight : "#FFFFFF",
            onBackgroundLight : "#000000",
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

## Contributing

See the [contributing guide](CONTRIBUTING.md) to learn how to contribute to the repository and the development workflow.

## License

MIT

---

Created By [Instantpay](https://www.instantpay.in)
