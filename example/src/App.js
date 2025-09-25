// In App.js in a new project

import * as React from 'react';
import { View, Text } from 'react-native';
import { NavigationContainer } from '@react-navigation/native';
import { createNativeStackNavigator } from '@react-navigation/native-stack';
import HomeScreen from './screens/HomeScreen';
import FacelivenessScreen from './screens/FacelivenessScreen';

const Stack = createNativeStackNavigator();

const AuthStack = createNativeStackNavigator();

export default function App() {
  return (
    <NavigationContainer>
        <Stack.Navigator>
            <Stack.Screen name="Home" component={HomeScreen} />
            <AuthStack.Group screenOptions={{ presentation: 'modal' }}>
                <AuthStack.Screen name="FacelivenessModal" component={FacelivenessScreen} options={{ headerShown: false }} />
            </AuthStack.Group>
        </Stack.Navigator>
    </NavigationContainer>
  );
}