package com.instantpayfaceliveness

import android.content.pm.ActivityInfo
import android.util.Log
import com.facebook.react.module.annotations.ReactModule
import com.facebook.react.uimanager.SimpleViewManager
import com.facebook.react.uimanager.ThemedReactContext
import com.facebook.react.uimanager.ViewManagerDelegate
import com.facebook.react.uimanager.annotations.ReactProp
import com.facebook.react.viewmanagers.InstantpayFacelivenessViewManagerInterface
import com.facebook.react.viewmanagers.InstantpayFacelivenessViewManagerDelegate

@ReactModule(name = InstantpayFacelivenessViewManager.NAME)
class InstantpayFacelivenessViewManager : SimpleViewManager<MainScreenView>(), InstantpayFacelivenessViewManagerInterface<MainScreenView> {

	companion object {
		const val NAME = "InstantpayFacelivenessView"
		const val LOG_TAG = "facelivenessLog*"
	}

	private val mDelegate: ViewManagerDelegate<MainScreenView>

  	init {
    	mDelegate = InstantpayFacelivenessViewManagerDelegate(this)
  	}

  	override fun getDelegate(): ViewManagerDelegate<MainScreenView>? {
    	return mDelegate
  	}

  	override fun getName(): String {
    	return NAME
  	}

  	public override fun createViewInstance(context: ThemedReactContext): MainScreenView {
		if(context.hasCurrentActivity()){
			context.currentActivity!!.requestedOrientation = ActivityInfo.SCREEN_ORIENTATION_PORTRAIT
		}
		return MainScreenView(context)
  	}

	//For old arch
	/*override fun getExportedCustomBubblingEventTypeConstants(): Map<String, Any> {
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
	}*/

	//Register Event in new fabric Arch
	/*override fun getExportedCustomDirectEventTypeConstants(): Map<String, Any> {
		return mapOf(
			"onCancelCallbackEvent" to mapOf("registrationName" to "onCancelCallback"),
			"onErrorCallbackEvent" to mapOf("registrationName" to "onErrorCallback"),
			"onSuccessCallbackEvent" to mapOf("registrationName" to "onSuccessCallback"),
		)
	}*/
	override fun getExportedCustomDirectEventTypeConstants(): MutableMap<String, Any> {
		return mutableMapOf(
			"onCancelCallback" to mapOf("registrationName" to "onCancelCallback"),
			"onErrorCallback" to mapOf("registrationName" to "onErrorCallback"),
			"onSuccessCallback" to mapOf("registrationName" to "onSuccessCallback"),
		)
	}

	@ReactProp(name = "options")
	override fun setOptions(view: MainScreenView, options: String?) {
		view.openFaceliveness(view,options)
	}

	private fun logPrint(value: String?) {
		if (value == null) {
			return
		}
		Log.i(LOG_TAG, value)
	}
}
