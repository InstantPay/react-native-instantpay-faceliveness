import { codegenNativeComponent, type ViewProps, type CodegenTypes } from 'react-native';
//import type { BubblingEventHandler, DirectEventHandler } from 'react-native/Libraries/Types/CodegenTypes';


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
    onCancelCallback?: CodegenTypes.BubblingEventHandler<Readonly<CancelEventData>>;
    onErrorCallback?: CodegenTypes.BubblingEventHandler<Readonly<ErrorEventData>>;
    onSuccessCallback?: CodegenTypes.BubblingEventHandler<Readonly<SuccessEventData>>;
}

export default codegenNativeComponent<NativeProps>('InstantpayFacelivenessView');