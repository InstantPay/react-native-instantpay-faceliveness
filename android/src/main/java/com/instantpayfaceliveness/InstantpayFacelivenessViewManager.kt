package com.instantpayfaceliveness

import android.graphics.Color
import com.facebook.react.module.annotations.ReactModule
import com.facebook.react.uimanager.SimpleViewManager
import com.facebook.react.uimanager.ThemedReactContext
import com.facebook.react.uimanager.ViewManagerDelegate
import com.facebook.react.uimanager.annotations.ReactProp
import com.facebook.react.viewmanagers.InstantpayFacelivenessViewManagerInterface
import com.facebook.react.viewmanagers.InstantpayFacelivenessViewManagerDelegate

@ReactModule(name = InstantpayFacelivenessViewManager.NAME)
class InstantpayFacelivenessViewManager : SimpleViewManager<InstantpayFacelivenessView>(),
  InstantpayFacelivenessViewManagerInterface<InstantpayFacelivenessView> {
  private val mDelegate: ViewManagerDelegate<InstantpayFacelivenessView>

  init {
    mDelegate = InstantpayFacelivenessViewManagerDelegate(this)
  }

  override fun getDelegate(): ViewManagerDelegate<InstantpayFacelivenessView>? {
    return mDelegate
  }

  override fun getName(): String {
    return NAME
  }

  public override fun createViewInstance(context: ThemedReactContext): InstantpayFacelivenessView {
    return InstantpayFacelivenessView(context)
  }

  @ReactProp(name = "color")
  override fun setColor(view: InstantpayFacelivenessView?, color: String?) {
    view?.setBackgroundColor(Color.parseColor(color))
  }

  companion object {
    const val NAME = "InstantpayFacelivenessView"
  }
}
