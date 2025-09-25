import React, { useState, useEffect, useContext } from 'react';
import { View, Text, StyleSheet, Button, BackHandler, Platform, ActivityIndicator } from 'react-native';
import { useNavigation } from '@react-navigation/native';
import { InstantpayFacelivenessView } from "react-native-instantpay-faceliveness";

const FacelivenessScreen = (props) => {   

    const { livenessOptions, isLivenessVisible } = props.route.params
    const [loadingScreen, setLoadingScreen] = useState(false);
    const [showFaceliveness, setShowFaceliveness] = useState(false);
    const navigation = useNavigation();

    useEffect(() => {

        const backHandler = BackHandler.addEventListener('hardwareBackPress',onBackActionEventFn);

        if(isLivenessVisible){
            console.log('called faceliveness page')
            if(Platform.OS == 'android'){
                //console.log("reached");
                setLoadingScreen(true);

                setTimeout(() => {
                    startFaceliveness();
                },500)
            }
            else{

                setLoadingScreen(true);

                setTimeout(() => {
                    startFaceliveness();
                },500)
            }
        } 

        return () => {
            console.log('close Faceliveness fired')
            backHandler.remove();
            setShowFaceliveness(false);
        }

    },[isLivenessVisible]);

    const startFaceliveness = () => {

        setLoadingScreen(false);

        setShowFaceliveness(true)
    }

    const onBackActionEventFn = () => {
        //console.log("fired onBackActionEventFn");
        return true;
    }

    const onCancelCallbackHandeler = (event) => {

        console.log('From Faceliveness onCancelCallbackHandeler', event.nativeEvent);

        handleBackToScreen({
            type : 'CANCEL',
            response : event
        })

    }

    const onErrorCallbackHandeler = (event) => {

       console.log('From Faceliveness onErrorCallbackHandeler', event.nativeEvent);

        handleBackToScreen({
            type : 'ERROR',
            response : event
        })

    }

    const onSuccessCallbackHandeler = (event) => {

        console.log('From Faceliveness onSuccessCallbackHandeler', event.nativeEvent);

        handleBackToScreen({
            type : 'SUCCESS',
            response : event
        })
    }

    const handleBackToScreen = (data) => {
        //console.log('handleBackToScreen',data);
        //if (callback) {
            //callback(data);
        //}

        navigation.goBack();
    };
  
    return (
        <View style={styles().container}>
            <ActivityIndicator animating={loadingScreen} />
            {
                showFaceliveness?
                    <InstantpayFacelivenessView 
                        style={styles().facelivenessBody}
                        options={livenessOptions}
                        onCancelCallback={(event) => onCancelCallbackHandeler(event)}
                        onErrorCallback={(event) => onErrorCallbackHandeler(event)}
                        onSuccessCallback={(event) => onSuccessCallbackHandeler(event)}
                    /> : <></>
            }
        </View>
    );
}

const styles = (prop = '') => StyleSheet.create({
    container: {
        width: '100%',
        height: '100%',
        backgroundColor: '#FFFFFF',
        paddingHorizontal :Platform.OS=="ios"? 20:5,
    },
    facelivenessBody: {
        width: '100%',
        height: '100%',
    },
});

export default FacelivenessScreen;