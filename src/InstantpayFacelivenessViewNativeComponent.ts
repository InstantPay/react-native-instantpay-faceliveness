//import { codegenNativeComponent, type ViewProps, type CodegenTypes } from 'react-native';
//import type { BubblingEventHandler, DirectEventHandler } from 'react-native/Libraries/Types/CodegenTypes';
import { type ViewProps } from 'react-native';
import codegenNativeComponent from 'react-native/Libraries/Utilities/codegenNativeComponent';
import type {
  Double,
  Float,
  BubblingEventHandler,
  WithDefault,
} from 'react-native/Libraries/Types/CodegenTypes';

//BubblingEventHandler<EventType> → for events that bubble up through the view hierarchy.

//DirectEventHandler<EventType> → for events that don’t bubble (fired only on the target).
interface CancelEventData {
    message : string;
}

interface ErrorEventData {
    errorMessage : string;
    errorCause : string;
    recoverySuggestion : string;
}

interface SuccessEventData {
    sessionId : string;
}

interface NativeProps extends ViewProps {
    //color:string;
    options?: string;
    onCancelCallback?: BubblingEventHandler<Readonly<CancelEventData>>;
    onErrorCallback?: BubblingEventHandler<Readonly<ErrorEventData>>;
    onSuccessCallback?: BubblingEventHandler<Readonly<SuccessEventData>>;
}

export default codegenNativeComponent<NativeProps>('InstantpayFacelivenessView');