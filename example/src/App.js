import React, {useEffect, useState} from 'react';

import { StyleSheet, View, Button, SafeAreaView, Platform } from 'react-native';
import { InstantpayFacelivenessView } from 'react-native-instantpay-faceliveness';

export default function App() {


    const [showFaceliveness, setShowFaceliveness] = useState(false)
    const [optionsItem, setOptionsItem] = useState("")

    useEffect(() => {

        let items = JSON.stringify({
            debug : false,
            sessionId : '',
            accessToken : "",
            /* welcomeScreenConfig : {
                hideScreen: false,
                proceedButtonText : "",
                description : "",
                extraInstructionPoint : []
            },
            verificationScreenConfig : {
                hideIntroScreen : false
            },*/
            config: {
                hideTitleBar : false,
                title : "dsfdsf",
                titleColor : "#000000",
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
        <SafeAreaView style={styles.container}>
            
            <View style={{ padding:0}} >
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
        </SafeAreaView>
    );
}

const styles = StyleSheet.create({
    container: {
        flex: 1,
        margin: 10
        //alignItems: 'center',
        //justifyContent: 'center',
    },
    box: {
        width: '100%',
        height: '100%',
        //marginVertical: 20,
    },
});
