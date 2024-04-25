import React, {useEffect, useState} from 'react';

import { StyleSheet, View, Button } from 'react-native';
import { InstantpayFacelivenessView } from 'react-native-instantpay-faceliveness';

export default function App() {


    const [showFaceliveness, setShowFaceliveness] = useState(false)
    const [optionsItem, setOptionsItem] = useState("")

    useEffect(() => {

        let items = JSON.stringify({
            debug : false,
            sessionId : '',
            welcomeScreenConfig : {
                hideScreen: false,
                proceedButtonText : "",
                description : "",
                extraInstructionPoint : []
            },
            verificationScreenConfig : {
                hideIntroScreen : false
            },
            config: {
                hideTitleBar : false,
                title : "",
                //titleColor : "#7DD6E8",
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
                        color="#ffffff" 
                        style={styles.box}
                        options={optionsItem}
                        onCancelCallback={(event) => onCancelCallbackHandeler(event)}
                        onErrorCallback={(event) => onErrorCallbackHandeler(event)}
                        onSuccessCallback={(event) => onSuccessCallbackHandeler(event)}
                    /> : <></>
            }
            
        </View>
    );
}

const styles = StyleSheet.create({
    container: {
        flex: 1,
        //alignItems: 'center',
        //justifyContent: 'center',
    },
    box: {
        width: '100%',
        height: '100%',
        //marginVertical: 20,
    },
});
