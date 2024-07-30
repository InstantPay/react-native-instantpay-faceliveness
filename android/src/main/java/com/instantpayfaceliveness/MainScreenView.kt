package com.instantpayfaceliveness

import android.app.UiModeManager
import android.content.Context
import android.content.res.ColorStateList
import android.graphics.PorterDuff
import android.graphics.drawable.ColorDrawable
import android.util.Base64
import android.util.Log
import android.view.LayoutInflater
import android.view.View
import android.widget.LinearLayout
import android.widget.TextView
import androidx.appcompat.app.AppCompatDelegate
import androidx.compose.foundation.isSystemInDarkTheme
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.darkColorScheme
import androidx.compose.material3.lightColorScheme
import androidx.compose.runtime.Composable
import androidx.compose.ui.graphics.Color
import androidx.constraintlayout.widget.ConstraintLayout
import androidx.core.view.isVisible
import com.amplifyframework.AmplifyException
import com.amplifyframework.auth.cognito.AWSCognitoAuthPlugin
import com.amplifyframework.core.Amplify
import com.amplifyframework.ui.liveness.model.FaceLivenessDetectionException
import com.amplifyframework.ui.liveness.ui.FaceLivenessDetector
import com.facebook.react.bridge.Arguments
import com.facebook.react.bridge.ReactContext
import com.facebook.react.bridge.WritableMap
import com.facebook.react.uimanager.events.RCTEventEmitter
import com.instantpayfaceliveness.databinding.MainscreenBinding
import org.json.JSONObject
import org.json.JSONTokener
import androidx.appcompat.widget.LinearLayoutCompat
import androidx.core.content.ContextCompat
import androidx.core.graphics.drawable.DrawableCompat
import androidx.core.view.isEmpty
import aws.smithy.kotlin.runtime.time.Instant
import com.amplifyframework.auth.AWSCredentials
import com.amplifyframework.auth.AWSCredentialsProvider
import com.amplifyframework.auth.AuthException
import com.amplifyframework.core.Consumer
import org.json.JSONArray
import com.amplifyframework.auth.AWSTemporaryCredentials


class MainScreenView(context: Context) : ConstraintLayout(context){

    /**
     * use of  : AbstractComposeView(context)
     * If Want to call without any layout then
     * direct call AbstractComposeView(context) and override the defined method like Content()
     */

    var isAmplifyConfigured = false
    var mainScreenBinding: MainscreenBinding? = null
    private val SUCCESS = "SUCCESS"
    private val ERROR = "ERROR"
    private val CANCEL = "CANCEL"
    private val methodsName = mapOf<String,String>("SUCCESS" to "onSuccessCallbackEvent",
        "ERROR" to "onErrorCallbackEvent", "CANCEL" to "onCancelCallbackEvent")

    var facelivenessOptions = mutableMapOf<Any,Any>(
        "debug" to false,
        "sessionId" to "",
        "accessToken" to "",
        "welcomeScreenConfig" to mutableMapOf<Any,Any>(
            "hideScreen" to false,
            "proceedButtonText" to  "Proceed Liveness Check",
            "description" to "You will go through a face verification process to prove that you are a real person.",
            "instructionPoint" to arrayOf(
                "When an oval appears, fill the oval with your face within 7 seconds.",
                "Maximize your screen's brightness.",
                "Make sure your face is not covered with sunglasses or a mask.",
                "Move to a well-lit place that is not in direct sunlight.",
                "This check displays colored lights. Use caution if you are photosensitive."
            ),
            "extraInstructionPoint" to ArrayList<String>()
        ),
        "verificationScreenConfig" to mutableMapOf<Any,Any>(
            //"hidePhotosensitiveWarning" to false,
            "hideIntroScreen" to false
        ),
        "config" to mutableMapOf<Any,Any>(
            "hideTitleBar" to false,
            "title" to "Liveness Check",
            "titleColor" to "#000000",
            "hideCloseButton" to false,
            "color" to mutableMapOf<Any,Any>(
                "primaryLight" to "#7DD6E8",
                "onPrimaryLight" to "#FFFFFF",
                "backgroundLight" to "#FFFFFF",
                "onBackgroundLight" to "#000000",
                "primaryDark" to "#047D95",
                "onPrimaryDark" to "#FAFAFA",
                "backgroundDark" to "#FAFAFA",
                "onBackgroundDark" to "#FFFFFF",
            )
        ),
    )

    var LightColorScheme = lightColorScheme()

    var DarkColorScheme = darkColorScheme()

    /*private val LightColorScheme = lightColorScheme(
        primary = Color(android.graphics.Color.parseColor("#"+Integer.toHexString(resources.getColor(R.color.ipayFacelivenessPrimary) ))),
        onPrimary = Color(android.graphics.Color.parseColor("#"+Integer.toHexString(resources.getColor(R.color.ipayFacelivenessOnPrimary) ))),
        background = Color(android.graphics.Color.parseColor("#"+Integer.toHexString(resources.getColor(R.color.ipayFacelivenessBackground) ))),
        onBackground = Color(android.graphics.Color.parseColor("#"+Integer.toHexString(resources.getColor(R.color.ipayFacelivenessOnBackground) ))),
    )

    private val DarkColorScheme = darkColorScheme(
        primary = Color(android.graphics.Color.parseColor("#"+Integer.toHexString(resources.getColor(R.color.ipayFacelivenessPrimary) ))),
        onPrimary = Color(android.graphics.Color.parseColor("#"+Integer.toHexString(resources.getColor(R.color.ipayFacelivenessOnPrimary) ))),
        background = Color(android.graphics.Color.parseColor("#"+Integer.toHexString(resources.getColor(R.color.ipayFacelivenessBackground) ))),
        onBackground = Color(android.graphics.Color.parseColor("#"+Integer.toHexString(resources.getColor(R.color.ipayFacelivenessOnBackground) ))),
    )*/

    init {

        //inflate(context, R.layout.mainscreen, this)

        //inflateLayout()
    }

    private fun inflateLayout() {
        mainScreenBinding = MainscreenBinding.inflate(LayoutInflater.from(context), this, true)
    }

    fun openFaceliveness(view : View,options: String){

        mainScreenBinding = null

        inflateLayout()

        val binding = MainscreenBinding.bind(view)

        //isAmplifyConfigured = false

        //mainScreenBinding?.composeViewForFaceliveness?.setContent {  }

        binding.composeViewForFaceliveness.setContent { }

        if(!isAmplifyConfigured){

            try {

                //Amplify.addPlugin(AWSCognitoAuthPlugin())

                //Amplify.configure(context)

                isAmplifyConfigured = true

            } catch (e: AmplifyException) {
                // Amplify is not configured
                isAmplifyConfigured = false
            }
        }

        val items = JSONTokener(options).nextValue() as JSONObject

        if(items.has("sessionId")){

            facelivenessOptions.put("sessionId", items.getString("sessionId"))
        }

        if(items.has("accessToken")){

            facelivenessOptions.put("accessToken", items.getString("accessToken"))
        }

        var titleColor: String = ""

        var btnBackgroundColor:String = ""
        var btnTextColor:String = ""
        var backgroundColor: String = ""
        var textColor:String = ""


        //Config options
        if (items.has("config")){

            val defaultConfigParam = (facelivenessOptions["config"] as? MutableMap<Any, Any>)

            val itemConfigParam = items.getJSONObject("config")

            if(itemConfigParam.has("title") && itemConfigParam.getString("title").isNotEmpty()){

                val getTitle = itemConfigParam.getString("title")

                binding.titleTextView.text = getTitle
            }
            else{
                binding.titleTextView.text = defaultConfigParam?.get("title").toString()
            }

            if(itemConfigParam.has("titleColor") && itemConfigParam.getString("titleColor").isNotEmpty()){

                binding.titleTextView.setTextColor(android.graphics.Color.parseColor(itemConfigParam.getString("titleColor")))

                titleColor = itemConfigParam.getString("titleColor")
            }
            else{
                binding.titleTextView.setTextColor(android.graphics.Color.parseColor(defaultConfigParam?.get("titleColor").toString()))

                titleColor = defaultConfigParam?.get("titleColor").toString()
            }

            if(itemConfigParam.has("hideCloseButton") && itemConfigParam.getBoolean("hideCloseButton")){

                binding.closeButton.visibility = View.GONE
            }
            else{
                binding.closeButton.visibility = View.VISIBLE
            }

            if(itemConfigParam.has("hideTitleBar") && itemConfigParam.getBoolean("hideTitleBar")){

                binding.titleLayout.visibility = View.GONE
            }
            else{
                binding.titleLayout.visibility = View.VISIBLE
            }

            val defaultColorConfig = (defaultConfigParam?.get("color") as? MutableMap<Any, Any>)

            var itemColorConfig: JSONObject

            if(itemConfigParam.has("color")){
                itemColorConfig  = itemConfigParam.getJSONObject("color")
            }
            else{
                itemColorConfig  = JSONObject()
            }

            var lightPrimary  = Color(android.graphics.Color.parseColor(defaultColorConfig?.get("primaryLight").toString()))
            var lightPrimaryHex = defaultColorConfig?.get("primaryLight")

            if(itemColorConfig.has("primaryLight") && itemColorConfig.getString("primaryLight").isNotEmpty()){
                lightPrimary = Color(android.graphics.Color.parseColor(itemColorConfig.getString("primaryLight").toString()))
                lightPrimaryHex = itemColorConfig.getString("primaryLight")
            }

            var lightOnPrimary  = Color(android.graphics.Color.parseColor(defaultColorConfig?.get("onPrimaryLight").toString()))
            var lightOnPrimaryHex = defaultColorConfig?.get("onPrimaryLight")

            if(itemColorConfig.has("onPrimaryLight") && itemColorConfig.getString("onPrimaryLight").isNotEmpty()){
                lightOnPrimary = Color(android.graphics.Color.parseColor(itemColorConfig.getString("onPrimaryLight").toString()))
                lightOnPrimaryHex = itemColorConfig.getString("onPrimaryLight")
            }

            var lightBackground  = Color(android.graphics.Color.parseColor(defaultColorConfig?.get("backgroundLight").toString()))
            var lightBackgroundHex = defaultColorConfig?.get("backgroundLight")

            if(itemColorConfig.has("backgroundLight") && itemColorConfig.getString("backgroundLight").isNotEmpty()){
                lightBackground = Color(android.graphics.Color.parseColor(itemColorConfig.getString("backgroundLight").toString()))
                lightBackgroundHex = itemColorConfig.getString("backgroundLight")
            }

            var lightOnBackground  = Color(android.graphics.Color.parseColor(defaultColorConfig?.get("onBackgroundLight").toString()))
            var lightOnBackgroundHex = defaultColorConfig?.get("onBackgroundLight")

            if(itemColorConfig.has("onBackgroundLight") && itemColorConfig.getString("onBackgroundLight").isNotEmpty()){
                lightOnBackground = Color(android.graphics.Color.parseColor(itemColorConfig.getString("onBackgroundLight").toString()))
                lightOnBackgroundHex = itemColorConfig.getString("onBackgroundLight")
            }

            //Dark Color Started
            var darkPrimary  = Color(android.graphics.Color.parseColor(defaultColorConfig?.get("primaryDark").toString()))
            var darkPrimaryHex = defaultColorConfig?.get("primaryDark")

            if(itemColorConfig.has("primaryDark") && itemColorConfig.getString("primaryDark").isNotEmpty()){
                darkPrimary = Color(android.graphics.Color.parseColor(itemColorConfig.getString("primaryDark").toString()))
                darkPrimaryHex = itemColorConfig.getString("primaryDark")
            }

            var darkOnPrimary  = Color(android.graphics.Color.parseColor(defaultColorConfig?.get("onPrimaryDark").toString()))
            var darkOnPrimaryHex = defaultColorConfig?.get("onPrimaryDark")

            if(itemColorConfig.has("onPrimaryDark") && itemColorConfig.getString("onPrimaryDark").isNotEmpty()){
                darkOnPrimary = Color(android.graphics.Color.parseColor(itemColorConfig.getString("onPrimaryDark").toString()))
                darkOnPrimaryHex = itemColorConfig.getString("onPrimaryDark")
            }

            var darkBackground  = Color(android.graphics.Color.parseColor(defaultColorConfig?.get("backgroundDark").toString()))
            var darkBackgroundHex = defaultColorConfig?.get("backgroundDark")
            if(itemColorConfig.has("backgroundDark") && itemColorConfig.getString("backgroundDark").isNotEmpty()){
                darkBackground = Color(android.graphics.Color.parseColor(itemColorConfig.getString("backgroundDark").toString()))
                darkBackgroundHex = itemColorConfig.getString("backgroundDark")
            }

            var darkOnBackground  = Color(android.graphics.Color.parseColor(defaultColorConfig?.get("onBackgroundDark").toString()))
            var darkOnBackgroundHex = defaultColorConfig?.get("onBackgroundDark")

            if(itemColorConfig.has("onBackgroundDark") && itemColorConfig.getString("onBackgroundDark").isNotEmpty()){
                darkOnBackground = Color(android.graphics.Color.parseColor(itemColorConfig.getString("onBackgroundDark").toString()))
                darkOnBackgroundHex = itemColorConfig.getString("onBackgroundDark")
            }

            if (isDarkMode(context)) {

                backgroundColor = darkBackgroundHex.toString()

                textColor = darkOnBackgroundHex.toString()

                btnBackgroundColor = darkPrimaryHex.toString()

                btnTextColor = darkOnPrimaryHex.toString()

            } else {

                backgroundColor = lightBackgroundHex.toString()

                textColor = lightOnBackgroundHex.toString()

                btnBackgroundColor = lightPrimaryHex.toString()

                btnTextColor =  lightOnPrimaryHex.toString()
            }

            LightColorScheme = lightColorScheme(
                primary = lightPrimary,
                onPrimary = lightOnPrimary,
                background = lightBackground,
                onBackground = lightOnBackground,
            )

            DarkColorScheme = darkColorScheme(
                primary = darkPrimary,
                onPrimary = darkOnPrimary,
                background = darkBackground,
                onBackground = darkOnBackground,
            )

        }

        //Welcome Screen Config
        if(items.has("welcomeScreenConfig")){

            val colorCodeForBtn = android.graphics.Color.parseColor(btnBackgroundColor)

            binding.startFacelivenessButton.backgroundTintList = ColorStateList.valueOf(colorCodeForBtn)

            binding.startFacelivenessButton.setTextColor(android.graphics.Color.parseColor(btnTextColor))

            if (isColorDark(colorCodeForBtn)) {
                //Dark Color

            } else {
                //Light Color
            }

            val colorCodeForScreenBackground = android.graphics.Color.parseColor(backgroundColor)

            binding.mainConstraintLayout.backgroundTintList = ColorStateList.valueOf(colorCodeForScreenBackground)

            val closeIcon = ContextCompat.getDrawable(context, R.drawable.ic_close_24)

            closeIcon?.setColorFilter(android.graphics.Color.parseColor(titleColor), PorterDuff.Mode.SRC_IN)

            binding.closeButton.setImageDrawable(closeIcon)

            binding.descriptionTextview.setTextColor(android.graphics.Color.parseColor("#66${textColor.replace("#","")}"))

            binding.imageTitle.setTextColor(android.graphics.Color.parseColor(textColor))

            if (isColorDark(colorCodeForScreenBackground)) {

            }
            else{

            }

            val defaultWelComeScreenConfig = (facelivenessOptions["welcomeScreenConfig"] as? MutableMap<Any, Any>)

            val itemWelComeScreenConfig = items.getJSONObject("welcomeScreenConfig")

            if(itemWelComeScreenConfig.has("hideScreen") && itemWelComeScreenConfig.getBoolean("hideScreen")){
                //If Welcome Screen visibility is gone

                defaultWelComeScreenConfig?.put("hideScreen", itemWelComeScreenConfig.getBoolean("hideScreen"))

                binding.welcomeScreenLayout.visibility = View.GONE

                binding.verificationScreenLayout.visibility = View.VISIBLE

                binding.composeViewForFaceliveness.setContent {

                    showVerificationSystem()
                }
            }
            else{//If Welcome Screen visibility is visible

                defaultWelComeScreenConfig?.put("hideScreen", false)

                binding.verificationScreenLayout.visibility = View.INVISIBLE
                binding.welcomeScreenLayout.visibility = View.VISIBLE
            }

            if(itemWelComeScreenConfig.has("proceedButtonText") && itemWelComeScreenConfig.getString("proceedButtonText").isNotEmpty()){

                binding.startFacelivenessButton.text = itemWelComeScreenConfig.getString("proceedButtonText")
            }
            else{

                binding.startFacelivenessButton.text = defaultWelComeScreenConfig?.get("proceedButtonText").toString()
            }

            if(itemWelComeScreenConfig.has("description") && itemWelComeScreenConfig.getString("description").isNotEmpty()){

                binding.descriptionTextview.text = itemWelComeScreenConfig.getString("description")
            }
            else{

                binding.descriptionTextview.text = defaultWelComeScreenConfig?.get("description").toString()
            }

            var instructionList = defaultWelComeScreenConfig?.get("instructionPoint") as Array<Any>

            if(itemWelComeScreenConfig.has("extraInstructionPoint")){

                val extraInstructionListObject = itemWelComeScreenConfig.getJSONArray("extraInstructionPoint")

                val extraInstructionList = jsonArrayToArray(extraInstructionListObject) as Array<Any>

                instructionList = combine(instructionList, extraInstructionList)
            }

            for ((index, value) in instructionList.withIndex()){

                val linearLayout = LinearLayoutCompat(context)

                val layoutParams = LinearLayout.LayoutParams(
                    LinearLayout.LayoutParams.MATCH_PARENT,
                    LinearLayout.LayoutParams.WRAP_CONTENT
                )
                layoutParams.bottomMargin = dpToPx(5)
                linearLayout.layoutParams = layoutParams
                linearLayout.orientation = LinearLayoutCompat.HORIZONTAL


                val textView1 = TextView(context)

                val textLayoutParams = LinearLayout.LayoutParams(
                    LinearLayout.LayoutParams.WRAP_CONTENT,
                    LinearLayout.LayoutParams.WRAP_CONTENT
                )
                textView1.layoutParams = textLayoutParams
                textView1.text = (index+1).toString()+". "

                textView1.setTextColor(android.graphics.Color.parseColor("#70${textColor.replace("#","")}"))

                if (isColorDark(colorCodeForScreenBackground)) {

                }
                else{

                }

                linearLayout.addView(textView1)

                val textView2 = TextView(context)
                textView2.layoutParams = textLayoutParams
                textView2.text = value.toString()

                textView2.setTextColor(android.graphics.Color.parseColor("#70${textColor.replace("#","")}"))

                if (isColorDark(colorCodeForScreenBackground)) {

                }
                else{

                }

                linearLayout.addView(textView2)

                binding.instructionList.addView(linearLayout)
            }
        }

        //Verification Screen Config
        if(items.has("verificationScreenConfig")){

            val defaultVerificationScreenConfig = (facelivenessOptions["verificationScreenConfig"] as? MutableMap<Any, Any>)

            val itemVerificationScreenConfig = items.getJSONObject("verificationScreenConfig")

            if(itemVerificationScreenConfig.has("hideIntroScreen") && itemVerificationScreenConfig.getBoolean("hideIntroScreen")){
                defaultVerificationScreenConfig?.put("hideIntroScreen", itemVerificationScreenConfig.getBoolean("hideIntroScreen"))
            }
            else{
                defaultVerificationScreenConfig?.put("hideIntroScreen", false)
            }
        }

        //On Start button Handler
        binding.startFacelivenessButton.setOnClickListener {

            binding.welcomeScreenLayout.visibility = View.GONE

            binding.verificationScreenLayout.visibility = View.VISIBLE

            binding.composeViewForFaceliveness.setContent {

                showVerificationSystem()
            }
        }

        //Close button Handler and back button handler
        binding.closeButton.setOnClickListener{

            if(binding.welcomeScreenLayout.isVisible){
                //User on WelcomeScreen

                val output = Arguments.createMap().apply {
                    putString("message", "Cancel by User")
                }

                onSendReactNativeEvent(CANCEL, output)
            }

            if(binding.verificationScreenLayout.isVisible){
                //User on Verification Screen

                isAmplifyConfigured = false

                val defaultWelComeScreenConfig = (facelivenessOptions["welcomeScreenConfig"] as? MutableMap<Any, Any>)

                if(defaultWelComeScreenConfig?.get("hideScreen") == true){

                    val output = Arguments.createMap().apply {
                        putString("message", "Cancel by User on Verification Screen")
                    }

                    onSendReactNativeEvent(CANCEL, output)
                }
                else{

                    binding.verificationScreenLayout.visibility = View.INVISIBLE

                    binding.welcomeScreenLayout.visibility = View.VISIBLE

                    if (isAmplifyConfigured) {

                    } else {

                        //Clear SetContent for FaceLivenessDetector start
                        binding.composeViewForFaceliveness.setContent {

                        }
                    }
                }
            }
        }
    }

    @Composable
    fun showVerificationSystem(){

        /*Amplify.Auth.fetchAuthSession(
            { result: AuthSession ->

                Log.i(
                    InstantpayFacelivenessViewManager.LOG_TAG,
                    "Success :" + result.toString()
                )
            }
        ) { error: AuthException ->
            Log.e(
                InstantpayFacelivenessViewManager.LOG_TAG,
                "Failed :" + error.toString()
            )
        }*/

        val defaultVerificationScreenConfig = (facelivenessOptions["verificationScreenConfig"] as? MutableMap<Any, Any>)

        MyTheme {

            FaceLivenessDetector(
                sessionId = facelivenessOptions.get("sessionId").toString(),
                region = "ap-south-1",
                disableStartView = defaultVerificationScreenConfig?.get("hideIntroScreen") as Boolean,
                onComplete = {
                    val output = Arguments.createMap().apply {
                        putString("sessionId", facelivenessOptions.get("sessionId").toString())
                    }
                    onSendReactNativeEvent(SUCCESS, output)
                },
                onError = { error: FaceLivenessDetectionException ->
                    if (error.throwable != null) {
                        val output = Arguments.createMap().apply {
                            putString("errorMessage", error.throwable!!.message.toString())
                            putString("errorCause", error.throwable!!.cause.toString())
                            putString("recoverySuggestion", error.recoverySuggestion)
                        }
                        onSendReactNativeEvent(ERROR, output)
                    } else {
                        val output = Arguments.createMap().apply {
                            putString("errorMessage", error.message.toString())
                        }
                        onSendReactNativeEvent(ERROR, output)
                    }
                },
                credentialsProvider = MyCredentialsProvider(facelivenessOptions.get("accessToken").toString())
            )
        }
    }

    fun clearFacelivenessScreen(){

        isAmplifyConfigured = false

        mainScreenBinding?.composeViewForFaceliveness?.setContent {


        }
    }

    fun onSendReactNativeEvent(type:String, data: WritableMap? = null) {

        var nameOfEvent = ""
        var event: WritableMap = Arguments.createMap()

        if(type == SUCCESS){
            nameOfEvent = methodsName[type].toString()

            if(data!=null){
                event = data
            }
        }
        else if(type == CANCEL){
            nameOfEvent = methodsName[type].toString()

            if(data!=null){
                event = data
            }
        }
        else{
            nameOfEvent = methodsName[type].toString()

            if(data!=null){
                event = data
            }
        }

        val reactContext = context as ReactContext
        reactContext.getJSModule(RCTEventEmitter::class.java).receiveEvent(id, nameOfEvent, event)
    }

    @Composable
    fun MyTheme(content: @Composable () -> Unit){

        val colorScheme =
            if (!isSystemInDarkTheme()) {
                LightColorScheme
            } else {
                DarkColorScheme
            }

        MaterialTheme(
            // Override colorScheme with custom colors
            colorScheme = colorScheme,
            // Override shapes with custom shapes
            shapes = MaterialTheme.shapes,
            // Override typography with custom typography
            typography = MaterialTheme.typography,
            content = content
        )
    }

    private fun logPrint(value: String?) {
        if (value == null) {
            return
        }
        Log.i(InstantpayFacelivenessViewManager.LOG_TAG, value)
    }

    private fun dpToPx(dp: Int): Int {
        val scale = resources.displayMetrics.density
        return (dp * scale + 0.5f).toInt()
    }

    private fun jsonArrayToArray(jsonArray: JSONArray): Array<Any?> {
        val array = Array<Any?>(jsonArray.length()) { null }

        for (i in 0 until jsonArray.length()) {
            array[i] = jsonArray[i]
        }

        return array
    }

    private fun combine(arr1: Array<Any>, arr2: Array<Any>): Array<Any> {
        val mergedArray = Array<Any>(arr1.size + arr2.size) { 0 }

        var position = 0
        for (element in arr1) {
            mergedArray[position] = element
            position++
        }

        for (element in arr2) {
            mergedArray[position] = element
            position++
        }

        return mergedArray
    }

    private fun isColorDark(color: Int): Boolean {
        val darkness = 1 - (0.299 * android.graphics.Color.red(color) + 0.587 * android.graphics.Color.green(color) + 0.114 * android.graphics.Color.blue(color)) / 255
        return darkness >= 0.5
    }

    private fun isDarkMode(context: Context): Boolean {
        val uiModeManager = context.getSystemService(Context.UI_MODE_SERVICE) as UiModeManager
        return uiModeManager.nightMode == UiModeManager.MODE_NIGHT_YES
    }

    /*@Composable
    override fun Content() {

        Amplify.addPlugin(AWSCognitoAuthPlugin())

        Amplify.configure(context)

        Amplify.Auth.fetchAuthSession(
            { result: AuthSession ->
                Log.i(
                    InstantpayFacelivenessViewManager.LOG_TAG,
                    "Success :" + result.toString()
                )
            }
        ) { error: AuthException ->
            Log.e(
                InstantpayFacelivenessViewManager.LOG_TAG,
                "Failed :" + error.toString()
            )
        }

        FaceLivenessDetector(
            sessionId = "29868f9f-8372-4d82-ae6d-97ef8941b2cd",
            region = "ap-south-1",
            onComplete = {
                logPrint("Face Liveness flow is complete")
            },
            onError = { error ->
                Log.e(InstantpayFacelivenessViewManager.LOG_TAG, "Error during Face Liveness flow", error.throwable)
            }
        )
    }*/

    class MyCredentialsProvider(private var accessToken: String) : AWSCredentialsProvider<AWSCredentials>{

        override fun fetchAWSCredentials(
            onSuccess: Consumer<AWSCredentials>,
            onError: Consumer<AuthException>
        ) {
            try {
                val credentials: AWSTemporaryCredentials = fetchCredentialsFromSomewhere()

                onSuccess.accept(credentials)
            } catch (e: Exception) {
                onError.accept(AuthException(e.message ?: "Unknown error occurred", "Please check your credentials and try again."))
            }
        }

        private fun fetchCredentialsFromSomewhere(): AWSTemporaryCredentials {

            val decodedBytes: ByteArray = Base64.decode(accessToken, Base64.DEFAULT)
            val decodedString: String = decodedBytes.toString(Charsets.UTF_8)

            val splitData = decodedString.split("##")

            val data3 = splitData[0];

            val data2 = reverseString(splitData[1]);

            val data1 = reverseString(splitData[2]);

            val accessKeyId = data1
            val secretAccessKey = data2
            val sessionToken = data3
            val unixTimestamp: Double = 1.72042503E9

            val secondsSinceEpoch: Long = unixTimestamp.toLong()  // Convert to Long

            val instant: Instant = Instant.fromEpochSeconds(secondsSinceEpoch)

            return AWSTemporaryCredentials(accessKeyId, secretAccessKey, sessionToken, instant)
        }

        private fun logPrint(value: String?) {
            if (value == null) {
                return
            }
            Log.i(InstantpayFacelivenessViewManager.LOG_TAG, value)
        }

        private fun reverseString(input: String): String {
            return StringBuilder(input).reverse().toString()
        }
    }
}
