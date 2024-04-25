package com.instantpayfaceliveness

import android.content.Context
import android.content.pm.ActivityInfo
import androidx.compose.ui.graphics.Color
import android.util.Log
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.TextView
import androidx.core.view.marginBottom
import com.facebook.react.uimanager.SimpleViewManager
import com.facebook.react.uimanager.ThemedReactContext
import com.facebook.react.uimanager.annotations.ReactProp
import com.instantpayfaceliveness.databinding.MainscreenBinding
import org.json.JSONObject
import org.json.JSONTokener
import java.util.Objects

class InstantpayFacelivenessViewManager : SimpleViewManager<MainScreenView>() {
    override fun getName() = "InstantpayFacelivenessView"

    companion object{
        const val LOG_TAG = "facelivenessLog*"
    }

    override fun createViewInstance(reactContext: ThemedReactContext): MainScreenView {

        if(reactContext.hasCurrentActivity()){
            reactContext.currentActivity!!.requestedOrientation = ActivityInfo.SCREEN_ORIENTATION_PORTRAIT
        }

        return MainScreenView(reactContext)
    }

    override fun getExportedCustomBubblingEventTypeConstants(): Map<String, Any> {
        return mapOf(
            "onErrorCallbackEvent" to mapOf(
                "phasedRegistrationNames" to mapOf(
                    "bubbled" to "onErrorCallback"
                )
            ),
            "onSuccessCallbackEvent" to mapOf(
                "phasedRegistrationNames" to mapOf(
                    "bubbled" to "onSuccessCallback"
                )
            ),
            "onCancelCallbackEvent" to mapOf(
                "phasedRegistrationNames" to mapOf(
                    "bubbled" to "onCancelCallback"
                )
            ),
            "topChange" to mapOf(
                "phasedRegistrationNames" to mapOf(
                    "bubbled" to "onChange"
                )
            )
        )
    }

    /*@ReactProp(name = "color")
    fun setColor(view: View, color: String) {
        view.setBackgroundColor(android.graphics.Color.parseColor(color))
    }*/

    @ReactProp(name= "options")
    fun setOptions(view: MainScreenView, options: String){
        /*val parent = view.parent as? ViewGroup
        parent?.removeView(view)
        parent?.addView(view)*/
        view.openFaceliveness(view,options)
    }

    private fun logPrint(value: String?) {
        if (value == null) {
            return
        }
        Log.i(LOG_TAG, value)
    }

}
