import { useNavigation } from '@react-navigation/native';
import React, {useEffect, useState} from 'react';
import { StyleSheet, View, Button, Platform,Text } from 'react-native';

const HomeScreen = (props) => { 

    const navigation = useNavigation();

    const startFaceliveness = () => {

        let optionsItem = {
            sessionId: "",
            accessToken: "",
            welcomeScreenConfig: {
                proceedButtonText: 'Proceed'
            },
            verificationScreenConfig : {
                hideIntroScreen : true
            },
            config: {
                hideTitleBar: false,
                hideCloseButton: false,
                title: "Webcam Verification",
            },
        };

        navigation.navigate('FacelivenessModal', {
            livenessOptions: JSON.stringify(optionsItem),
            isLivenessVisible: true
        });
    }

    return (
        <View>
            <Button
                title='Navigate faceliveness'
                onPress={() => startFaceliveness()}
            />
        </View>
    );
    
}

const styles = StyleSheet.create({
    container: {
        flex: 1,
        margin: 10,
        //alignItems: 'center',
        //justifyContent: 'center',
    },
    box: {
        width: '100%',
        height: '100%',
        borderColor: '#000000',borderWidth: 1,
        //marginVertical: 20,
    },
});

export default HomeScreen;